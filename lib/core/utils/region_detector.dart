import 'dart:io';
import 'package:flutter/services.dart';
import 'app_logger.dart';

/// RegionDetector - Utility to detect device region settings
///
/// Uses platform channels to get the actual region setting (not language locale)
/// This ensures we get "BE" for Belgium region, even if language is "en_GB"
class RegionDetector {
  RegionDetector._();

  static const MethodChannel _channel = MethodChannel('com.getvenyu.app/region');

  /// Detect device region code from system settings
  ///
  /// Returns the device's current region code (e.g., "BE" for Belgium).
  /// Falls back to detecting from locale if platform channel fails.
  static Future<String> detectRegion() async {
    try {
      // Try to get region from native platform
      final String? regionCode = await _channel.invokeMethod('getRegion');

      if (regionCode != null && regionCode.isNotEmpty) {
        AppLogger.info('Detected region from native: $regionCode', context: 'RegionDetector');
        return regionCode.toUpperCase();
      }
    } catch (error) {
      AppLogger.warning(
        'Failed to get region from native platform: $error',
        context: 'RegionDetector',
      );
    }

    // Fallback: try to extract from locale
    return _detectRegionFromLocale();
  }

  /// Fallback: Extract region from locale
  static String _detectRegionFromLocale() {
    try {
      final locale = Platform.localeName; // e.g., "en_GB"

      if (locale.contains('_')) {
        final countryCode = locale.split('_').last.toUpperCase();
        AppLogger.info(
          'Detected region from locale fallback: $countryCode',
          context: 'RegionDetector',
        );
        return countryCode;
      }

      // If no region in locale, use default fallback
      AppLogger.info(
        'No region found in locale, using fallback BE',
        context: 'RegionDetector',
      );
      return 'BE';
    } catch (error) {
      AppLogger.error(
        'Error detecting region, using fallback BE',
        error: error,
        context: 'RegionDetector',
      );
      return 'BE';
    }
  }
}
