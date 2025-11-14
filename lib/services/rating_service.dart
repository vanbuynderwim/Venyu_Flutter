import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_review/in_app_review.dart';

import '../core/utils/app_logger.dart';

/// Service for managing in-app rating requests
///
/// This service handles:
/// - Tracking if user has been asked to rate the app
/// - Showing native rating dialog at appropriate moments
/// - Following platform guidelines for rating requests
class RatingService {
  RatingService._();
  static final RatingService shared = RatingService._();

  final InAppReview _inAppReview = InAppReview.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _hasRequestedRatingKey = 'has_requested_rating';

  /// Check if we can show the native rating dialog
  Future<bool> canRequestReview() async {
    try {
      // Check if rating dialog is available on this platform
      final isAvailable = await _inAppReview.isAvailable();
      if (!isAvailable) {
        AppLogger.info('In-app review not available on this platform', context: 'RatingService');
        return false;
      }

      // Check if we've already requested a rating
      final hasRequested = await hasRequestedRating();
      if (hasRequested) {
        AppLogger.info('User has already been asked for a rating', context: 'RatingService');
        return false;
      }

      return true;
    } catch (error) {
      AppLogger.error('Error checking if can request review', error: error, context: 'RatingService');
      return false;
    }
  }

  /// Request app rating from user
  /// Shows the native rating dialog
  Future<void> requestReview() async {
    try {
      final canRequest = await canRequestReview();
      if (!canRequest) {
        AppLogger.debug('Cannot request review at this time', context: 'RatingService');
        return;
      }

      AppLogger.info('Requesting app rating from user', context: 'RatingService');

      // Show the native rating dialog
      await _inAppReview.requestReview();

      // Mark that we've requested a rating
      await _markRatingRequested();

      AppLogger.success('Rating request shown successfully', context: 'RatingService');
    } catch (error) {
      AppLogger.error('Error requesting review', error: error, context: 'RatingService');
    }
  }

  /// Check if user has been asked for rating before
  Future<bool> hasRequestedRating() async {
    try {
      final value = await _secureStorage.read(key: _hasRequestedRatingKey);
      return value == 'true';
    } catch (error) {
      AppLogger.error('Error checking rating status', error: error, context: 'RatingService');
      return false;
    }
  }

  /// Mark that we've requested a rating
  Future<void> _markRatingRequested() async {
    try {
      await _secureStorage.write(key: _hasRequestedRatingKey, value: 'true');
      AppLogger.debug('Marked rating as requested', context: 'RatingService');
    } catch (error) {
      AppLogger.error('Error marking rating as requested', error: error, context: 'RatingService');
    }
  }

  /// Open the app store page for rating (fallback if native dialog not available)
  /// This is useful for a "Rate Us" button in settings
  Future<void> openStoreListing() async {
    try {
      final isAvailable = await _inAppReview.isAvailable();
      if (!isAvailable) {
        AppLogger.warning('Store listing not available', context: 'RatingService');
        return;
      }

      AppLogger.info('Opening store listing for rating', context: 'RatingService');
      await _inAppReview.openStoreListing(
        appStoreId: '6739102113', // Your iOS App Store ID
      );
    } catch (error) {
      AppLogger.error('Error opening store listing', error: error, context: 'RatingService');
    }
  }

  /// Reset rating request status (for testing purposes)
  Future<void> resetRatingStatus() async {
    try {
      await _secureStorage.delete(key: _hasRequestedRatingKey);
      AppLogger.debug('Reset rating status', context: 'RatingService');
    } catch (error) {
      AppLogger.error('Error resetting rating status', error: error, context: 'RatingService');
    }
  }
}
