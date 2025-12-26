import 'package:flutter/material.dart';
import '../../models/prompt.dart';
import '../../models/enums/prompt_status.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/common/role_view.dart';
import '../../widgets/common/status_badge_view.dart';
import '../../widgets/common/tag_view.dart';
import '../../l10n/app_localizations.dart';

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
  final String? matchFirstName;
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
    this.matchFirstName,
    this.onPromptSelected,
  });

  @override
  State<PromptItem> createState() => _PromptItemState();
}

class _PromptItemState extends State<PromptItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    // Helper variables for status badges row
    final showStatusBadge = widget.prompt.fromAuthor == true && widget.prompt.displayStatus != PromptStatus.approved;
    final showPausedTag = widget.prompt.isPaused == true;

    // Calculate effective match count: show "other matches" (count - 1) when in match detail view
    final rawMatchCount = widget.prompt.matchCount ?? 0;
    final effectiveMatchCount = widget.showMatchInteraction ? rawMatchCount - 1 : rawMatchCount;
    final showMatchCountTag = widget.showCounters && effectiveMatchCount > 0;
    final hasAnyBadge = showStatusBadge || showPausedTag || showMatchCountTag;

    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPromptSelected != null ? () {
            // Only toggle selection if not showing match interactions
            if (!widget.showMatchInteraction) {
              setState(() {
                isSelected = !isSelected;
              });
            }
            widget.onPromptSelected?.call(widget.prompt);
          } : null,
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

                    // Combined selection title + prompt label with chevron
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.prompt.buildTitle(context, matchFirstName: widget.matchFirstName),
                            style: AppTextStyles.body.copyWith(
                              color: context.venyuTheme.primaryText,
                              fontSize: 15
                            ),
                            maxLines: widget.limitPromptLines ? 4 : null,
                            overflow: widget.limitPromptLines ? TextOverflow.ellipsis : null,
                          ),
                        ),
                      ],
                    ),

                    // Match count tag, status badge, and paused tag - below prompt label
                    if (widget.shouldShowStatus && hasAnyBadge) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Match count tag first (only if matches > 0)
                          if (showMatchCountTag)
                            TagView(
                              id: 'matches_${widget.prompt.promptID}',
                              label: widget.showMatchInteraction
                                  ? AppLocalizations.of(context)!.promptItemOtherMatchCount(effectiveMatchCount)
                                  : AppLocalizations.of(context)!.promptItemMatchCount(effectiveMatchCount),
                              icon: 'match',
                              isLocal: true,
                              isSelected: widget.prompt.hasNewMatches == true,
                              fontWeight: widget.prompt.hasNewMatches == true ? FontWeight.w600 : null,
                            ),
                          // Status badge only for own prompts
                          if (showStatusBadge) ...[
                            if (showMatchCountTag) const SizedBox(width: 4),
                            StatusBadgeView(
                              status: widget.prompt.displayStatus,
                              compact: false,
                            ),
                          ],
                          // Paused tag for all prompts
                          if (showPausedTag) ...[
                            if (showMatchCountTag || showStatusBadge) const SizedBox(width: 4),
                            TagView(
                              id: 'paused_${widget.prompt.promptID}',
                              label: AppLocalizations.of(context)!.promptItemPausedTag,
                              icon: 'pause',
                            ),
                          ],
                        ],
                      ),
                    ],

                          // Checkbox for reviewing mode
                          
                        ],
                      ),
                    ),

                    if (widget.reviewing) ...[
                      SizedBox(height: AppModifiers.mediumSpacing),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildCheckbox(),
                      ),
                    ],
                    
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
    final isPaused = widget.prompt.isPaused == true;
    final gradientAlpha = isPaused ? 0.1 : 0.25;

    // If showing match interactions, use match interaction color on left, adaptive background on right
    if (widget.showMatchInteraction) {
      final gradientColor = widget.prompt.matchInteractionType?.color;

      if (gradientColor != null) {
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradientColor.withValues(alpha: gradientAlpha),
              venyuTheme.adaptiveBackground.withValues(alpha: gradientAlpha),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        );
      }
      // If missing color, no gradient
      return null;
    }

    // Regular logic for non-match views
    // If prompt is approved, show interaction type color gradient
    final gradientColor = widget.prompt.interactionType?.color ?? venyuTheme.gradientPrimary;

    return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColor.withValues(alpha: gradientAlpha),
            venyuTheme.adaptiveBackground.withValues(alpha: gradientAlpha),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      );
  }


  /// Simple card border radius - equivalent to Swift applyCardShape
  BorderRadius _getCardBorderRadius() {
    // If not shared prompt view, all corners rounded
    if (!widget.isSharedPromptView) {
      return BorderRadius.circular(AppModifiers.defaultRadius);
    }

    // For shared prompt view, round corners based on position
    final roundTop = widget.isFirst;
    final roundBottom = widget.isLast;

    if (roundTop && roundBottom) {
      // Only item - all corners rounded
      return BorderRadius.circular(AppModifiers.defaultRadius);
    } else if (roundTop) {
      // First item - top corners rounded
      return const BorderRadius.only(
        topLeft: Radius.circular(AppModifiers.defaultRadius),
        topRight: Radius.circular(AppModifiers.defaultRadius),
      );
    } else if (roundBottom) {
      // Last item - bottom corners rounded
      return const BorderRadius.only(
        bottomLeft: Radius.circular(AppModifiers.defaultRadius),
        bottomRight: Radius.circular(AppModifiers.defaultRadius),
      );
    } else {
      // Middle item - no corners rounded
      return BorderRadius.zero;
    }
  }
}