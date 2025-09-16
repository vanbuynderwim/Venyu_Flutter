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

/// PromptItem - Flutter equivalent van Swift CardItemView
class PromptItem extends StatefulWidget {
  final Prompt prompt;
  final bool reviewing;
  final bool isLast;
  final bool isFirst;
  final bool isSharedPromptView;
  final bool showMatchInteraction;
  final bool showChevron;
  final Function(Prompt)? onPromptSelected;

  const PromptItem({
    super.key,
    required this.prompt,
    this.reviewing = false,
    this.isLast = false,
    this.isFirst = false,
    this.isSharedPromptView = false,
    this.showMatchInteraction = false,
    this.showChevron = false,
    this.onPromptSelected,
  });

  @override
  State<PromptItem> createState() => _PromptItemState();
}

class _PromptItemState extends State<PromptItem> {
  bool isSelected = false;

  /// Builds the combined date and venue text
  String _buildDateVenueText() {
    final dateText = widget.prompt.createdAt?.timeAgoFull() ?? '';
    final venue = widget.prompt.venue;

    if (dateText.isEmpty && venue != null) {
      return 'in ${venue.name}';
    } else if (dateText.isEmpty) {
      return '';
    }

    if (venue != null) {
      return '$dateText - in ${venue.name}';
    } else {
      return dateText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
            onTap: () {
                    // Only toggle selection if not showing match interactions
                    if (!widget.showMatchInteraction) {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    }
                    widget.onPromptSelected?.call(widget.prompt);
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
                    
                    // Status badge and created date column - above prompt label
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Status badge on top - only show if not showing match interactions
                        if (!widget.showMatchInteraction) ...[
                          IntrinsicWidth(
                            child: StatusBadgeView(
                              status: widget.prompt.displayStatus,
                              compact: true,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Date and venue below status badge
                        if (widget.prompt.createdAt != null)
                          Text(
                            _buildDateVenueText(),
                            style: AppTextStyles.caption1.copyWith(
                              color: context.venyuTheme.secondaryText,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Prompt label - takes full width
                    Text(
                      widget.prompt.label,
                      style: AppTextStyles.subheadline.copyWith(
                        color: context.venyuTheme.primaryText,
                      ),
                      maxLines: null,
                    ),
                    
                    // Interaction and venue tags row - below the label
                    if (widget.prompt.interactionType != null || 
                        widget.prompt.venue != null ||
                        (widget.showMatchInteraction && widget.prompt.matchInteractionType != null)) ...[
                      SizedBox(height: AppModifiers.smallSpacing),
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
                                  
                                ],
                          
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

  /// Build gradient overlay - show interaction colors for matches, status-based colors otherwise
  BoxDecoration? _buildGradientOverlay() {
    final venyuTheme = context.venyuTheme;
    
    // If showing match interactions, always show the two interaction colors
    if (widget.showMatchInteraction) {
      final leftColor = widget.prompt.interactionType?.color;
      final rightColor = widget.prompt.matchInteractionType?.color;
      
      // If we have both colors, show gradient
      if (leftColor != null && rightColor != null) {
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              leftColor.withValues(alpha: 0.3),
              rightColor.withValues(alpha: 0.3),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        );
      }
      // If missing colors, no gradient
      return null;
    }
    
    // Regular logic for non-match views
    // If prompt is online (approved and not expired), show interaction colors
    if (widget.prompt.isOnline) {
      final leftColor = widget.prompt.interactionType?.color;
      
      // If no interaction color, no overlay needed
      if (leftColor == null) {
        return null;
      }
      
      // Show single interaction color gradient
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            leftColor.withValues(alpha: 0.3),
            venyuTheme.cardBackground.withValues(alpha: 0.3),
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