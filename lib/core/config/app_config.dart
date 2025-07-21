import 'package:flutter/foundation.dart';
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
  
  /// External service URLs
  static const String avatarBucketBase = 'https://venyu-avatars.s3.amazonaws.com';
  static const String placeholderImageBase = 'https://via.placeholder.com';
  
  /// Helper methods for building URLs
  static String avatarUrl(String avatarId) => '$avatarBucketBase/$avatarId.jpg';
  
  static String placeholderIconUrl({
    required String text,
    int size = 64,
    String backgroundColor = '007AFF',
    String textColor = 'FFFFFF',
  }) => '$placeholderImageBase/$size/$backgroundColor/$textColor?text=$text';
  
  /// Network configuration
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration imageLoadTimeout = Duration(seconds: 10);
  
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