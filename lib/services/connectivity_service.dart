import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../core/utils/app_logger.dart';
import '../l10n/app_localizations.dart';
import 'toast_service.dart';

/// ConnectivityService - Monitors network connectivity
///
/// This service uses connectivity_plus to monitor real-time network status
/// and shows persistent error toasts when connection is lost.
/// Similar to iOS NWPathMonitor implementation.
class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService shared = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = true;
  bool _isShowingToast = false;
  BuildContext? _context;

  /// Initialize connectivity monitoring
  void initialize(BuildContext context) {
    AppLogger.debug('Initializing connectivity monitoring', context: 'ConnectivityService');
    _context = context;

    // Listen to connectivity changes (like NWPathMonitor)
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      _handleConnectivityChange(results);
    });

    // Check initial connectivity status
    _checkInitialConnectivity();
  }

  /// Check initial connectivity status
  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    } catch (error) {
      AppLogger.error('Error checking initial connectivity', error: error, context: 'ConnectivityService');
    }
  }

  /// Handle connectivity change
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    // Check if we have any active connection
    final hasConnection = results.any((result) =>
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.ethernet
    );

    if (!hasConnection && _isConnected) {
      // Connection lost
      _isConnected = false;
      _showNoConnectionToast();
      AppLogger.warning('Internet connection lost', context: 'ConnectivityService');
    } else if (hasConnection && !_isConnected) {
      // Connection restored
      _isConnected = true;
      _isShowingToast = false;
      ToastService.dismiss();
      AppLogger.success('Internet connection restored', context: 'ConnectivityService');
    }
  }

  /// Show no connection toast
  void _showNoConnectionToast() {
    if (_isShowingToast || _context == null) return;

    _isShowingToast = true;
    AppLogger.warning('No internet connection detected', context: 'ConnectivityService');

    if (_context!.mounted) {
      final l10n = AppLocalizations.of(_context!)!;
      ToastService.error(
        context: _context!,
        message: l10n.errorNoInternetConnection,
        persistent: true, // Don't auto-dismiss connection errors
      );
    }
  }

  /// Check if currently connected
  bool get isConnected => _isConnected;

  /// Dispose of the service
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _context = null;
  }
}
