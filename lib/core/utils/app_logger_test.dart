import 'package:flutter/foundation.dart';

import 'app_logger.dart';

/// Test class to demonstrate AppLogger functionality
/// 
/// This class shows how AppLogger behaves in debug vs release mode:
/// - Debug mode: All log levels are shown with emoji prefixes
/// - Release mode: Only error logs are shown, others are suppressed
/// 
/// Run this test to verify logging behavior:
/// ```dart
/// AppLoggerTest.runAllTests();
/// ```
class AppLoggerTest {
  /// Run comprehensive tests of AppLogger functionality
  static void runAllTests() {
    if (kDebugMode) {
      AppLogger.info('🧪 Running AppLogger tests in DEBUG mode', context: 'AppLoggerTest');
    } else {
      AppLogger.info('🧪 Running AppLogger tests in RELEASE mode', context: 'AppLoggerTest');
    }
    
    _testLogLevels();
    _testContextParameter();
    _testErrorWithException();
    _testSpecializedLoggers();
    _testPerformance();
    
    AppLogger.success('All AppLogger tests completed', context: 'AppLoggerTest');
  }
  
  /// Test all log levels
  static void _testLogLevels() {
    AppLogger.debug('This is a debug message', context: 'AppLoggerTest');
    AppLogger.info('This is an info message', context: 'AppLoggerTest');
    AppLogger.warning('This is a warning message', context: 'AppLoggerTest');
    AppLogger.error('This is an error message', context: 'AppLoggerTest');
    AppLogger.success('This is a success message', context: 'AppLoggerTest');
  }
  
  /// Test context parameter functionality
  static void _testContextParameter() {
    AppLogger.info('Testing without context');
    AppLogger.info('Testing with context', context: 'CustomContext');
    AppLogger.info('Testing with method context', context: 'AppLoggerTest.testMethod');
  }
  
  /// Test error logging with exception objects
  static void _testErrorWithException() {
    try {
      throw Exception('Test exception for logging');
    } catch (error, stackTrace) {
      AppLogger.error(
        'Caught test exception',
        error: error,
        stackTrace: stackTrace,
        context: 'AppLoggerTest',
      );
    }
  }
  
  /// Test specialized logger methods
  static void _testSpecializedLoggers() {
    AppLogger.network('API request to /api/users', context: 'AppLoggerTest');
    AppLogger.database('Executing query: SELECT * FROM users', context: 'AppLoggerTest');
    AppLogger.auth('User authentication successful', context: 'AppLoggerTest');
    AppLogger.ui('Button tapped: Login', context: 'AppLoggerTest');
    AppLogger.storage('File saved to cache', context: 'AppLoggerTest');
  }
  
  /// Test logging performance (should be fast in release mode)
  static void _testPerformance() {
    final stopwatch = Stopwatch()..start();
    
    for (int i = 0; i < 1000; i++) {
      AppLogger.debug('Performance test log $i', context: 'AppLoggerTest');
    }
    
    stopwatch.stop();
    AppLogger.info(
      'Logged 1000 debug messages in ${stopwatch.elapsedMilliseconds}ms',
      context: 'AppLoggerTest',
    );
  }
  
  /// Demonstrate the difference between debug and release modes
  static void demonstrateDebugVsRelease() {
    AppLogger.info('=== Debug vs Release Demo ===', context: 'AppLoggerTest');
    
    if (kDebugMode) {
      AppLogger.info('Currently in DEBUG mode - all logs will be shown', context: 'AppLoggerTest');
      AppLogger.debug('This debug log will be shown', context: 'AppLoggerTest');
      AppLogger.info('This info log will be shown', context: 'AppLoggerTest');
      AppLogger.warning('This warning log will be shown', context: 'AppLoggerTest');
      AppLogger.error('This error log will be shown', context: 'AppLoggerTest');
    } else {
      AppLogger.info('Currently in RELEASE mode - only errors will be shown', context: 'AppLoggerTest');
      AppLogger.debug('This debug log will be HIDDEN in release', context: 'AppLoggerTest');
      AppLogger.info('This info log will be HIDDEN in release', context: 'AppLoggerTest');
      AppLogger.warning('This warning log will be HIDDEN in release', context: 'AppLoggerTest');
      AppLogger.error('This error log will be SHOWN in release', context: 'AppLoggerTest');
    }
  }
}