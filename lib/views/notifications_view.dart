import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_assets.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../widgets/scaffolds/app_scaffold.dart';

/// NotificationsView - Notifications page with ListView for server data
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual notifications data from server
    final List<Map<String, dynamic>> dummyNotifications = List.generate(
      15,
      (index) => {
        'title': 'New ${index % 3 == 0 ? 'Match' : index % 3 == 1 ? 'Message' : 'Connection'}',
        'subtitle': index % 3 == 0 
            ? 'You have a new match with someone!'
            : index % 3 == 1 
                ? 'New message from your connection'
                : 'Someone wants to connect with you',
        'time': '${index + 1}h ago',
        'isUnread': index < 5,
        'type': index % 3 == 0 ? 'match' : index % 3 == 1 ? 'message' : 'connection',
      },
    );

    return AppListScaffold(
      appBar: PlatformAppBar(
        title: Text(AppStrings.notifications),
      ),
      children: dummyNotifications.isEmpty
          ? [
              // Empty state als single child in ListView
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Use custom notification icon from app_assets
                      Image.asset(
                        AppAssets.icons.notification.regular,
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No new notifications',
                        style: AppTextStyles.subheadline,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We\'ll notify you when there\'s something new',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ]
          : dummyNotifications.map((notification) {
              final isUnread = notification['isUnread'] as bool;
              final type = notification['type'] as String;
              
              return Container(
                decoration: BoxDecoration(
                  color: isUnread ? AppColors.primaryLight.withValues(alpha: 0.1) : null,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.textSecondary.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                  ),
                ),
                child: PlatformListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: type == 'match' 
                          ? AppColors.primary
                          : type == 'message'
                              ? Colors.blue
                              : Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      type == 'match' 
                          ? AppAssets.icons.match.white
                          : type == 'message'
                              ? AppAssets.icons.notification.white
                              : AppAssets.icons.handshake.white,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title']!,
                          style: AppTextStyles.callout.copyWith(
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text(
                    notification['subtitle']!,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: Text(
                    notification['time']!,
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  onTap: () {
                    debugPrint('Tapped on notification: ${notification['title']}');
                    // TODO: Navigate to notification detail or mark as read
                  },
                ),
              );
            }).toList(),
    );
  }
}