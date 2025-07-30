import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../scaffolds/app_scaffold.dart';
import '../../mixins/data_refresh_mixin.dart';
import 'loading_state_widget.dart';
import 'error_state_widget.dart';
import 'empty_state_widget.dart';

/// BaseListView - Abstract base class for consistent list-based views
/// 
/// Provides a standardized pattern for views that display lists of data with
/// loading, error, and empty states. Eliminates boilerplate code and ensures
/// consistent user experience across all list views.
/// 
/// Features:
/// - Automatic state management (loading/error/empty/data)
/// - Built-in refresh functionality
/// - Consistent error handling
/// - Platform-aware app bar
/// - Customizable empty states
/// - Pull-to-refresh support
/// 
/// Usage:
/// ```dart
/// class MyListView extends BaseListView<MyData> {
///   const MyListView({super.key});
/// 
///   @override
///   State<MyListView> createState() => _MyListViewState();
/// }
/// 
/// class _MyListViewState extends BaseListViewState<MyData, MyListView> {
///   @override
///   Future<List<MyData>> fetchItems() => myService.getData();
/// 
///   @override
///   Widget buildItem(MyData item) => ListTile(title: Text(item.name));
/// 
///   @override
///   String get emptyMessage => 'No data available';
/// 
///   @override
///   PlatformAppBar buildAppBar() => PlatformAppBar(title: const Text('My Data'));
/// }
/// ```
abstract class BaseListView<T> extends StatefulWidget {
  const BaseListView({super.key});
  
  @override
  State<BaseListView<T>> createState();
}

/// BaseListViewState - Implementation state for BaseListView
abstract class BaseListViewState<T, W extends BaseListView<T>> extends State<W> with DataRefreshMixin {
  List<T>? _items;
  
  /// Current items list
  List<T>? get items => _items;
  
  /// Whether we have loaded items
  bool get hasItems => _items != null && _items!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  /// Fetch items from data source - must be implemented by subclasses
  Future<List<T>> fetchItems();
  
  /// Build individual list item - must be implemented by subclasses
  Widget buildItem(T item);
  
  /// Message to show when list is empty - must be implemented by subclasses
  String get emptyMessage;
  
  /// Build the app bar - must be implemented by subclasses
  PlatformAppBar buildAppBar();
  
  /// Optional: Custom empty state widget (overrides emptyMessage)
  Widget? buildEmptyState() => null;
  
  /// Optional: Custom loading message
  String get loadingMessage => 'Loading...';
  
  /// Optional: Custom error title
  String get errorTitle => 'Failed to load data';
  
  /// Optional: Enable pull-to-refresh (default: true)
  bool get enableRefresh => true;

  /// Refresh data using DataRefreshMixin
  void _refreshData() {
    refreshData(
      () => fetchItems(),
      (items) => setState(() => _items = items),
      context: 'fetching ${T.toString().toLowerCase()} list',
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent();
    
    if (enableRefresh) {
      return Scaffold(
        appBar: buildAppBar() as PreferredSizeWidget,
        body: RefreshIndicator(
          onRefresh: () async => _refreshData(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: content,
          ),
        ),
      );
    }
    
    return AppListScaffold(
      appBar: buildAppBar(),
      children: content,
    );
  }

  /// Build the main content based on current state
  List<Widget> _buildContent() {
    if (isLoading) {
      return [
        LoadingStateWidget(
          message: loadingMessage,
          height: 300,
        ),
      ];
    }

    if (error != null) {
      return [
        ErrorStateWidget(
          error: error!,
          title: errorTitle,
          height: 300,
          onRetry: _refreshData,
        ),
      ];
    }

    if (!hasItems) {
      final customEmpty = buildEmptyState();
      if (customEmpty != null) {
        return [customEmpty];
      }
      
      return [
        EmptyStateWidget(
          message: emptyMessage,
          height: 300,
        ),
      ];
    }

    // Build list items
    return _items!.map((item) => buildItem(item)).toList();
  }
}

