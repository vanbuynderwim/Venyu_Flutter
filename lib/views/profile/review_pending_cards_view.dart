import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../models/enums/prompt_status.dart';
import '../../models/enums/review_type.dart';
import '../../models/prompt.dart';
import '../../models/requests/paginated_request.dart';
import '../../services/supabase_manager.dart';
import '../../models/enums/action_button_type.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/card_item.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/scaffolds/app_scaffold.dart';

/// ReviewPendingCardsView - Flutter equivalent of iOS PendingReviewsView
/// 
/// Shows a paginated list of pending review cards that can be selected
/// and either approved or rejected in batches.
class ReviewPendingCardsView extends StatefulWidget {
  final ReviewType reviewType;

  const ReviewPendingCardsView({
    super.key,
    required this.reviewType,
  });

  @override
  State<ReviewPendingCardsView> createState() => _ReviewPendingCardsViewState();
}

class _ReviewPendingCardsViewState extends State<ReviewPendingCardsView> {
  final List<Prompt> _cards = [];
  final Set<String> _selectedPromptIds = <String>{};
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isProcessingApprove = false;
  bool _isProcessingReject = false;
  bool _hasMorePages = true;
  String? _cursorId;
  DateTime? _cursorTime;

  late final SupabaseManager _supabaseManager;

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _scrollController.addListener(_onScroll);
    _loadPendingReviews();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMorePages) {
      _loadMorePendingReviews();
    }
  }

  Future<void> _loadPendingReviews() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final serverListType = widget.reviewType == ReviewType.user
          ? ServerListType.pendingUserReviews
          : ServerListType.pendingSystemReviews;

      final request = PaginatedRequest(
        limit: PaginatedRequest.numberOfCards,
        list: serverListType,
      );

      final prompts = await _supabaseManager.fetchPendingReviews(request);

      setState(() {
        _cards.clear();
        _cards.addAll(prompts);
        _selectedPromptIds.clear();
        _hasMorePages = prompts.length >= PaginatedRequest.numberOfCards;
        
        if (prompts.isNotEmpty) {
          final lastPrompt = prompts.last;
          _cursorId = lastPrompt.promptID;
          _cursorTime = lastPrompt.createdAt;
        } else {
          _cursorId = null;
          _cursorTime = null;
        }
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Error loading pending reviews: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMorePendingReviews() async {
    if (_isLoadingMore || !_hasMorePages) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final serverListType = widget.reviewType == ReviewType.user
          ? ServerListType.pendingUserReviews
          : ServerListType.pendingSystemReviews;

      final request = PaginatedRequest(
        limit: PaginatedRequest.numberOfCards,
        cursorId: _cursorId,
        cursorTime: _cursorTime,
        list: serverListType,
      );

      final prompts = await _supabaseManager.fetchPendingReviews(request);

      setState(() {
        _cards.addAll(prompts);
        _hasMorePages = prompts.length >= PaginatedRequest.numberOfCards;
        
        if (prompts.isNotEmpty) {
          final lastPrompt = prompts.last;
          _cursorId = lastPrompt.promptID;
          _cursorTime = lastPrompt.createdAt;
        }
        _isLoadingMore = false;
      });
    } catch (error) {
      debugPrint('Error loading more pending reviews: $error');
      setState(() {
        _isLoadingMore = false;
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
      await _supabaseManager.updatePromptStatusBatch(promptIds, status);

      setState(() {
        _selectedPromptIds.clear();
      });

      // Reset pagination and refresh the list
      _cursorId = null;
      _cursorTime = null;
      _hasMorePages = true;
      await _loadPendingReviews();

      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(isApproved ? 'Prompts approved' : 'Prompts rejected'),
            backgroundColor: context.venyuTheme.snackbarSuccess,
          ),
        );
      }
    } catch (error) {
      debugPrint('Error updating prompt statuses: $error');
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text('Failed to update prompts: $error'),
            backgroundColor: context.venyuTheme.snackbarError,
          ),
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
    if (_cards.isEmpty || _isProcessingApprove || _isProcessingReject) return;

    setState(() {
      if (isApproved) {
        _isProcessingApprove = true;
      } else {
        _isProcessingReject = true;
      }
    });

    try {
      final status = isApproved ? PromptStatus.pendingTranslation : PromptStatus.rejected;
      await _supabaseManager.updatePromptStatusByReviewType(widget.reviewType, status);

      setState(() {
        _selectedPromptIds.clear();
      });

      // Reset pagination and refresh the list
      _cursorId = null;
      _cursorTime = null;
      _hasMorePages = true;
      await _loadPendingReviews();

      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(isApproved ? 'All prompts approved' : 'All prompts rejected'),
            backgroundColor: context.venyuTheme.snackbarSuccess,
          ),
        );
      }
    } catch (error) {
      debugPrint('Error updating all prompt statuses: $error');
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text('Failed to update all prompts: $error'),
            backgroundColor: context.venyuTheme.snackbarError,
          ),
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
        title: Text('Pending ${widget.reviewType.title.toLowerCase()}'),
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_cards.isEmpty) {
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
              iconName: serverListType.emptyStateIcon,
              height: MediaQuery.of(context).size.height * 0.6,
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPendingReviews,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _cards.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _cards.length) {
            // Loading more indicator
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final prompt = _cards[index];
          //final isSelected = _selectedPromptIds.contains(prompt.promptID);

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: CardItem(
              prompt: prompt,
              reviewing: true,
              isFirst: index == 0,
              isLast: index == _cards.length - 1,
              onCardSelected: _togglePromptSelection,
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
        padding: const EdgeInsets.only(top: 8),
        child: SafeArea(
          child: Row(
            children: [
              // Reject button
              Expanded(
                child: ActionButton(
                  label: 'Reject ${_selectedPromptIds.length}',
                  onPressed: _isProcessingApprove ? null : _rejectSelection,
                  style: ActionButtonType.destructive,
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
                  style: ActionButtonType.primary,
                  isLoading: _isProcessingApprove,
                  isDisabled: _isProcessingReject,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_cards.isNotEmpty || _isProcessingApprove || _isProcessingReject) {
      // Show "all" actions - also show when processing even if cards are empty
      return Container(
        padding: const EdgeInsets.only(top: 8),
        child: SafeArea(
          child: Row(
            children: [
              // Reject all button
              Expanded(
                child: ActionButton(
                  label: 'Reject all',
                  onPressed: _isProcessingApprove ? null : _rejectAll,
                  style: ActionButtonType.destructive,
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
                  style: ActionButtonType.primary,
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