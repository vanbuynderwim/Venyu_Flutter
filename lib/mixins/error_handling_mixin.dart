import 'package:flutter/material.dart';
import '../core/utils/app_logger.dart';
import '../services/toast_service.dart';

/// A mixin that provides standardized error handling and loading state management
/// for StatefulWidgets throughout the app.
/// 
/// This mixin eliminates duplicate try-catch blocks and loading state patterns
/// by providing reusable methods for common async operations.
/// 
/// Features:
/// - Automatic loading state management
/// - Consistent error handling with ToastService
/// - Safe setState calls with mounted checks
/// - Optional success/error messages
/// - Support for operations with return values
/// 
/// Usage example:
/// ```dart
/// class MyView extends StatefulWidget { ... }
/// 
/// class _MyViewState extends State<MyView> with ErrorHandlingMixin {
///   Future<void> _saveData() async {
///     await executeWithLoading(
///       operation: () async {
///         await _supabaseManager.updateProfile(data);
///       },
///       successMessage: 'Profile updated successfully',
///       errorMessage: 'Failed to update profile',
///     );
///   }
/// }
/// ```
mixin ErrorHandlingMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  bool _isProcessing = false;

  /// Whether the view is currently loading initial data
  bool get isLoading => _isLoading;
  
  /// Whether an operation is currently being processed
  bool get isProcessing => _isProcessing;
  
  /// Whether any loading operation is in progress
  bool get isBusy => _isLoading || _isProcessing;

  /// Set the loading state safely with mounted check
  @protected
  void setLoadingState(bool loading) {
    if (!mounted) return;
    setState(() => _isLoading = loading);
  }

  /// Set the processing state safely with mounted check
  @protected
  void setProcessingState(bool processing) {
    if (!mounted) return;
    setState(() => _isProcessing = processing);
  }

  /// Execute an async operation with automatic loading state management
  /// and error handling.
  /// 
  /// [operation] - The async operation to execute
  /// [successMessage] - Optional message to show on success
  /// [errorMessage] - Optional custom error message prefix
  /// [showSuccessToast] - Whether to show success toast (default: true)
  /// [showErrorToast] - Whether to show error toast (default: true)
  /// [useProcessingState] - Use processing state instead of loading (default: false)
  /// [onSuccess] - Optional callback to execute on success
  /// [onError] - Optional callback to execute on error
  Future<void> executeWithLoading({
    required Future<void> Function() operation,
    String? successMessage,
    String? errorMessage,
    bool showSuccessToast = true,
    bool showErrorToast = true,
    bool useProcessingState = false,
    VoidCallback? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    if (!mounted) return;

    // Set loading state
    if (useProcessingState) {
      setProcessingState(true);
    } else {
      setLoadingState(true);
    }

    try {
      await operation();
      
      // Handle success
      if (mounted) {
        if (showSuccessToast && successMessage != null) {
          ToastService.success(
            context: context,
            message: successMessage,
          );
        }
        onSuccess?.call();
      }
    } catch (error) {
      // Handle error
      if (mounted) {
        if (showErrorToast) {
          final message = errorMessage != null 
              ? '$errorMessage: ${_extractErrorMessage(error)}'
              : _extractErrorMessage(error);
          
          ToastService.error(
            context: context,
            message: message,
          );
        }
        onError?.call(error);
      }
      
      AppLogger.error('Error in ${widget.runtimeType}', error: error, context: 'ErrorHandlingMixin');
      rethrow;
    } finally {
      // Reset loading state
      if (mounted) {
        if (useProcessingState) {
          setProcessingState(false);
        } else {
          setLoadingState(false);
        }
      }
    }
  }

  /// Execute an async operation that returns a value with automatic
  /// loading state management and error handling.
  /// 
  /// [operation] - The async operation that returns a value
  /// [defaultValue] - Default value to return on error
  /// [errorMessage] - Optional custom error message prefix
  /// [showErrorToast] - Whether to show error toast (default: true)
  /// [useProcessingState] - Use processing state instead of loading (default: false)
  /// [onError] - Optional callback to execute on error
  Future<R?> executeWithLoadingAndReturn<R>({
    required Future<R> Function() operation,
    R? defaultValue,
    String? errorMessage,
    bool showErrorToast = true,
    bool useProcessingState = false,
    Function(dynamic error)? onError,
  }) async {
    if (!mounted) return defaultValue;

    // Set loading state
    if (useProcessingState) {
      setProcessingState(true);
    } else {
      setLoadingState(true);
    }

    try {
      final result = await operation();
      return result;
    } catch (error) {
      // Handle error
      if (mounted && showErrorToast) {
        final message = errorMessage != null 
            ? '$errorMessage: ${_extractErrorMessage(error)}'
            : _extractErrorMessage(error);
        
        ToastService.error(
          context: context,
          message: message,
        );
      }
      
      onError?.call(error);
      AppLogger.error('Error in ${widget.runtimeType}', error: error, context: 'ErrorHandlingMixin');
      return defaultValue;
    } finally {
      // Reset loading state
      if (mounted) {
        if (useProcessingState) {
          setProcessingState(false);
        } else {
          setLoadingState(false);
        }
      }
    }
  }

  /// Execute an async operation without showing any UI feedback.
  /// Useful for background operations.
  /// 
  /// [operation] - The async operation to execute
  /// [onError] - Optional callback to execute on error
  Future<void> executeSilently({
    required Future<void> Function() operation,
    Function(dynamic error)? onError,
  }) async {
    if (!mounted) return;

    try {
      await operation();
    } catch (error) {
      onError?.call(error);
      AppLogger.error('Silent error in ${widget.runtimeType}', error: error, context: 'ErrorHandlingMixin');
    }
  }

  /// Execute an async operation with custom loading widget.
  /// Returns a widget that can be used directly in the build method.
  /// 
  /// [operation] - The async operation to execute
  /// [loadingWidget] - Widget to show while loading
  /// [builder] - Widget builder for the result
  Widget executeWithLoadingWidget<R>({
    required Future<R> Function() operation,
    required Widget loadingWidget,
    required Widget Function(R data) builder,
    Widget Function(dynamic error)? errorBuilder,
  }) {
    return FutureBuilder<R>(
      future: operation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget;
        } else if (snapshot.hasError) {
          if (errorBuilder != null) {
            return errorBuilder(snapshot.error);
          }
          return Center(
            child: Text('Error: ${_extractErrorMessage(snapshot.error)}'),
          );
        } else if (snapshot.hasData) {
          return builder(snapshot.data as R);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  /// Extract a user-friendly error message from an error object
  String _extractErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return error.toString();
  }

  /// Safe setState that checks if widget is mounted
  @protected
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}

/// Extended version of ErrorHandlingMixin with additional form-specific functionality
mixin FormErrorHandlingMixin<T extends StatefulWidget> on State<T> implements ErrorHandlingMixin<T> {
  final _formKey = GlobalKey<FormState>();
  
  /// Get the form key for validation
  GlobalKey<FormState> get formKey => _formKey;
  
  /// Validate and execute an operation if form is valid
  Future<void> validateAndExecute({
    required Future<void> Function() operation,
    String? successMessage,
    String? errorMessage,
    String? invalidFormMessage,
    VoidCallback? onSuccess,
  }) async {
    if (!_formKey.currentState!.validate()) {
      if (invalidFormMessage != null && mounted) {
        ToastService.error(
          context: context,
          message: invalidFormMessage,
        );
      }
      return;
    }

    await executeWithLoading(
      operation: operation,
      successMessage: successMessage,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
    );
  }
  
  // Implement required members from ErrorHandlingMixin
  @override
  bool _isLoading = false;
  
  @override
  bool _isProcessing = false;

  @override
  bool get isLoading => _isLoading;
  
  @override
  bool get isProcessing => _isProcessing;
  
  @override
  bool get isBusy => _isLoading || _isProcessing;

  @override
  void setLoadingState(bool loading) {
    if (!mounted) return;
    setState(() => _isLoading = loading);
  }

  @override
  void setProcessingState(bool processing) {
    if (!mounted) return;
    setState(() => _isProcessing = processing);
  }
}