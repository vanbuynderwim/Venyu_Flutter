/// Device model for storing FCM token and device information
/// 
/// This model represents a device that can receive push notifications.
/// It stores the FCM token along with device metadata for targeting
/// and analytics purposes.
class Device {
  /// Firebase Cloud Messaging token for this device
  final String fcmToken;
  
  /// Operating system (ios/android)
  final String deviceOS;
  
  /// Device interface type (phone/tablet)
  final String deviceInterface;
  
  /// Device model/type (e.g., iPhone 15, Pixel 7)
  final String deviceType;
  
  /// OS version (e.g., 18.0, 14)
  final String systemVersion;
  
  Device({
    required this.fcmToken,
    required this.deviceOS,
    required this.deviceInterface,
    required this.deviceType,
    required this.systemVersion,
  });
  
  /// Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'fcm_token': fcmToken,
      'device_os': deviceOS,
      'device_interface': deviceInterface,
      'device_type': deviceType,
      'system_version': systemVersion,
    };
  }
  
  /// Create from JSON response
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      fcmToken: json['fcm_token'] as String,
      deviceOS: json['device_os'] as String,
      deviceInterface: json['device_interface'] as String,
      deviceType: json['device_type'] as String,
      systemVersion: json['system_version'] as String,
    );
  }
}