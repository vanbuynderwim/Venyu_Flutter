import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/utils/app_logger.dart';

/// Service for managing tutorial state for returning users
///
/// This service handles:
/// - Tracking if user has seen the updated tutorial after app update
/// - Providing a reset method for testing purposes
class TutorialService {
  TutorialService._();
  static final TutorialService shared = TutorialService._();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Key for storing if user has seen the v2 tutorial (after app update)
  // Increment this version number when you want to show the tutorial again
  static const String _tutorialVersionKey = 'tutorial_version_shown';
  static const String _currentTutorialVersion = 'v2'; // Change this to force re-show

  /// Check if user needs to see the re-tutorial
  /// Returns true if user has NOT seen the current tutorial version
  Future<bool> needsToShowTutorial() async {
    try {
      final shownVersion = await _secureStorage.read(key: _tutorialVersionKey);
      final needsShow = shownVersion != _currentTutorialVersion;

      AppLogger.debug(
        'Tutorial check: shown=$shownVersion, current=$_currentTutorialVersion, needsShow=$needsShow',
        context: 'TutorialService',
      );

      return needsShow;
    } catch (error) {
      AppLogger.error('Error checking tutorial status', error: error, context: 'TutorialService');
      return false; // Don't show on error
    }
  }

  /// Mark that user has seen the current tutorial version
  Future<void> markTutorialShown() async {
    try {
      await _secureStorage.write(key: _tutorialVersionKey, value: _currentTutorialVersion);
      AppLogger.info('Marked tutorial as shown (version: $_currentTutorialVersion)', context: 'TutorialService');
    } catch (error) {
      AppLogger.error('Error marking tutorial as shown', error: error, context: 'TutorialService');
    }
  }

  /// Reset tutorial status (for testing purposes)
  /// This allows showing the tutorial again without reinstalling the app
  Future<void> resetTutorialStatus() async {
    try {
      await _secureStorage.delete(key: _tutorialVersionKey);
      AppLogger.debug('Reset tutorial status', context: 'TutorialService');
    } catch (error) {
      AppLogger.error('Error resetting tutorial status', error: error, context: 'TutorialService');
    }
  }
}
