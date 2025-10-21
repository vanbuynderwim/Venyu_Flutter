import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../core/helpers/get_matched_helper.dart';
import '../../mixins/error_handling_mixin.dart';
import '../../mixins/paginated_list_view_mixin.dart';
import '../../models/prompt.dart';
import '../../models/requests/paginated_request.dart';
import '../../core/providers/app_providers.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/buttons/get_matched_button.dart';
import 'prompt_item.dart';
import 'prompt_detail_view.dart';
import 'prompt_entry_view.dart';

/// PromptsView - Dedicated view for user's prompts
/// 
/// This view displays the user's prompts and prompt responses in a dedicated tab.
/// Previously this content was part of the ProfileView's cards section.
/// 
/// Features:
/// - Display user's prompts in a scrollable list
/// - Pull-to-refresh functionality
/// - Empty state when no prompts available
/// - Prompt selection handling
class PromptsView extends StatefulWidget {
  const PromptsView({super.key});

  @override
  State<PromptsView> createState() => _PromptsViewState();
}

class _PromptsViewState extends State<PromptsView>
    with PaginatedListViewMixin<PromptsView>, ErrorHandlingMixin<PromptsView> {
  // Services
  late final ContentManager _contentManager;

  // State
  final List<Prompt> _prompts = [];
  List<Prompt>? _availablePrompts; // Available daily prompts to answer
  bool _isCheckingPrompts = false;

  @override
  void initState() {
    super.initState();
    AppLogger.debug('initState', context: 'PromptsView');
    _contentManager = ContentManager.shared;
    initializePagination();
    _loadPrompts();

    // Set up available prompts update callback
    _contentManager.addAvailablePromptsCallback(_onAvailablePromptsUpdate);

    // Check for available prompts to answer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForPrompts();
    });
  }

  @override
  Future<void> loadMoreItems() async {
    await _loadMorePrompts();
  }

  @override
  void dispose() {
    _contentManager.removeAvailablePromptsCallback(_onAvailablePromptsUpdate);
    super.dispose();
  }

  /// Callback for available prompts updates
  void _onAvailablePromptsUpdate(List<Prompt> prompts) {
    if (mounted) {
      setState(() {
        _availablePrompts = prompts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.promptsViewMyPromptsTitle),
        trailingActions: _availablePrompts != null && _availablePrompts!.isNotEmpty
            ? [
                PlatformIconButton(
                  padding: EdgeInsets.zero,
                  icon: Badge.count(
                    count: _availablePrompts!.length,
                    child: context.themedIcon('prompts'),
                  ),
                  onPressed: _showPromptsModal,
                ),
              ]
            : null,
      ),
      floatingActionButton: _prompts.isNotEmpty
          ? GetMatchedButton(
              buttonType: GetMatchedButtonType.fab,
              isFromPrompts: true,
              onModalClosed: (_) {
                // Always refresh when modal closes (user might have created a prompt)
                AppLogger.debug('Modal closed, refreshing prompts list', context: 'PromptsView');
                _handleRefresh();
              },
            )
          : null,
      usePadding: false,
      useSafeArea: true,
      body: isLoading
          ? const LoadingStateWidget()
          : _prompts.isEmpty
              ? RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          message: ServerListType.profilePrompts.emptyStateTitle(context),
                          description: ServerListType.profilePrompts.emptyStateDescription(context),
                          iconName: ServerListType.profilePrompts.emptyStateIcon,
                          fullHeight: true,
                          onAction: () => _handleGetMatchedPressed(),
                          actionText: l10n.promptsViewEmptyActionButton,
                          actionButtonIcon: context.themedIcon('edit'),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: _prompts.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _prompts.length) {
                        return buildLoadingIndicator();
                      }

                      final prompt = _prompts[index];
                      return PromptItem(
                        prompt: prompt,
                        showChevron: true,
                        showCounters: true,
                        onPromptSelected: _openPromptDetail,
                      );
                    },
                  ),
                ),
    );
  }


  /// Handles the Get Matched button press (both FAB and EmptyState button)
  Future<void> _handleGetMatchedPressed() async {
    await GetMatchedHelper.openGetMatchedModal(
      context: context,
      isFromPrompts: true,
      callerContext: 'PromptsView',
    );

    // Always refresh the list after modal closes
    // (user might have created a new prompt)
    await _handleRefresh();
  }

  

  /// Opens the new prompt detail view to show matches
  Future<void> _openPromptDetail(Prompt prompt) async {
    AppLogger.debug('Opening prompt detail view for prompt: ${prompt.label}', context: 'PromptsView');
    try {
      final result = await Navigator.push<bool>(
        context,
        platformPageRoute(
          context: context,
          builder: (context) => PromptDetailView(promptId: prompt.promptID),
        ),
      );

      // If prompt was deleted (result == true), remove it from the list locally
      if (result == true && mounted) {
        AppLogger.debug('Prompt was deleted, removing from list', context: 'PromptsView');
        setState(() {
          _prompts.removeWhere((p) => p.promptID == prompt.promptID);
        });
      }

      AppLogger.debug('Prompt detail view closed', context: 'PromptsView');
    } catch (error) {
      AppLogger.error('Error opening prompt detail view: $error', context: 'PromptsView');
    }
  }

  Future<void> _loadPrompts({bool forceRefresh = false}) async {
    final authService = context.authService;
    if (!authService.isAuthenticated) return;

    if (forceRefresh || _prompts.isEmpty) {
      if (forceRefresh) {
        safeSetState(() {
          _prompts.clear();
          hasMorePages = true;
        });
      }

      await executeWithLoading(
        operation: () async {
          final request = PaginatedRequest(
            limit: PaginatedRequest.numberOfPrompts,
            list: ServerListType.profilePrompts,
          );

          final prompts = await _contentManager.fetchProfilePrompts(request);
          safeSetState(() {
            _prompts.addAll(prompts);
            hasMorePages = prompts.length == PaginatedRequest.numberOfPrompts;
          });
        },
        showSuccessToast: false,
        showErrorToast: false,  // Silent load for initial data
      );
    }
  }

  Future<void> _loadMorePrompts() async {
    if (_prompts.isEmpty || !hasMorePages) return;

    safeSetState(() {
      isLoadingMore = true;
    });

    await executeSilently(
      operation: () async {
        final lastPrompt = _prompts.last;
        final request = PaginatedRequest(
          limit: PaginatedRequest.numberOfPrompts,
          cursorId: lastPrompt.promptID,
          cursorTime: lastPrompt.createdAt,
          list: ServerListType.profilePrompts,
        );

        final prompts = await _contentManager.fetchProfilePrompts(request);
        safeSetState(() {
          _prompts.addAll(prompts);
          hasMorePages = prompts.length == PaginatedRequest.numberOfPrompts;
          isLoadingMore = false;
        });
      },
      onError: (error) {
        AppLogger.error('Error loading more prompts', context: 'PromptsView', error: error);
        safeSetState(() {
          isLoadingMore = false;
        });
      },
    );
  }

  Future<void> _handleRefresh() async {
    await _loadPrompts(forceRefresh: true);
    // Also refresh available prompts - callback will update state automatically
    _checkForPrompts();
  }

  /// Check for available daily prompts
  /// The callback will automatically update _availablePrompts state
  Future<void> _checkForPrompts() async {
    if (_isCheckingPrompts) return;

    _isCheckingPrompts = true;

    try {
      final authService = context.authService;
      if (!authService.isAuthenticated) return;

      AppLogger.debug('Checking for available daily prompts', context: 'PromptsView');
      await _contentManager.fetchPrompts(); // Callback will update state
    } catch (error) {
      AppLogger.error('Error fetching available prompts', error: error, context: 'PromptsView');
    } finally {
      _isCheckingPrompts = false;
    }
  }

  /// Show the PromptEntryView as a fullscreen modal
  Future<void> _showPromptsModal() async {
    if (_availablePrompts == null || _availablePrompts!.isEmpty) return;

    void closeModalCallback() {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    await showPlatformModalSheet<bool>(
      context: context,
      material: MaterialModalSheetData(
        useRootNavigator: false,
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: true,
      ),
      cupertino: CupertinoModalSheetData(
        useRootNavigator: false,
        barrierDismissible: true,
      ),
      builder: (sheetCtx) => PromptEntryView(
        prompts: _availablePrompts!,
        isModal: true,
        onCloseModal: closeModalCallback,
      ),
    );

    // After modal closes, refresh user prompts list
    // The available prompts will be updated via callback when PromptEntryView notifies
    await _handleRefresh();
  }
}