import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/utils/app_logger.dart';
import '../l10n/app_localizations.dart';
import '../models/app_version.dart';
import 'supabase_managers/profile_manager.dart';
import 'toast_service.dart';

/// VersionService - Handles app version checking and update notifications
///
/// This service checks the app version against the server and notifies
/// users when a new version is available.
class VersionService {
  VersionService._();

  static final VersionService shared = VersionService._();

  /// Parse current app version from package info
  Future<AppVersion?> _getCurrentAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final versionString = packageInfo.version; // e.g., "1.2.3"

      final components = versionString.split('.').map(int.tryParse).toList();
      if (components.length < 3 || components.contains(null)) {
        AppLogger.error('Invalid version format: $versionString', context: 'VersionService');
        return null;
      }

      return AppVersion(
        version: components[0]!,
        major: components[1]!,
        minor: components[2]!,
      );
    } catch (error) {
      AppLogger.error('Failed to get current app version', error: error, context: 'VersionService');
      return null;
    }
  }

  /// Check if server version is newer than current version
  bool _isNewerVersion(AppVersion serverVersion, AppVersion currentVersion) {
    if (serverVersion.version != currentVersion.version) {
      return serverVersion.version > currentVersion.version;
    }
    if (serverVersion.major != currentVersion.major) {
      return serverVersion.major > currentVersion.major;
    }
    return serverVersion.minor > currentVersion.minor;
  }

  /// Check version and show toast if update is available
  Future<void> checkVersion(BuildContext context) async {
    try {
      AppLogger.debug('Starting version check', context: 'VersionService');

      // Get server version
      final serverVersion = await ProfileManager.shared.checkVersion();
      if (serverVersion == null) {
        AppLogger.warning('No server version available', context: 'VersionService');
        return;
      }

      // Get current app version
      final currentVersion = await _getCurrentAppVersion();
      if (currentVersion == null) {
        AppLogger.warning('Could not determine current app version', context: 'VersionService');
        return;
      }

      AppLogger.debug(
        'Version comparison - Server: ${serverVersion.toString()}, Current: ${currentVersion.toString()}',
        context: 'VersionService',
      );

      // Check if update is available
      if (_isNewerVersion(serverVersion, currentVersion)) {
        AppLogger.info('Update available: ${serverVersion.toString()}', context: 'VersionService');

        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ToastService.info(
            context: context,
            message: l10n.versionCheckUpdateAvailable,
            persistent: true, // Don't auto-dismiss version updates
          );
        }
      } else {
        AppLogger.success('App is up to date', context: 'VersionService');
      }
    } catch (error) {
      AppLogger.error('Failed to check version', error: error, context: 'VersionService');
      // Silently fail - don't show error to user
    }
  }
}
