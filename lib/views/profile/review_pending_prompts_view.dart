import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/utils/app_logger.dart';
import '../../models/enums/prompt_status.dart';
import '../../models/enums/review_type.dart';
import '../../models/prompt.dart';
import '../../models/requests/paginated_request.dart';
import '../../services/supabase_managers/content_manager.dart';
import '../../services/toast_service.dart';
import '../../models/enums/action_button_type.dart';
import '../../widgets/buttons/action_button.dart';
import '../prompts/prompt_item.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../mixins/paginated_list_view_mixin.dart';

/// ReviewPendingPromptsView - Flutter equivalent of iOS PendingReviewsView
///
/// Shows a paginated list of pending review prompts that can be selected
/// and either approved or rejected in batches.
class ReviewPendingPromptsView extends StatefulWidget {
  final ReviewType reviewType;

  const ReviewPendingPromptsView({
    super.key,
    required this.reviewType,
  });

  @override
  State<ReviewPendingPromptsView> createState() => _ReviewPendingPromptsViewState();
}

class _ReviewPendingPromptsViewState extends State<ReviewPendingPromptsView>
    with PaginatedListViewMixin<ReviewPendingPromptsView> {
  final List<Prompt> _prompts = [];
  final Set<String> _selectedPromptIds = <String>{};
  
  bool _isProcessingApprove = false;
  bool _isProcessingReject = false;
  String? _cursorId;
  DateTime? _cursorTime;

  late final ContentManager _contentManager;

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    initializePagination();
    _loadPendingReviews();
  }

  @override
  Future<void> loadMoreItems() async {
    await _loadMorePendingReviews();
  }


  Future<void> _loadPendingReviews() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final serverListType = widget.reviewType == ReviewType.user
          ? ServerListType.pendingUserReviews
          : ServerListType.pendingSystemReviews;

      final request = PaginatedRequest(
        limit: PaginatedRequest.numberOfPrompts,
        list: serverListType,
      );

      final prompts = await _contentManager.fetchPendingReviews(request);

      setState(() {
        _prompts.clear();
        _prompts.addAll(prompts);
        _selectedPromptIds.clear();
        hasMorePages = prompts.length >= PaginatedRequest.numberOfPrompts;
        
        if (prompts.isNotEmpty) {
          final lastPrompt = prompts.last;
          _cursorId = lastPrompt.promptID;
          _cursorTime = lastPrompt.createdAt;
        } else {
          _cursorId = null;
          _cursorTime = null;
        }
        isLoading = false;
      });
    } catch (error) {
      AppLogger.error('Error loading pending reviews', error: error, context: 'ReviewPendingPromptsView');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMorePendingReviews() async {
    if (isLoadingMore || !hasMorePages) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final serverListType = widget.reviewType == ReviewType.user
          ? ServerListType.pendingUserReviews
          : ServerListType.pendingSystemReviews;

      final request = PaginatedRequest(
        limit: PaginatedRequest.numberOfPrompts,
        cursorId: _cursorId,
        cursorTime: _cursorTime,
        list: serverListType,
      );

      final prompts = await _contentManager.fetchPendingReviews(request);

      setState(() {
        _prompts.addAll(prompts);
        hasMorePages = prompts.length >= PaginatedRequest.numberOfPrompts;
        
        if (prompts.isNotEmpty) {
          final lastPrompt = prompts.last;
          _cursorId = lastPrompt.promptID;
          _cursorTime = lastPrompt.createdAt;
        }
        isLoadingMore = false;
      });
    } catch (error) {
      AppLogger.error('Error loading more pending reviews', error: error, context: 'ReviewPendingPromptsView');
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void _togglePromptSelection(Prompt prompt) {
    setState(() {
      if (_selectedPromptIds.contains(prompt.promptID)) {
        _selectedPromptIds.remove(prompt.promptID);
      } else {
        _selectedPromptIds.add(prompt.promptID);
      }
    });
  }

  Future<void> _approveSelection() async {
    await _submitSelection(isApproved: true);
  }

  Future<void> _rejectSelection() async {
    await _submitSelection(isApproved: false);
  }

  Future<void> _approveAll() async {
    await _submitAll(isApproved: true);
  }

  Future<void> _rejectAll() async {
    await _submitAll(isApproved: false);
  }

  Future<void> _submitSelection({required bool isApproved}) async {
    if (_selectedPromptIds.isEmpty || _isProcessingApprove || _isProcessingReject) return;

    setState(() {
      if (isApproved) {
        _isProcessingApprove = true;
      } else {
        _isProcessingReject = true;
      }
    });

    try {
      final promptIds = _selectedPromptIds.toList();
      final status = isApproved ? PromptStatus.pendingTranslation : PromptStatus.rejected;
      await _contentManager.updatePromptStatusBatch(promptIds, status);

      setState(() {
        _selectedPromptIds.clear();
      });

      // Reset pagination and refresh the list
      _cursorId = null;
      _cursorTime = null;
      resetPagination();
      await _loadPendingReviews();

      AppLogger.info(isApproved ? 'Prompts approved' : 'Prompts rejected', context: 'ReviewPendingPromptsView');
    } catch (error) {
      AppLogger.error('Error updating prompt statuses', error: error, context: 'ReviewPendingPromptsView');
      if (mounted) {
        ToastService.error(
          context: context,
          message: 'Failed to update prompts',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingApprove = false;
          _isProcessingReject = false;
        });
      }
    }
  }

  Future<void> _submitAll({required bool isApproved}) async {
    if (_prompts.isEmpty || _isProcessingApprove || _isProcessingReject) return;

    setState(() {
      if (isApproved) {
        _isProcessingApprove = true;
      } else {
        _isProcessingReject = true;
      }
    });

    try {
      final status = isApproved ? PromptStatus.pendingTranslation : PromptStatus.rejected;
      await _contentManager.updatePromptStatusByReviewType(widget.reviewType, status);

      setState(() {
        _selectedPromptIds.clear();
      });

      // Reset pagination and refresh the list
      _cursorId = null;
      _cursorTime = null;
      resetPagination();
      await _loadPendingReviews();

      AppLogger.info(isApproved ? 'All prompts approved' : 'All prompts rejected', context: 'ReviewPendingPromptsView');
    } catch (error) {
      AppLogger.error('Error updating all prompt statuses', error: error, context: 'ReviewPendingPromptsView');
      if (mounted) {
        ToastService.error(
          context: context,
          message: 'Failed to update all prompts',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingApprove = false;
          _isProcessingReject = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text('Pending ${widget.reviewType.title(context).toLowerCase()}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildContent(venyuTheme),
          ),
          _buildBottomActions(venyuTheme),
        ],
      ),
    );
  }

  Widget _buildContent(VenyuTheme venyuTheme) {
    if (isLoading) {
      return const Center(
        child: LoadingStateWidget(),
      );
    }

    if (_prompts.isEmpty) {
      final serverListType = widget.reviewType == ReviewType.user
          ? ServerListType.pendingUserReviews
          : ServerListType.pendingSystemReviews;

      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: EmptyStateWidget(
              message: serverListType.emptyStateTitle,
              description: serverListType.emptyStateDescription,
              iconName: "nocards",
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPendingReviews,
      child: ListView.builder(
        controller: scrollController,
        itemCount: _prompts.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _prompts.length) {
            // Loading more indicator
            return buildLoadingIndicator();
          }

          final prompt = _prompts[index];
          //final isSelected = _selectedPromptIds.contains(prompt.promptID);

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: PromptItem(
              prompt: prompt,
              reviewing: true,
              isFirst: index == 0,
              isLast: index == _prompts.length - 1,
              onPromptSelected: _togglePromptSelection,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomActions(VenyuTheme venyuTheme) {
    if (_selectedPromptIds.isNotEmpty) {
      // Show selection actions
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SafeArea(
          child: Row(
            children: [
              // Reject button
              Expanded(
                child: ActionButton(
                  label: 'Reject ${_selectedPromptIds.length}',
                  onPressed: _isProcessingApprove ? null : _rejectSelection,
                  type: ActionButtonType.destructive,
                  isLoading: _isProcessingReject,
                  isDisabled: _isProcessingApprove,
                ),
              ),
              const SizedBox(width: 8),
              // Approve button
              Expanded(
                child: ActionButton(
                  label: 'Approve ${_selectedPromptIds.length}',
                  onPressed: _isProcessingReject ? null : _approveSelection,
                  type: ActionButtonType.primary,
                  isLoading: _isProcessingApprove,
                  isDisabled: _isProcessingReject,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_prompts.isNotEmpty || _isProcessingApprove || _isProcessingReject) {
      // Show "all" actions - also show when processing even if cards are empty
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SafeArea(
          child: Row(
            children: [
              // Reject all button
              Expanded(
                child: ActionButton(
                  label: 'Reject all',
                  onPressed: _isProcessingApprove ? null : _rejectAll,
                  type: ActionButtonType.destructive,
                  isLoading: _isProcessingReject,
                  isDisabled: _isProcessingApprove,
                ),
              ),
              const SizedBox(width: 8),
              // Approve all button
              Expanded(
                child: ActionButton(
                  label: 'Approve all',
                  onPressed: _isProcessingReject ? null : _approveAll,
                  type: ActionButtonType.primary,
                  isLoading: _isProcessingApprove,
                  isDisabled: _isProcessingReject,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}