import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/utils/app_logger.dart';
import '../core/utils/device_info.dart';
import '../models/device.dart';
import '../models/badge_data.dart';
import '../firebase_options.dart';
import 'supabase_managers/profile_manager.dart';
import 'supabase_managers/base_supabase_manager.dart';
import 'auth_service.dart';
import 'profile_service.dart';

/// Service for managing Firebase Cloud Messaging and push notifications
/// 
/// This service handles:
/// - Firebase initialization
/// - Requesting notification permissions
/// - Managing FCM tokens
/// - Registering devices with the backend
class NotificationService {
  NotificationService._();
  static final NotificationService shared = NotificationService._();
  
  FirebaseMessaging? _messaging;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  String? _fcmToken;
  bool _isInitialized = false;

  // Badge update callback
  Function(BadgeData)? _onBadgeUpdate;

  // Local badge data for manual updates
  BadgeData? _currentBadgeData;
  
  /// FCM token for this device
  String? get fcmToken => _fcmToken;

  /// Set callback for badge updates
  void setBadgeUpdateCallback(Function(BadgeData)? callback) {
    _onBadgeUpdate = callback;
  }
  
  /// Initialize Firebase and set up messaging
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Check if Firebase is already initialized with multiple safety checks
      try {
        // Try to get the default app
        final app = Firebase.app();
        AppLogger.info('Firebase already initialized: ${app.name}', context: 'NotificationService');
      } catch (e) {
        // Firebase not initialized or error occurred
        try {
          // Double-check by looking at all apps
          if (Firebase.apps.isNotEmpty) {
            AppLogger.info('Firebase already has ${Firebase.apps.length} app(s) initialized', context: 'NotificationService');
          } else {
            // Really not initialized, initialize it now
            await Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            );
            AppLogger.info('Firebase initialized', context: 'NotificationService');
          }
        } catch (initError) {
          // If initialization fails, check if it's because it's already initialized
          if (initError.toString().contains('duplicate-app') ||
              initError.toString().contains('already exists')) {
            AppLogger.warning('Firebase was already initialized by another instance', context: 'NotificationService');
          } else {
            rethrow;
          }
        }
      }

      // Initialize Firebase Messaging after Firebase is initialized
      _messaging = FirebaseMessaging.instance;
      
      _isInitialized = true;
      
      // Get stored FCM token if exists
      _fcmToken = await _secureStorage.read(key: 'fcm_token');
      
      // Set up token refresh listener
      _messaging!.onTokenRefresh.listen(_handleTokenRefresh);
      
      // Get initial token
      await _refreshToken();
      
      AppLogger.success('NotificationService initialized', context: 'NotificationService');
    } catch (error) {
      AppLogger.error('Failed to initialize NotificationService: $error', context: 'NotificationService');
      rethrow;
    }
  }
  
  /// Request notification permissions from the user
  /// Returns true if permission granted, false otherwise
  Future<bool> requestPermission() async {
    AppLogger.debug('NotificationService.requestPermission() called', context: 'NotificationService');
    
    if (_messaging == null) {
      AppLogger.debug('Messaging is null, initializing...', context: 'NotificationService');
      await initialize();
    }
    
    try {
      AppLogger.debug('Calling _messaging.requestPermission()...', context: 'NotificationService');
      // Request permission
      final NotificationSettings settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false, // Don't use provisional authorization
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );
      
      AppLogger.debug('Permission settings received: ${settings.authorizationStatus}', context: 'NotificationService');
      
      // Check if permission was granted
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        AppLogger.success('Notification permission granted (authorized)', context: 'NotificationService');
        
        // Get and register FCM token
        await _refreshToken();
        
        return true;
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        AppLogger.warning('Provisional notification permission granted', context: 'NotificationService');
        
        // Still register token for provisional permission
        await _refreshToken();
        
        return true;
      } else {
        AppLogger.error('Notification permission denied: ${settings.authorizationStatus}', context: 'NotificationService');
        return false;
      }
    } catch (error, stackTrace) {
      AppLogger.error('Error requesting notification permission: $error', context: 'NotificationService');
      AppLogger.error('Stack trace: $stackTrace', context: 'NotificationService');
      return false;
    }
  }
  
  /// Check current notification permission status
  Future<AuthorizationStatus> getPermissionStatus() async {
    if (_messaging == null) {
      await initialize();
    }
    
    final settings = await _messaging!.getNotificationSettings();
    return settings.authorizationStatus;
  }
  
  /// Refresh FCM token and register with backend
  Future<void> _refreshToken() async {
    AppLogger.debug('_refreshToken called', context: 'NotificationService');
    
    if (_messaging == null) {
      AppLogger.debug('_messaging is null, returning', context: 'NotificationService');
      return;
    }
    
    try {
      AppLogger.debug('Getting FCM token...', context: 'NotificationService');
      // Get FCM token
      final token = await _messaging!.getToken();
      AppLogger.debug('Current token: $token', context: 'NotificationService');
      AppLogger.debug('Stored token: $_fcmToken', context: 'NotificationService');
      
      if (token != null && token != _fcmToken) {
        AppLogger.debug('New FCM token detected: $token', context: 'NotificationService');
        
        // Store token locally
        _fcmToken = token;
        await _secureStorage.write(key: 'fcm_token', value: token);
        
        // Register with backend
        await _registerDevice(token);
      } else if (token != null && token == _fcmToken) {
        AppLogger.debug('Token unchanged, but registering anyway to ensure backend sync', context: 'NotificationService');
        // Register with backend even if token is the same (in case previous registration failed)
        await _registerDevice(token);
      } else {
        AppLogger.debug('No token available', context: 'NotificationService');
      }
    } catch (error, stackTrace) {
      AppLogger.error('Error refreshing FCM token: $error', context: 'NotificationService');
      AppLogger.error('Stack trace: $stackTrace', context: 'NotificationService');
    }
  }
  
  /// Handle token refresh events
  void _handleTokenRefresh(String token) {
    AppLogger.debug('FCM token refreshed: $token', context: 'NotificationService');
    
    // Store new token
    _fcmToken = token;
    _secureStorage.write(key: 'fcm_token', value: token);
    
    // Register with backend
    _registerDevice(token);
  }
  
  /// Register device token with backend
  /// Only registers if user is authenticated
  Future<void> _registerDevice(String token) async {
    AppLogger.debug('_registerDevice called with token: $token', context: 'NotificationService');

    // Check if user is authenticated
    if (!AuthService.shared.isAuthenticated) {
      AppLogger.debug('User not authenticated, skipping device registration', context: 'NotificationService');
      return;
    }

    try {
      // Get device info
      final String deviceOS = Platform.isIOS ? 'ios' : 'android';
      final String deviceInterface = _getDeviceInterface();
      final String deviceType = await _getDeviceType();
      final String systemVersion = await _getSystemVersion();

      AppLogger.debug('Device info: OS=$deviceOS, Interface=$deviceInterface, Type=$deviceType, Version=$systemVersion', context: 'NotificationService');

      // Create device object
      final device = Device(
        fcmToken: token,
        deviceOS: deviceOS,
        deviceInterface: deviceInterface,
        deviceType: deviceType,
        systemVersion: systemVersion,
      );

      AppLogger.debug('Calling ProfileManager.insertDeviceToken...', context: 'NotificationService');
      // Send to backend
      await ProfileManager.shared.insertDeviceToken(device);

      AppLogger.success('Device registered with backend', context: 'NotificationService');

      // Subscribe to daily reminder topic based on device language
      await _subscribeToTopics();
    } catch (error, stackTrace) {
      AppLogger.error('Error registering device', error: error, stackTrace: stackTrace, context: 'NotificationService');
    }
  }

  /// Subscribe to Firebase Cloud Messaging topics based on user's language
  Future<void> _subscribeToTopics() async {
    if (_messaging == null) return;

    try {
      // Get language code from profile (server ensures it's 'en' or 'nl')
      // Fallback to device language if profile not available yet
      String languageCode = ProfileService.shared.currentProfile?.languageCode ?? DeviceInfo.detectLanguage();

      // Ensure language code is 'en' or 'nl' (app only supports these)
      if (languageCode != 'en' && languageCode != 'nl') {
        AppLogger.debug('Language code "$languageCode" not supported, defaulting to "en"', context: 'NotificationService');
        languageCode = 'en';
      }

      final topicName = 'daily_reminder_$languageCode';

      AppLogger.debug('Subscribing to topic: $topicName (from profile: ${ProfileService.shared.currentProfile?.languageCode})', context: 'NotificationService');

      // Subscribe to the daily reminder topic for this language
      await _messaging!.subscribeToTopic(topicName);

      AppLogger.success('Successfully subscribed to topic: $topicName', context: 'NotificationService');
    } catch (error, stackTrace) {
      AppLogger.error('Error subscribing to topics', error: error, stackTrace: stackTrace, context: 'NotificationService');
    }
  }

  /// Register pending device token if user just logged in
  /// Call this after successful authentication
  Future<void> registerPendingToken() async {
    if (_fcmToken != null && AuthService.shared.isAuthenticated) {
      AppLogger.debug('Registering pending device token after authentication', context: 'NotificationService');
      await _registerDevice(_fcmToken!);
    }
  }
  
  /// Get device interface type (phone/tablet)
  String _getDeviceInterface() {
    // For Flutter, we need to determine this differently
    // This is a simplified version - you might want to use device_info_plus package
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isIOS || Platform.isAndroid) {
      // Would need device_info_plus to properly detect tablet vs phone
      return 'phone'; // Default to phone for now
    } else {
      return 'desktop';
    }
  }
  
  /// Fetch badge counts for tab bar items
  Future<BadgeData?> fetchBadges() async {
    try {
      AppLogger.debug('Fetching badge counts...', context: 'NotificationService');
      
      final client = BaseSupabaseManager.getClient();
      final response = await client.rpc('get_badges');
      
      if (response == null) {
        AppLogger.warning('No badge data returned', context: 'NotificationService');
        return null;
      }
      
      // Response is a list with single item for single-row functions
      final data = response is List && response.isNotEmpty 
          ? response.first as Map<String, dynamic>
          : response as Map<String, dynamic>;
      
      final badgeData = BadgeData.fromJson(data);

      // Store current badge data for manual updates
      _currentBadgeData = badgeData;

      AppLogger.debug(
        'Badge counts: notifications=${badgeData.unreadNotifications}, '
        'matches=${badgeData.matchesCount}, '
        'reviews=${badgeData.totalReviews}',
        context: 'NotificationService'
      );

      // Notify callback if set
      _onBadgeUpdate?.call(badgeData);

      return badgeData;
    } catch (error) {
      AppLogger.error('Failed to fetch badge counts', error: error, context: 'NotificationService');
      return null;
    }
  }
  
  /// Get device type/model
  Future<String> _getDeviceType() async {
    // Would need device_info_plus package for actual device model
    // For now, return platform name
    if (Platform.isIOS) {
      return 'iPhone'; // Would be actual model with device_info_plus
    } else if (Platform.isAndroid) {
      return 'Android Device';
    } else {
      return 'Unknown';
    }
  }
  
  /// Get system version
  Future<String> _getSystemVersion() async {
    // Would need device_info_plus package for actual version
    // For now, return platform version
    return Platform.operatingSystemVersion;
  }
  
  /// Clear stored FCM token (for logout)
  Future<void> clearToken() async {
    _fcmToken = null;
    await _secureStorage.delete(key: 'fcm_token');
  }

  /// Manually decrease matches badge count by 1
  void decreaseMatchesBadge() {
    if (_currentBadgeData != null && _currentBadgeData!.matchesCount > 0) {
      final updatedBadgeData = BadgeData(
        unreadNotifications: _currentBadgeData!.unreadNotifications,
        matchesCount: _currentBadgeData!.matchesCount - 1,
        userReviewsCount: _currentBadgeData!.userReviewsCount,
        systemReviewsCount: _currentBadgeData!.systemReviewsCount,
        invitesCount: _currentBadgeData!.invitesCount,
      );

      _currentBadgeData = updatedBadgeData;

      // Notify callback with updated badge data
      _onBadgeUpdate?.call(updatedBadgeData);

      AppLogger.debug(
        'Decreased matches badge count to ${updatedBadgeData.matchesCount}',
        context: 'NotificationService'
      );
    }
  }
}