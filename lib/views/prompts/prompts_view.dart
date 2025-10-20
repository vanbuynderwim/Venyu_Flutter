import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
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
import '../../widgets/common/sub_title.dart';
import '../../widgets/buttons/get_matched_button.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/action_button_type.dart';
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
    _checkForPrompts();
  }

  @override
  Future<void> loadMoreItems() async {
    await _loadMorePrompts();
  }

  /// Check for available daily prompts
  Future<void> _checkForPrompts() async {
    if (_isCheckingPrompts) return;

    _isCheckingPrompts = true;

    try {
      final authService = context.authService;
      if (!authService.isAuthenticated) return;

      AppLogger.debug('Checking for available daily prompts', context: 'PromptsView');
      final prompts = await _contentManager.fetchPrompts();

      if (mounted) {
        setState(() {
          _availablePrompts = prompts;
        });
        AppLogger.debug('Found ${prompts.length} available daily prompts', context: 'PromptsView');
      }
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

    final result = await showPlatformModalSheet<bool>(
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

    // Refresh available prompts and list after modal closes
    if (result == true) {
      await _checkForPrompts();
      await _handleRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.promptsViewTitle),
      ),
      floatingActionButton: _prompts.isNotEmpty
          ? GetMatchedButton(
              buttonType: GetMatchedButtonType.fab,
              onModalClosed: (result) {
                if (result == true) {
                  AppLogger.debug('Prompt creation completed, refreshing list', context: 'PromptsView');
                  _handleRefresh();
                }
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
                          onAction: () => _handleGetMatchedPressed(),
                          actionText: l10n.promptsViewEmptyActionButton,
                          actionButtonIcon: context.themedIcon('edit'),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Fixed sticky header with action button or message
                    Container(
                      color: context.venyuTheme.pageBackground,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: _availablePrompts != null && _availablePrompts!.isNotEmpty
                          ? ActionButton(
                              label: l10n.promptsViewAnswerPromptsButton,
                              onPressed: _showPromptsModal,
                              type: ActionButtonType.primary,
                            )
                          : Center(
                              child: Text(
                                l10n.promptsViewAllAnsweredMessage,
                                style: AppTextStyles.body.copyWith(
                                  color: context.venyuTheme.secondaryText,
                                ),
                              ),
                            ),
                    ),

                    // Section title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: SubTitle(
                        iconName: 'card',
                        title: l10n.promptsViewMyPromptsTitle,
                      ),
                    ),

                    // Scrollable prompts list
                    Expanded(
                      child: RefreshIndicator(
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
                    ),
                  ],
                ),
    );
  }


  /// Handles the Get Matched button press (both FAB and EmptyState button)
  Future<void> _handleGetMatchedPressed() async {
    final result = await GetMatchedHelper.openGetMatchedModal(
      context: context,
      callerContext: 'PromptsView',
    );

    // If prompt was successfully added, refresh the list
    if (result == true) {
      await _handleRefresh();
    }
  }

  

  /// Opens the new prompt detail view to show matches
  Future<void> _openPromptDetail(Prompt prompt) async {
    AppLogger.debug('Opening prompt detail view for prompt: ${prompt.label}', context: 'PromptsView');
    try {
      await Navigator.push(
        context,
        platformPageRoute(
          context: context,
          builder: (context) => PromptDetailView(promptId: prompt.promptID),
        ),
      );

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
  }
}