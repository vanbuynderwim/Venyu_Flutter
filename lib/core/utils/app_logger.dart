import 'package:flutter/foundation.dart';

/// Centralized logging utility for the Venyu Flutter app.
/// 
/// This logger automatically handles debug vs release mode differences:
/// - Debug mode: All logs are shown with emoji prefixes and colors
/// - Release mode: Only error logs are shown, info/debug logs are suppressed
/// 
/// Features:
/// - Log levels (debug, info, warning, error)
/// - Emoji prefixes for better visual distinction
/// - Automatic release mode filtering
/// - Context-aware logging with class/method names
/// - Performance-friendly (no string construction in release mode)
/// 
/// Example usage:
/// ```dart
/// AppLogger.debug('User tapped login button');
/// AppLogger.info('Authentication successful');
/// AppLogger.warning('Slow network detected');
/// AppLogger.error('Failed to load user data', error: error);
/// ```
class AppLogger {
  /// Enable/disable logging entirely (useful for testing)
  static bool _enabled = true;
  
  /// Debug level logging - only shown in debug mode
  /// Use for detailed flow information, user interactions, etc.
  static void debug(String message, {String? context}) {
    if (_enabled && kDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      debugPrint('🔍 DEBUG: $prefix$message');
    }
  }
  
  /// Info level logging - shown in debug mode, suppressed in release
  /// Use for important app state changes, successful operations, etc.
  static void info(String message, {Object? error, String? context}) {
    if (_enabled && kDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      debugPrint('ℹ️ INFO: $prefix$message');
      if (error != null) {
        debugPrint('   Details: $error');
      }
    }
  }
  
  /// Warning level logging - shown in debug mode, suppressed in release
  /// Use for recoverable errors, deprecated API usage, etc.
  static void warning(String message, {Object? error, String? context}) {
    if (_enabled && kDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      debugPrint('⚠️ WARNING: $prefix$message');
      if (error != null) {
        debugPrint('   Details: $error');
      }
    }
  }
  
  /// Error level logging - shown in both debug and release modes
  /// Use for exceptions, critical failures, etc.
  static void error(String message, {Object? error, StackTrace? stackTrace, String? context}) {
    if (_enabled) {
      final prefix = context != null ? '[$context] ' : '';
      debugPrint('❌ ERROR: $prefix$message');
      
      if (error != null) {
        debugPrint('   Exception: $error');
      }
      
      if (stackTrace != null && kDebugMode) {
        debugPrint('   Stack trace: $stackTrace');
      }
    }
  }
  
  /// Success level logging - shown in debug mode, suppressed in release
  /// Use for successful operations, completed tasks, etc.
  static void success(String message, {String? context}) {
    if (_enabled && kDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      debugPrint('✅ SUCCESS: $prefix$message');
    }
  }
  
  /// Network level logging - shown in debug mode, suppressed in release
  /// Use for API calls, network operations, etc.
  static void network(String message, {String? context}) {
    if (_enabled && kDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      debugPrint('🌐 NETWORK: $prefix$message');
    }
  }
  
  /// Database level logging - shown in debug mode, suppressed in release
  /// Use for database operations, queries, etc.
  static void database(String message, {String? context}) {
    if (_enabled && kDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      debugPrint('🗃️ DATABASE: $prefix$message');
    }
  }
  
  /// Authentication level logging - shown in debug mode, suppressed in release
  /// Use for auth operations, token refresh, etc.
  static void auth(String message, {String? context}) {
    if (_enabled && kDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      debugPrint('🔐 AUTH: $prefix$message');
    }
  }
  
  /// UI level logging - shown in debug mode, suppressed in release
  /// Use for UI state changes, navigation, etc.
  static void ui(String message, {String? context}) {
    if (_enabled && kDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      debugPrint('🎨 UI: $prefix$message');
    }
  }
  
  /// Storage level logging - shown in debug mode, suppressed in release
  /// Use for file operations, cache operations, etc.
  static void storage(String message, {String? context}) {
    if (_enabled && kDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      debugPrint('💾 STORAGE: $prefix$message');
    }
  }
  
  /// Enable or disable all logging
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }
  
  /// Check if logging is currently enabled
  static bool get isEnabled => _enabled;
  
  /// Utility method to get class name for context
  static String getContext(Object instance) {
    return instance.runtimeType.toString();
  }
  
  /// Utility method to get method context
  static String getMethodContext(Object instance, String methodName) {
    return '${instance.runtimeType}.$methodName';
  }
}