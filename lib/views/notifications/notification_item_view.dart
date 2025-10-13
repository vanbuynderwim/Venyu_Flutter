import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/date_extensions.dart';
import '../../models/notification.dart' as venyu;
import '../../widgets/common/role_view.dart';
import '../../widgets/common/sub_title.dart';

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
                    iconName: widget.notification.type.icon,
                    title: widget.notification.title,
                    textColor: widget.notification.isUnread
                        ? context.venyuTheme.primary
                        : context.venyuTheme.primaryText,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.notification.createdAt.timeAgo(),
                  style: AppTextStyles.footnote.copyWith(
                    color: context.venyuTheme.secondaryText,
                  ),
                ),
              ],
            ),

            AppModifiers.verticalSpaceMedium,

            // Body text
            _buildBody(context),

            // Optional prompt section
            if (widget.notification.prompt != null) ...[
              AppModifiers.verticalSpaceMedium,
              _buildPromptSection(context),
            ],

            // Optional match section
            if (widget.notification.match != null) ...[
              AppModifiers.verticalSpaceMedium,
              _buildMatchSection(context),
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

  Widget _buildPromptSection(BuildContext context) {
    final prompt = widget.notification.prompt!;
    final venyuTheme = context.venyuTheme;
    
    // Get interaction type color, default to primary if null
   
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            venyuTheme.gradientPrimary.withValues(alpha: 0.3),
            venyuTheme.adaptiveBackground.withValues(alpha: 0.3),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
      ),
      child: Text(
        prompt.label,
        style: AppTextStyles.subheadline.copyWith(
          color: context.venyuTheme.darkText,
          fontSize: 16,
          fontFamily: AppFonts.graphie, 
        ),
      ),
    );
  }

  Widget _buildMatchSection(BuildContext context) {
    final match = widget.notification.match!;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primair5Lavender.withValues(alpha: 0.2),
            AppColors.accent3Peach.withValues(alpha: 0.2),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
      ),
      child: RoleView(
        profile: match.profile,
        avatarSize: 40,
        showChevron: false,
        shouldBlur: !match.isConnected,
        buttonDisabled: true,
      ),
    );
  }
}