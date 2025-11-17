
import '../../models/models.dart';
import '../../core/utils/app_logger.dart';
import 'base_supabase_manager.dart';
import '../../mixins/disposable_manager_mixin.dart';

/// NotificationManager - Handles notification operations
///
/// This manager is responsible for:
/// - Notification fetching with pagination
/// - Notification status updates
/// - Notification settings management
///
/// Features:
/// - Paginated notification fetching
/// - Mark notifications as read/opened
/// - Fetch notification settings (email/push preferences)
/// - Toggle notification settings (enable/disable)
class NotificationManager extends BaseSupabaseManager with DisposableManagerMixin {
  static NotificationManager? _instance;

  /// The singleton instance of [NotificationManager].
  static NotificationManager get shared {
    _instance ??= NotificationManager._internal();
    return _instance!;
  }

  /// Private constructor for singleton pattern.
  NotificationManager._internal();

  /// Fetch notifications with pagination
  Future<List<Notification>> fetchNotifications(PaginatedRequest paginatedRequest) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching notifications with pagination: $paginatedRequest', context: 'NotificationManager');

      // Call the get_notifications RPC function - exact equivalent of iOS implementation
      final result = await client
          .rpc('get_notifications', params: {'payload': paginatedRequest.toJson()})
          .select();

      AppLogger.success('Notifications RPC call successful', context: 'NotificationManager');
      AppLogger.debug('Notifications data received: ${result.length} notifications', context: 'NotificationManager');

      // Convert response to list of Notification objects
      final notifications = (result as List)
          .map((json) => Notification.fromJson(json))
          .toList();

      AppLogger.success('Notifications parsed: ${notifications.length} notifications', context: 'NotificationManager');
      return notifications;
    });
  }

  /// Update notification as opened
  Future<void> updateNotification(String notificationId) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Updating notification with ID: $notificationId', context: 'NotificationManager');

      // Call the update_notification RPC function
      await client.rpc('update_notification', params: {'p_notification_id': notificationId});

      AppLogger.success('Notification updated successfully', context: 'NotificationManager');
    });
  }

  /// Fetch notification settings
  Future<List<NotificationSetting>> fetchNotificationSettings() async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Fetching notification settings', context: 'NotificationManager');

      // Call the get_notification_settings RPC function
      final result = await client.rpc('get_notification_settings').select();

      AppLogger.success('Notification settings RPC call successful', context: 'NotificationManager');
      AppLogger.debug('Notification settings data received: ${result.length} settings', context: 'NotificationManager');

      // Convert response to list of NotificationSetting objects
      final settings = (result as List)
          .map((json) => NotificationSetting.fromJson(json))
          .toList();

      AppLogger.success('Notification settings parsed: ${settings.length} settings', context: 'NotificationManager');
      return settings;
    });
  }

  /// Toggle notification setting (enable/disable)
  /// If the notification is currently enabled, it will be disabled and vice versa
  Future<void> toggleNotificationSetting(NotificationType type, NotificationTarget target) async {
    return executeAuthenticatedRequest(() async {
      AppLogger.info('Toggling notification setting: type=${type.value}, target=${target.value}', context: 'NotificationManager');

      // Build payload
      final payload = {
        'type': type.value,
        'target': target.value,
      };

      // Call the toggle_notification_setting RPC function
      await client.rpc('toggle_notification_setting', params: {'payload': payload});

      AppLogger.success('Notification setting toggled successfully', context: 'NotificationManager');
    });
  }
}
