import 'package:flutter/foundation.dart';

import '../constants/app_timeouts.dart';
import '../constants/app_urls.dart';
import 'environment.dart';

/// Main application configuration
/// 
/// This class provides a single source of truth for all app configuration,
/// including database connections, API endpoints, and external service URLs.
class AppConfig {
  AppConfig._();
  
  /// Database configuration
  static String get supabaseUrl => EnvironmentConfig.supabaseUrl;
  static String get supabaseAnonKey => EnvironmentConfig.supabaseAnonKey;
  
  /// External service URLs - Delegated to AppUrls
  static String avatarUrl(String avatarId) => AppUrls.avatarUrl(avatarId);
  
  static String placeholderIconUrl({
    required String text,
    int size = 64,
    String backgroundColor = '007AFF',
    String textColor = 'FFFFFF',
  }) => AppUrls.placeholderIcon(
    text: text,
    size: size,
    backgroundColor: backgroundColor,
    textColor: textColor,
  );
  
  /// Network configuration - Delegated to AppTimeouts
  static Duration get networkTimeout => AppTimeouts.networkRequest;
  static Duration get imageLoadTimeout => AppTimeouts.imageLoad;
  
  /// App metadata
  static const String appName = 'Venyu';
  static const String appVersion = '1.0.0';
  
  /// Validate all configuration on app startup
  static bool validateConfiguration() {
    try {
      // Validate environment configuration
      EnvironmentConfig.validateConfig();
      
      // Add any additional validation here
      return true;
    } catch (e) {
      if (EnvironmentConfig.isDebug) {
        debugPrint('Configuration validation failed: $e');
      }
      return false;
    }
  }
}