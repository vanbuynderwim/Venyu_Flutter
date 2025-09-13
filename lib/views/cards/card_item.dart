import 'package:flutter/material.dart';
import '../../models/prompt.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/date_extensions.dart';
import '../../widgets/common/role_view.dart';
import '../../widgets/common/status_badge_view.dart';
import '../../widgets/common/interaction_tag.dart';
import '../../widgets/common/venue_tag.dart';

/// CardItem - Flutter equivalent van Swift CardItemView
class CardItem extends StatefulWidget {
  final Prompt prompt;
  final bool reviewing;
  final bool isLast;
  final bool isFirst;
  final bool isSharedPromptView;
  final bool showMatchInteraction;
  final bool showChevron;
  final Function(Prompt)? onCardSelected;

  const CardItem({
    super.key,
    required this.prompt,
    this.reviewing = false,
    this.isLast = false,
    this.isFirst = false,
    this.isSharedPromptView = false,
    this.showMatchInteraction = false,
    this.showChevron = false,
    this.onCardSelected,
  });

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
            onTap: widget.showMatchInteraction 
                ? null 
                : () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                    widget.onCardSelected?.call(widget.prompt);
                  },
            splashFactory: NoSplash.splashFactory,
            borderRadius: _getCardBorderRadius(),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: context.venyuTheme.cardBackground,
                borderRadius: _getCardBorderRadius(),
                border: Border.all(
                  color: context.venyuTheme.borderColor,
                  width: AppModifiers.extraThinBorder,
                ),
              ),
              child: Container(
                padding: AppModifiers.cardContentPadding,
                decoration: _buildGradientOverlay(),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile/Role view
                          if (widget.prompt.profile != null) ...[
                            RoleView(
                              profile: widget.prompt.profile!,
                              avatarSize: 40,
                              showChevron: false,
                              buttonDisabled: true,
                            ),
                            AppModifiers.verticalSpaceMedium,
                          ],
                    
                    // Created date and status badge row - above prompt label
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Date on the left
                        if (widget.prompt.createdAt != null) ...[
                          Text(
                            widget.prompt.createdAt!.timeAgoFull(),
                            style: AppTextStyles.caption1.copyWith(
                              color: context.venyuTheme.secondaryText,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        
                        // Status badge next to date - use displayStatus for online/offline logic
                        StatusBadgeView(
                          status: widget.prompt.displayStatus,
                          compact: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Prompt label - takes full width
                    Text(
                      widget.prompt.label,
                      style: AppTextStyles.callout.copyWith(
                        color: context.venyuTheme.primaryText,
                      ),
                      maxLines: null,
                    ),
                    
                    // Interaction and venue tags row - below the label
                    if (widget.prompt.interactionType != null || 
                        widget.prompt.venue != null ||
                        (widget.showMatchInteraction && widget.prompt.matchInteractionType != null)) ...[
                      SizedBox(height: AppModifiers.mediumSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side: interaction tag and venue tag
                          Expanded(
                            child: Row(
                              children: [
                                if (widget.prompt.interactionType != null) ...[
                                  InteractionTag(
                                    interactionType: widget.prompt.interactionType!,
                                    compact: true,
                                  ),
                                  if (widget.prompt.venue != null)
                                    const SizedBox(width: 8),
                                ],
                                if (widget.prompt.venue != null)
                                  VenueTag(
                                    venue: widget.prompt.venue!,
                                    compact: true,
                                  ),
                              ],
                            ),
                          ),
                          
                          // Right interaction tag (for match interactions)
                          if (widget.showMatchInteraction && widget.prompt.matchInteractionType != null)
                            InteractionTag(
                              interactionType: widget.prompt.matchInteractionType!,
                              compact: true,
                            ),
                        ],
                      ),
                    ],
                    
                          // Checkbox for reviewing mode
                          if (widget.reviewing) ...[
                            SizedBox(height: AppModifiers.mediumSpacing),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _buildCheckbox(),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Chevron on the right
                    if (widget.showChevron) ...[
                      const SizedBox(width: 12),
                      context.themedIcon('chevron', size: 18),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
  }


  /// Bouw de checkbox voor reviewing mode
  Widget _buildCheckbox() {
    return context.themedIcon('checkbox', selected: isSelected);
  }

  /// Build gradient overlay - only use interaction colors when prompt is online, otherwise lilac
  BoxDecoration? _buildGradientOverlay() {
    final venyuTheme = context.venyuTheme;
    
    // If prompt is online, use interaction colors
    if (widget.prompt.isOnline) {
      final leftColor = widget.prompt.interactionType?.color;
      final rightColor = widget.showMatchInteraction && widget.prompt.matchInteractionType != null
          ? widget.prompt.matchInteractionType!.color
          : null;
      
      // If no interaction colors, no overlay needed
      if (leftColor == null && rightColor == null) {
        return null;
      }
      
      // Show interaction color gradient
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (leftColor ?? venyuTheme.cardBackground).withValues(alpha: 0.3),
            (rightColor ?? venyuTheme.cardBackground).withValues(alpha: 0.3),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      );
    } else {
      // If prompt is offline, use lilac color
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primair4Lilac.withValues(alpha: 0.3),
            venyuTheme.cardBackground.withValues(alpha: 0.3),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      );
    }
  }


  /// Simple card border radius - equivalent to Swift applyCardShape
  BorderRadius _getCardBorderRadius() {
    final roundedBottom = widget.isLast && widget.isSharedPromptView;
    final roundedCard = !widget.isSharedPromptView;
    
    if (roundedBottom) {
      // Only bottom corners rounded
      return const BorderRadius.only(
        bottomLeft: Radius.circular(AppModifiers.defaultRadius),
        bottomRight: Radius.circular(AppModifiers.defaultRadius),
      );
    } else if (roundedCard) {
      // All corners rounded
      return BorderRadius.circular(AppModifiers.defaultRadius);
    } else {
      // No corners rounded
      return BorderRadius.zero;
    }
  }



}