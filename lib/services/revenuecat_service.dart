import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../core/utils/app_logger.dart';

/// Service for managing RevenueCat integration
class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  bool _isInitialized = false;

  /// Initialize RevenueCat with API keys from environment variables
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing RevenueCat...', context: 'RevenueCatService');
      
      // Set log level for debugging (use LogLevel.info for production)
      await Purchases.setLogLevel(LogLevel.debug);
      
      // Get API keys from environment variables
      final appleApiKey = dotenv.env['REVENUECAT_APPLE_API_KEY'];
      final googleApiKey = dotenv.env['REVENUECAT_GOOGLE_API_KEY'];
      
      if (appleApiKey == null || googleApiKey == null) {
        throw Exception('RevenueCat API keys not found in environment variables');
      }
      
      // Configure RevenueCat with platform-specific API keys
      PurchasesConfiguration configuration;
      if (Platform.isIOS) {
        configuration = PurchasesConfiguration(appleApiKey);
      } else if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(googleApiKey);
      } else {
        throw Exception('Unsupported platform for RevenueCat');
      }
      
      await Purchases.configure(configuration);
      _isInitialized = true;
      
      AppLogger.info('RevenueCat initialized successfully', context: 'RevenueCatService');
    } catch (e) {
      AppLogger.error('Failed to initialize RevenueCat', error: e, context: 'RevenueCatService');
      rethrow;
    }
  }

  /// Check if RevenueCat is initialized
  bool get isInitialized => _isInitialized;

  /// Get current customer info
  Future<CustomerInfo> getCustomerInfo() async {
    if (!_isInitialized) {
      throw Exception('RevenueCat not initialized');
    }
    return await Purchases.getCustomerInfo();
  }

  /// Get available offerings
  Future<Offerings> getOfferings() async {
    if (!_isInitialized) {
      throw Exception('RevenueCat not initialized');
    }
    return await Purchases.getOfferings();
  }

  /// Purchase a package
  Future<CustomerInfo> purchasePackage(Package package) async {
    if (!_isInitialized) {
      throw Exception('RevenueCat not initialized');
    }
    final result = await Purchases.purchaseStoreProduct(package.storeProduct);
    return result.customerInfo;
  }

  /// Restore purchases
  Future<CustomerInfo> restorePurchases() async {
    if (!_isInitialized) {
      throw Exception('RevenueCat not initialized');
    }
    return await Purchases.restorePurchases();
  }

  /// Check if user has active subscription
  bool hasActiveSubscription(CustomerInfo customerInfo) {
    return customerInfo.entitlements.active.isNotEmpty;
  }

  /// Get specific entitlement
  EntitlementInfo? getEntitlement(CustomerInfo customerInfo, String entitlementId) {
    return customerInfo.entitlements.all[entitlementId];
  }

  /// Set user ID for RevenueCat
  Future<void> setUserId(String userId) async {
    if (!_isInitialized) {
      throw Exception('RevenueCat not initialized');
    }
    await Purchases.logIn(userId);
  }

  /// Log out current user
  Future<CustomerInfo> logOut() async {
    if (!_isInitialized) {
      throw Exception('RevenueCat not initialized');
    }
    return await Purchases.logOut();
  }

  /// Get current RevenueCat app user ID
  Future<String?> getCurrentUserId() async {
    if (!_isInitialized) {
      return null;
    }
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.originalAppUserId;
    } catch (e) {
      AppLogger.warning('Failed to get RevenueCat user ID: $e', context: 'RevenueCatService');
      return null;
    }
  }
}