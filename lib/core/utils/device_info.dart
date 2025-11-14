import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'app_logger.dart';
import 'region_detector.dart';

/// DeviceInfo - Utility class to detect device information
///
/// Equivalent to iOS device detection functions used in SupabaseManager.
class DeviceInfo {
  DeviceInfo._();

  /// Detect device country code - equivalent to iOS detectCountry()
  ///
  /// Returns the device's current country/region code based on system settings.
  /// Uses native platform channels to get the actual region setting, not language.
  /// Falls back to 'NL' if detection fails (matching iOS behavior).
  ///
  /// Note: This is now async to support platform channel communication.
  static Future<String> detectCountry() async {
    try {
      // Use RegionDetector to get the actual region from system settings
      // This ensures we get "BE" for Belgium region, even if language is "en_GB"
      final countryCode = await RegionDetector.detectRegion();
      AppLogger.info('Detected country/region code: $countryCode', context: 'DeviceInfo');
      return countryCode;
    } catch (error) {
      AppLogger.error('Error detecting country, using fallback NL', error: error, context: 'DeviceInfo');
      return 'NL'; // Default fallback matching iOS
    }
  }

  /// Detect device language code - equivalent to iOS detectLanguage()
  /// 
  /// Returns the device's current language code.
  /// Falls back to 'nl' if detection fails (matching iOS behavior).
  static String detectLanguage() {
    try {
      // Get the device locale
      final locale = Platform.localeName; // e.g., "en_US" or "nl_NL"
      
      String languageCode;
      if (locale.contains('_')) {
        languageCode = locale.split('_').first.toLowerCase();
      } else {
        languageCode = locale.toLowerCase();
      }
      
      AppLogger.info('Detected language code: $languageCode', context: 'DeviceInfo');
      return languageCode;
      
    } catch (error) {
      AppLogger.error('Error detecting language, using fallback en', error: error, context: 'DeviceInfo');
      return 'en'; // Default fallback matching iOS
    }
  }

  /// Get device OS as string ('ios' or 'android')
  ///
  /// Returns the device operating system identifier used by the backend.
  static String getDeviceOS() {
    return Platform.isIOS ? 'ios' : 'android';
  }

  /// Detect app version - equivalent to iOS detectAppVersion()
  ///
  /// Returns the app's current version string (e.g., "1.0.0").
  /// This is an async method as it requires package info lookup.
  static Future<String> detectAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;
      AppLogger.info('Detected app version: $version', context: 'DeviceInfo');
      return version;

    } catch (error) {
      AppLogger.error('Error detecting app version, using fallback 1.0.0', error: error, context: 'DeviceInfo');
      return '1.0.0'; // Default fallback
    }
  }

  /// Get complete device info for debugging - equivalent to iOS debug info
  static Future<Map<String, dynamic>> getDebugInfo() async {
    final country = await detectCountry();
    final language = detectLanguage();
    final appVersion = await detectAppVersion();

    return {
      'countryCode': country,
      'languageCode': language,
      'appVersion': appVersion,
      'platform': Platform.operatingSystem,
      'platformVersion': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
    };
  }
}