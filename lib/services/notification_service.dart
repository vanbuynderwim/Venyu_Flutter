import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/utils/app_logger.dart';
import '../models/device.dart';
import '../firebase_options.dart';
import 'supabase_managers/profile_manager.dart';

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
  
  /// FCM token for this device
  String? get fcmToken => _fcmToken;
  
  /// Initialize Firebase and set up messaging
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Check if Firebase is already initialized
      try {
        Firebase.app();
        AppLogger.info('Firebase already initialized', context: 'NotificationService');
      } on FirebaseException catch (_) {
        // Firebase not initialized, initialize it
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        AppLogger.info('Firebase initialized', context: 'NotificationService');
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
  Future<void> _registerDevice(String token) async {
    AppLogger.debug('_registerDevice called with token: $token', context: 'NotificationService');
    
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
      
      AppLogger.debug('Calling SupabaseManager.insertDeviceToken...', context: 'NotificationService');
      // Send to backend
      await ProfileManager.shared.insertDeviceToken(device);
      
      AppLogger.success('Device registered with backend', context: 'NotificationService');
    } catch (error, stackTrace) {
      AppLogger.error('Error registering device: $error', context: 'NotificationService');
      AppLogger.error('Stack trace: $stackTrace', context: 'NotificationService');
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
}