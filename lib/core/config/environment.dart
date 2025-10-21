import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment-based configuration management
///
/// This class provides secure access to environment-specific configuration
/// values loaded from .env files at runtime.
///
/// The environment is determined by which .env file is loaded:
/// - Debug mode: .env.local (development)
/// - Release mode: .env.prod (production)
///
/// Each .env file contains only the configuration for that specific environment,
/// without environment suffixes (e.g., SUPABASE_URL instead of SUPABASE_URL_DEV).
class EnvironmentConfig {
  /// Supabase configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_KEY'] ?? '';

  /// Google OAuth configuration
  static String get googleWebClientId => dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';
  static String get googleIosClientId => dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '';

  /// Apple Sign-In configuration (required for Android)
  static String get appleClientId => dotenv.env['APPLE_CLIENT_ID'] ?? '';
  static String get appleRedirectUri => dotenv.env['APPLE_REDIRECT_URI'] ?? '';

  /// RevenueCat configuration
  static String get revenueCatAppleApiKey => dotenv.env['REVENUECAT_APPLE_API_KEY'] ?? '';
  static String get revenueCatGoogleApiKey => dotenv.env['REVENUECAT_GOOGLE_API_KEY'] ?? '';

  /// Debug and environment helpers
  /// These are based on Flutter's kDebugMode and kReleaseMode constants
  static bool get isDebug => kDebugMode;
  static bool get isProduction => kReleaseMode;

  /// Validate configuration on app startup
  static bool validateConfig() {
    final url = supabaseUrl;
    final key = supabaseAnonKey;
    final googleWebId = googleWebClientId;
    final googleIosId = googleIosClientId;
    final appleClientIdValue = appleClientId;
    final appleRedirectUriValue = appleRedirectUri;

    if (url.isEmpty) {
      throw Exception('SUPABASE_URL is not configured');
    }

    if (key.isEmpty) {
      throw Exception('SUPABASE_KEY is not configured');
    }

    // Google OAuth configuration is optional for now
    if (googleWebId.isEmpty) {
      debugPrint('⚠️ GOOGLE_WEB_CLIENT_ID is not configured');
    }

    if (googleIosId.isEmpty) {
      debugPrint('⚠️ GOOGLE_IOS_CLIENT_ID is not configured');
    }

    // Apple Sign-In configuration is optional for now
    if (appleClientIdValue.isEmpty) {
      debugPrint('⚠️ APPLE_CLIENT_ID is not configured');
    }

    if (appleRedirectUriValue.isEmpty) {
      debugPrint('⚠️ APPLE_REDIRECT_URI is not configured');
    }

    // RevenueCat configuration is optional for now
    final revenueCatApple = revenueCatAppleApiKey;
    final revenueCatGoogle = revenueCatGoogleApiKey;

    if (revenueCatApple.isEmpty) {
      debugPrint('⚠️ REVENUECAT_APPLE_API_KEY is not configured');
    }

    if (revenueCatGoogle.isEmpty) {
      debugPrint('⚠️ REVENUECAT_GOOGLE_API_KEY is not configured');
    }

    return true;
  }
}