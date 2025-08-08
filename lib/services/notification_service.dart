import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/device.dart';
import '../firebase_options.dart';
import 'supabase_manager.dart';

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
        debugPrint('🔥 Firebase already initialized');
      } on FirebaseException catch (_) {
        // Firebase not initialized, initialize it
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        debugPrint('🔥 Firebase initialized');
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
      
      debugPrint('🔔 NotificationService initialized');
    } catch (error) {
      debugPrint('❌ Failed to initialize NotificationService: $error');
      rethrow;
    }
  }
  
  /// Request notification permissions from the user
  /// Returns true if permission granted, false otherwise
  Future<bool> requestPermission() async {
    debugPrint('🔔 NotificationService.requestPermission() called');
    
    if (_messaging == null) {
      debugPrint('🔔 Messaging is null, initializing...');
      await initialize();
    }
    
    try {
      debugPrint('🔔 Calling _messaging.requestPermission()...');
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
      
      debugPrint('🔔 Permission settings received: ${settings.authorizationStatus}');
      
      // Check if permission was granted
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ Notification permission granted (authorized)');
        
        // Get and register FCM token
        await _refreshToken();
        
        return true;
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('⚠️ Provisional notification permission granted');
        
        // Still register token for provisional permission
        await _refreshToken();
        
        return true;
      } else {
        debugPrint('❌ Notification permission denied: ${settings.authorizationStatus}');
        return false;
      }
    } catch (error, stackTrace) {
      debugPrint('❌ Error requesting notification permission: $error');
      debugPrint('❌ Stack trace: $stackTrace');
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
    debugPrint('🔔 _refreshToken called');
    
    if (_messaging == null) {
      debugPrint('🔔 _messaging is null, returning');
      return;
    }
    
    try {
      debugPrint('🔔 Getting FCM token...');
      // Get FCM token
      final token = await _messaging!.getToken();
      debugPrint('🔔 Current token: $token');
      debugPrint('🔔 Stored token: $_fcmToken');
      
      if (token != null && token != _fcmToken) {
        debugPrint('🔔 New FCM token detected: $token');
        
        // Store token locally
        _fcmToken = token;
        await _secureStorage.write(key: 'fcm_token', value: token);
        
        // Register with backend
        await _registerDevice(token);
      } else if (token != null && token == _fcmToken) {
        debugPrint('🔔 Token unchanged, but registering anyway to ensure backend sync');
        // Register with backend even if token is the same (in case previous registration failed)
        await _registerDevice(token);
      } else {
        debugPrint('🔔 No token available');
      }
    } catch (error, stackTrace) {
      debugPrint('❌ Error refreshing FCM token: $error');
      debugPrint('❌ Stack trace: $stackTrace');
    }
  }
  
  /// Handle token refresh events
  void _handleTokenRefresh(String token) {
    debugPrint('🔔 FCM token refreshed: $token');
    
    // Store new token
    _fcmToken = token;
    _secureStorage.write(key: 'fcm_token', value: token);
    
    // Register with backend
    _registerDevice(token);
  }
  
  /// Register device token with backend
  Future<void> _registerDevice(String token) async {
    debugPrint('🔔 _registerDevice called with token: $token');
    
    try {
      // Get device info
      final String deviceOS = Platform.isIOS ? 'ios' : 'android';
      final String deviceInterface = _getDeviceInterface();
      final String deviceType = await _getDeviceType();
      final String systemVersion = await _getSystemVersion();
      
      debugPrint('🔔 Device info: OS=$deviceOS, Interface=$deviceInterface, Type=$deviceType, Version=$systemVersion');
      
      // Create device object
      final device = Device(
        fcmToken: token,
        deviceOS: deviceOS,
        deviceInterface: deviceInterface,
        deviceType: deviceType,
        systemVersion: systemVersion,
      );
      
      debugPrint('🔔 Calling SupabaseManager.insertDeviceToken...');
      // Send to backend
      await SupabaseManager.shared.insertDeviceToken(device);
      
      debugPrint('✅ Device registered with backend');
    } catch (error, stackTrace) {
      debugPrint('❌ Error registering device: $error');
      debugPrint('❌ Stack trace: $stackTrace');
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