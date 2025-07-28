import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// DeviceInfo - Utility class to detect device information
/// 
/// Equivalent to iOS device detection functions used in SupabaseManager.
class DeviceInfo {
  DeviceInfo._();

  /// Detect device country code - equivalent to iOS detectCountry()
  /// 
  /// Returns the device's current country code based on locale.
  /// Falls back to 'NL' if detection fails (matching iOS behavior).
  static String detectCountry() {
    try {
      // Get the device locale
      final locale = Platform.localeName; // e.g., "en_US" or "nl_NL"
      
      if (locale.contains('_')) {
        final countryCode = locale.split('_').last.toUpperCase();
        debugPrint('🌍 Detected country code: $countryCode');
        return countryCode;
      }
      
      // Fallback mapping for common locales without country codes
      final languageToCountryMap = {
        'en': 'US',
        'nl': 'NL', 
        'de': 'DE',
        'fr': 'FR',
        'es': 'ES',
        'it': 'IT',
        'pt': 'PT',
      };
      
      final languageCode = locale.toLowerCase();
      final countryCode = languageToCountryMap[languageCode] ?? 'NL';
      debugPrint('🌍 Mapped country code from language $languageCode: $countryCode');
      return countryCode;
      
    } catch (error) {
      debugPrint('❌ Error detecting country: $error, using fallback NL');
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
      
      debugPrint('🗣️ Detected language code: $languageCode');
      return languageCode;
      
    } catch (error) {
      debugPrint('❌ Error detecting language: $error, using fallback nl');
      return 'nl'; // Default fallback matching iOS
    }
  }

  /// Detect app version - equivalent to iOS detectAppVersion()
  /// 
  /// Returns the app's current version string (e.g., "1.0.0").
  /// This is an async method as it requires package info lookup.
  static Future<String> detectAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;
      debugPrint('📱 Detected app version: $version');
      return version;
      
    } catch (error) {
      debugPrint('❌ Error detecting app version: $error, using fallback 1.0.0');
      return '1.0.0'; // Default fallback
    }
  }

  /// Get complete device info for debugging - equivalent to iOS debug info
  static Future<Map<String, dynamic>> getDebugInfo() async {
    final country = detectCountry();
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