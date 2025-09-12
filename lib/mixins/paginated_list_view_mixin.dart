import 'package:flutter/material.dart';
import '../widgets/common/loading_state_widget.dart';

/// PaginatedListViewMixin - Common pagination logic for list views
/// 
/// This mixin provides standard pagination functionality for views that need to:
/// - Load data in pages/batches
/// - Detect when user scrolls near the bottom
/// - Automatically load more items
/// - Track loading and pagination state
/// 
/// Usage:
/// ```dart
/// class MyListView extends StatefulWidget { ... }
/// 
/// class _MyListViewState extends State<MyListView> 
///     with PaginatedListViewMixin<MyListView> {
///   
///   @override
///   void initState() {
///     super.initState();
///     initializePagination();
///     loadInitialData();
///   }
///   
///   @override
///   Future<void> loadMoreItems() async {
///     // Your implementation to load more data
///   }
/// }
/// ```
mixin PaginatedListViewMixin<T extends StatefulWidget> on State<T> {
  /// Scroll controller for detecting scroll position
  final ScrollController scrollController = ScrollController();
  
  /// Whether initial data is being loaded
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    if (mounted) {
      setState(() => _isLoading = value);
    }
  }
  
  /// Whether more items are being loaded
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  set isLoadingMore(bool value) {
    if (mounted) {
      setState(() => _isLoadingMore = value);
    }
  }
  
  /// Whether there are more pages to load
  bool _hasMorePages = true;
  bool get hasMorePages => _hasMorePages;
  set hasMorePages(bool value) {
    if (mounted) {
      setState(() => _hasMorePages = value);
    }
  }
  
  /// Distance from bottom when to trigger loading more items
  double get loadMoreThreshold => 200.0;
  
  /// Initialize pagination by adding scroll listener
  @protected
  void initializePagination() {
    scrollController.addListener(_onScroll);
  }
  
  /// Handle scroll events to trigger loading more items
  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - loadMoreThreshold &&
        !isLoadingMore &&
        hasMorePages) {
      loadMoreItems();
    }
  }
  
  /// Abstract method to load more items - must be implemented by the using class
  @protected
  Future<void> loadMoreItems();
  
  /// Reset pagination state (useful for pull-to-refresh)
  @protected
  void resetPagination() {
    if (mounted) {
      setState(() {
        _hasMorePages = true;
        _isLoadingMore = false;
      });
    }
  }
  
  /// Build loading indicator for the end of the list
  @protected
  Widget buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: LoadingStateWidget(),
      ),
    );
  }
  
  /// Clean up resources
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}