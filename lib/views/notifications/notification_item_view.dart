import 'package:flutter/material.dart';

import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/date_extensions.dart';
import '../../models/notification.dart' as venyu;
import '../../widgets/common/role_view.dart';
import '../../widgets/common/sub_title.dart';
import '../../widgets/prompts/prompt_section_card.dart';

/// NotificationItemView - Flutter equivalent of Swift NotificationItemView
/// 
/// Displays a notification item with icon, title, body, timestamp, and optional
/// prompt or match content. Supports read/unread states with different icon colors.
/// 
/// Features:
/// - Dynamic icon coloring based on read state
/// - Gradient backgrounds for prompt and match sections
/// - Tactile feedback with pressed state
/// - Consistent card styling with the rest of the app
/// 
/// Example usage:
/// ```dart
/// NotificationItemView(
///   notification: myNotification,
///   onNotificationSelected: (notification) => handleNotificationTap(notification),
/// )
/// ```
class NotificationItemView extends StatefulWidget {
  /// The notification data to display
  final venyu.Notification notification;
  
  /// Callback when the notification is selected/tapped
  final Function(venyu.Notification)? onNotificationSelected;

  const NotificationItemView({
    super.key,
    required this.notification,
    this.onNotificationSelected,
  });

  @override
  State<NotificationItemView> createState() => _NotificationItemViewState();
}

class _NotificationItemViewState extends State<NotificationItemView> {
  @override
  Widget build(BuildContext context) {
    return AppLayoutStyles.interactiveCard(
      context: context,
      onTap: widget.onNotificationSelected != null 
          ? () => widget.onNotificationSelected!(widget.notification)
          : null,
      child: Padding(
        padding: AppModifiers.cardContentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + Title as SubTitle
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SubTitle(
                    title: widget.notification.title,
                    textColor: widget.notification.isUnread
                        ? context.venyuTheme.primary
                        : context.venyuTheme.primaryText,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.notification.createdAt.timeAgo(),
                  style: AppTextStyles.footnote.copyWith(
                    color: context.venyuTheme.secondaryText,
                  ),
                ),
              ],
            ),

            AppModifiers.verticalSpaceSmall,

            // Body text
            _buildBody(context),

            // Optional match section
            if (widget.notification.match != null) ...[
              AppModifiers.verticalSpaceSmall,
              _buildMatchSection(context),
            ],

            // Optional prompt section
            if (widget.notification.prompt != null) ...[
              AppModifiers.verticalSpaceSmall,
              PromptSectionCard(prompt: widget.notification.prompt!),
            ],
            
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Text(
      widget.notification.body,
      style: AppTextStyles.subheadline.copyWith(
        color: venyuTheme.secondaryText,
      ),
    );
  }

  Widget _buildMatchSection(BuildContext context) {
    final match = widget.notification.match!;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
      ),
      child: RoleView(
        profile: match.profile,
        avatarSize: 85,
        showChevron: true,
        buttonDisabled: true,
        matchingScore: match.score,
      ),
    );
  }
}