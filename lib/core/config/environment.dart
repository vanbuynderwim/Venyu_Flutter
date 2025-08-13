import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration for different build targets
/// 
/// This enum defines the available environments for the app.
/// Use build-time configuration to set the appropriate environment.
enum Environment { 
  development, 
  staging, 
  production 
}

/// Environment-based configuration management
/// 
/// This class provides secure access to environment-specific configuration
/// values loaded from .env.local file at runtime.
class EnvironmentConfig {
  // Environment is loaded from .env.local file
  static Environment get _environment {
    final envName = dotenv.env['ENVIRONMENT'] ?? 'development';
    switch (envName) {
      case 'production':
        return Environment.production;
      case 'staging':
        return Environment.staging;
      case 'development':
      default:
        return Environment.development;
    }
  }
  
  /// Current environment
  static Environment get environment => _environment;
  
  /// Supabase configuration
  static String get supabaseUrl {
    switch (_environment) {
      case Environment.development:
        return dotenv.env['SUPABASE_URL_DEV'] ?? '';
      case Environment.staging:
        return dotenv.env['SUPABASE_URL_STAGING'] ?? '';
      case Environment.production:
        return dotenv.env['SUPABASE_URL_PROD'] ?? '';
    }
  }
  
  static String get supabaseAnonKey {
    switch (_environment) {
      case Environment.development:
        return dotenv.env['SUPABASE_KEY_DEV'] ?? '';
      case Environment.staging:
        return dotenv.env['SUPABASE_KEY_STAGING'] ?? '';
      case Environment.production:
        return dotenv.env['SUPABASE_KEY_PROD'] ?? '';
    }
  }
  
  /// Google OAuth configuration
  static String get googleWebClientId {
    switch (_environment) {
      case Environment.development:
        return dotenv.env['GOOGLE_WEB_CLIENT_ID_DEV'] ?? '';
      case Environment.staging:
        return dotenv.env['GOOGLE_WEB_CLIENT_ID_STAGING'] ?? '';
      case Environment.production:
        return dotenv.env['GOOGLE_WEB_CLIENT_ID_PROD'] ?? '';
    }
  }
  
  static String get googleIosClientId {
    switch (_environment) {
      case Environment.development:
        return dotenv.env['GOOGLE_IOS_CLIENT_ID_DEV'] ?? '';
      case Environment.staging:
        return dotenv.env['GOOGLE_IOS_CLIENT_ID_STAGING'] ?? '';
      case Environment.production:
        return dotenv.env['GOOGLE_IOS_CLIENT_ID_PROD'] ?? '';
    }
  }
  
  /// Debug and environment helpers
  static bool get isDebug => _environment == Environment.development;
  static bool get isProduction => _environment == Environment.production;
  static bool get isStaging => _environment == Environment.staging;
  
  /// Validate configuration on app startup
  static bool validateConfig() {
    final url = supabaseUrl;
    final key = supabaseAnonKey;
    final googleWebId = googleWebClientId;
    final googleIosId = googleIosClientId;
    
    if (url.isEmpty) {
      throw Exception('Supabase URL is not configured for environment: $_environment');
    }
    
    if (key.isEmpty) {
      throw Exception('Supabase anonymous key is not configured for environment: $_environment');
    }
    
    // Google OAuth configuration is optional for now
    if (googleWebId.isEmpty) {
      debugPrint('⚠️ Google Web Client ID is not configured for environment: $_environment');
    }
    
    if (googleIosId.isEmpty) {
      debugPrint('⚠️ Google iOS Client ID is not configured for environment: $_environment');
    }
    
    return true;
  }
}