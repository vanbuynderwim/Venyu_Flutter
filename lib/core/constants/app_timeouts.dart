/// App Timeouts - Network and operation timeout constants
/// 
/// This class contains all timeout-related constants for
/// network requests, operations, and user interactions.
class AppTimeouts {
  AppTimeouts._();

  /// Network timeouts
  static const Duration networkRequest = Duration(seconds: 30);
  static const Duration imageLoad = Duration(seconds: 10);
  static const Duration avatarLoad = Duration(seconds: 8);
  static const Duration fileUpload = Duration(minutes: 5);
  static const Duration fileDownload = Duration(minutes: 10);

  /// Database operation timeouts
  static const Duration databaseQuery = Duration(seconds: 15);
  static const Duration databaseInsert = Duration(seconds: 10);
  static const Duration databaseUpdate = Duration(seconds: 10);
  static const Duration databaseDelete = Duration(seconds: 5);

  /// Authentication timeouts
  static const Duration authRequest = Duration(seconds: 20);
  static const Duration tokenRefresh = Duration(seconds: 10);
  static const Duration logout = Duration(seconds: 5);

  /// User interaction timeouts
  static const Duration userInactivity = Duration(minutes: 30);
  static const Duration sessionExpiry = Duration(hours: 24);
  static const Duration passwordReset = Duration(minutes: 15);

  /// Cache timeouts
  static const Duration imageCache = Duration(hours: 24);
  static const Duration dataCache = Duration(hours: 1);
  static const Duration profileCache = Duration(minutes: 30);

  /// Retry timeouts
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration exponentialBackoffBase = Duration(seconds: 1);
  static const Duration maxRetryDelay = Duration(seconds: 30);

  /// Helper method for exponential backoff
  static Duration exponentialBackoff(int attempt) {
    final delay = exponentialBackoffBase * (1 << (attempt - 1));
    return delay > maxRetryDelay ? maxRetryDelay : delay;
  }
}