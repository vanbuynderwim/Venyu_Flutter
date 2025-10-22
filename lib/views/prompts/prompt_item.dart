import 'package:flutter/material.dart';
import '../../models/prompt.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/date_extensions.dart';
import '../../widgets/common/role_view.dart';
import '../../widgets/common/interaction_tag.dart';
import '../../widgets/common/venue_tag.dart';
import '../../widgets/common/prompt_counters.dart';

/// PromptItem - Flutter equivalent van Swift CardItemView
class PromptItem extends StatefulWidget {
  final Prompt prompt;
  final bool reviewing;
  final bool isLast;
  final bool isFirst;
  final bool isSharedPromptView;
  final bool showMatchInteraction;
  final bool showChevron;
  final bool shouldShowStatus;
  final bool showCounters;
  final bool limitPromptLines;
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
    this.shouldShowStatus = true,
    this.showCounters = false,
    this.limitPromptLines = false,
    this.onPromptSelected,
  });

  @override
  State<PromptItem> createState() => _PromptItemState();
}

class _PromptItemState extends State<PromptItem> {
  bool isSelected = false;

  /// Builds the date text with status emoji (no venue info)
  String _buildDateText() {
    final dateText = widget.prompt.createdAt?.timeAgo() ?? '';
    final statusEmoji = widget.shouldShowStatus && !widget.showMatchInteraction
        ? '${widget.prompt.displayStatus.emoji} '
        : '';

    if (dateText.isEmpty) {
      return statusEmoji.isEmpty ? '' : statusEmoji.trim();
    }

    return '$statusEmoji$dateText';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
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
          highlightColor: context.venyuTheme.primary.withValues(alpha: 0.1),
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
                    if (widget.prompt.createdAt != null ||
                        (widget.shouldShowStatus && !widget.showMatchInteraction)) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Date with status emoji (no venue)
                          Text(
                            _buildDateText(),
                            style: AppTextStyles.subheadline2.copyWith(
                              color: context.venyuTheme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    
                    // Prompt label - takes full width
                    Text(
                      widget.prompt.label,
                      style: AppTextStyles.body.copyWith(
                        color: context.venyuTheme.darkText,
                        fontSize: 18,
                        fontFamily: AppFonts.graphie,
                      ),
                      maxLines: widget.limitPromptLines ? 4 : null,
                      overflow: widget.limitPromptLines ? TextOverflow.ellipsis : null,
                    ),
                    
                    // Interaction tags and counters row - below the label
                    if (widget.prompt.interactionType != null ||
                        widget.prompt.venue != null ||
                        (widget.showMatchInteraction && widget.prompt.matchInteractionType != null) ||
                        widget.showCounters) ...[
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side: interaction tag and venue tag
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.prompt.interactionType != null) ...[
                                InteractionTag(
                                  interactionType: widget.prompt.interactionType!,
                                  compact: true,
                                ),
                                if (widget.prompt.venue != null) const SizedBox(width: 8),
                              ],
                              if (widget.prompt.venue != null)
                                VenueTag(
                                  venue: widget.prompt.venue!,
                                  compact: true,
                                ),
                            ],
                          ),

                          // Spacer to push right content to the end
                          const Spacer(),

                          // Right side: match interaction tag and/or counters
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Match interaction tag (for match views)
                              if (widget.showMatchInteraction && widget.prompt.matchInteractionType != null) ...[
                                InteractionTag(
                                  interactionType: widget.prompt.matchInteractionType!,
                                  compact: true,
                                ),
                                if (widget.showCounters) const SizedBox(width: 12),
                              ],

                              // Counters
                              if (widget.showCounters)
                                PromptCounters(
                                  matchCount: widget.prompt.matchCount,
                                  connectionCount: widget.prompt.connectionCount,
                                ),
                            ],
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
    // If prompt is approved, show primary color gradient
    return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            venyuTheme.gradientPrimary.withValues(alpha: 0.3),
            venyuTheme.adaptiveBackground.withValues(alpha: 0.3),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      );
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