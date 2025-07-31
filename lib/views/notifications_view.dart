import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../widgets/common/empty_state_widget.dart';
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
              EmptyStateWidget(
                message: 'No new notifications',
                description: 'We\'ll notify you when there\'s something new',
                iconName: 'notification',
                height: MediaQuery.of(context).size.height * 0.6,
              ),
            ]
          : dummyNotifications.map((notification) {
              final isUnread = notification['isUnread'] as bool;
              final type = notification['type'] as String;
              
              return Container(
                decoration: BoxDecoration(
                  color: isUnread ? context.venyuTheme.primary.withValues(alpha: 0.1) : null,
                  border: Border(
                    bottom: BorderSide(
                      color: context.venyuTheme.secondaryText.withValues(alpha: 0.2),
                      width: AppModifiers.extraThinBorder,
                    ),
                  ),
                ),
                child: PlatformListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: type == 'match' 
                          ? context.venyuTheme.primary
                          : type == 'message'
                              ? context.venyuTheme.info
                              : context.venyuTheme.success,
                      shape: BoxShape.circle,
                    ),
                    child: context.themedIcon(
                      type == 'match' 
                          ? 'match'
                          : type == 'message'
                              ? 'notification'
                              : 'handshake',
                      selected: true, // Use selected version for badge icons
                      size: 20,
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
                            color: context.venyuTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text(
                    notification['subtitle']!,
                    style: AppTextStyles.body.secondary(context),
                  ),
                  trailing: Text(
                    notification['time']!,
                    style: AppTextStyles.caption1.secondary(context),
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