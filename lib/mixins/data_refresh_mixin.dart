import 'package:flutter/material.dart';

import '../core/utils/app_logger.dart';

/// DataRefreshMixin - Standardized data loading and error handling
/// 
/// Provides consistent state management for data loading operations across views.
/// Eliminates code duplication and ensures uniform error handling patterns.
/// 
/// Features:
/// - Consistent loading/error state management
/// - Generic data fetching with type safety
/// - Automatic error handling and logging
/// - Mounted state checking for safety
/// - Flexible success callback handling
/// 
/// Example usage:
/// ```dart
/// class MyView extends StatefulWidget {
///   // ...
/// }
/// 
/// class _MyViewState extends State<MyView> with DataRefreshMixin {
/// 
///   List<MyData>? _data;
/// 
///   @override
///   void initState() {
///     super.initState();
///     _loadData();
///   }
/// 
///   void _loadData() {
///     refreshData(
///       () => myService.fetchData(),
///       (data) => setState(() => _data = data),
///       context: 'loading my data',
///     );
///   }
/// 
///   @override
///   Widget build(BuildContext context) {
///     if (isLoading) return LoadingStateWidget();
///     if (error != null) return ErrorStateWidget(error: error!, onRetry: _loadData);
///     // ... rest of UI
///   }
/// }
/// ```
mixin DataRefreshMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  String? _error;
  
  /// Current loading state
  bool get isLoading => _isLoading;
  
  /// Current error message (null if no error)
  String? get error => _error;
  
  /// Whether the widget has data loaded (no loading, no error)
  bool get hasData => !_isLoading && _error == null;

  /// Refresh data with consistent error handling and state management
  /// 
  /// [dataFetcher] - Async function that returns the data
  /// [onSuccess] - Callback when data is successfully loaded
  /// [context] - Optional context string for error logging
  /// [clearErrorOnStart] - Whether to clear existing errors when starting (default: true)
  Future<void> refreshData<D>(
    Future<D> Function() dataFetcher,
    void Function(D data) onSuccess, {
    String? context,
    bool clearErrorOnStart = true,
  }) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      if (clearErrorOnStart) {
        _error = null;
      }
    });

    try {
      final data = await dataFetcher();
      
      if (!mounted) return;
      
      // Call success callback first (may update state)
      onSuccess(data);
      
      // Then update loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      // Log error with context
      final contextStr = context != null ? ' ($context)' : '';
      AppLogger.error('Data refresh failed$contextStr', context: 'DataRefreshMixin', error: error);
      
      if (!mounted) return;
      
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  /// Refresh data without showing loading state (useful for silent refreshes)
  /// 
  /// [dataFetcher] - Async function that returns the data
  /// [onSuccess] - Callback when data is successfully loaded
  /// [onError] - Optional error callback (if not provided, updates error state)
  /// [context] - Optional context string for error logging
  Future<void> silentRefresh<D>(
    Future<D> Function() dataFetcher,
    void Function(D data) onSuccess, {
    void Function(String error)? onError,
    String? context,
  }) async {
    if (!mounted) return;

    try {
      final data = await dataFetcher();
      
      if (!mounted) return;
      
      onSuccess(data);
    } catch (error) {
      // Log error with context
      final contextStr = context != null ? ' ($context)' : '';
      AppLogger.error('Silent refresh failed$contextStr', context: 'DataRefreshMixin', error: error);
      
      if (!mounted) return;
      
      if (onError != null) {
        onError(error.toString());
      } else {
        setState(() {
          _error = error.toString();
        });
      }
    }
  }

  /// Clear the current error state
  void clearError() {
    if (_error != null && mounted) {
      setState(() {
        _error = null;
      });
    }
  }

  /// Manually set loading state (use with caution)
  void setLoading(bool loading) {
    if (_isLoading != loading && mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  /// Manually set error state (use with caution)
  void setError(String? error) {
    if (_error != error && mounted) {
      setState(() {
        _error = error;
      });
    }
  }
}