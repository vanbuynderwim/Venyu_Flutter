import 'package:flutter/material.dart';
import '../../models/prompt.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../profile/role_view.dart';
import '../../widgets/common/status_badge_view.dart';

/// CardItem - Flutter equivalent van Swift CardItemView
class CardItem extends StatefulWidget {
  final Prompt prompt;
  final bool reviewing;
  final bool isLast;
  final bool isFirst;
  final bool isSharedPromptView;
  final bool showMatchInteraction;
  final Function(Prompt)? onCardSelected;

  const CardItem({
    super.key,
    required this.prompt,
    this.reviewing = false,
    this.isLast = false,
    this.isFirst = false,
    this.isSharedPromptView = false,
    this.showMatchInteraction = false,
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
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Leading interaction type bar
                    if (widget.prompt.interactionType != null)
                      _buildInteractionBar(widget.prompt.interactionType!, isLeading: true),
                    
                    // Main content
                    Expanded(
                      child: Container(
                        padding: AppModifiers.cardContentPadding,
                        decoration: _buildGradientOverlay(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile/Role view
                            if (widget.prompt.profile != null)
                              RoleView(
                                profile: widget.prompt.profile!,
                                avatarSize: 40,
                                showChevron: false,
                                buttonDisabled: true,
                              ),
                            
                            if (widget.prompt.profile != null)
                              AppModifiers.verticalSpaceMedium,
                            
                            // Prompt label
                            Text(
                              widget.prompt.label,
                              style: AppTextStyles.callout.copyWith(
                                color: context.venyuTheme.primaryText,
                              ),
                              maxLines: null,
                            ),
                            
                            // Status badge
                            if (widget.prompt.status != null)
                              Padding(
                                padding: EdgeInsets.only(top: AppModifiers.mediumSpacing),
                                child: StatusBadgeView(
                                  status: widget.prompt.status!,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Trailing interaction type bar (for match interactions)
                    if (widget.showMatchInteraction && widget.prompt.matchInteractionType != null)
                      _buildInteractionBar(widget.prompt.matchInteractionType!, isLeading: false),
                    
                    // Checkbox for reviewing
                    if (widget.reviewing)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildCheckbox(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
  }

  /// Bouw de interaction type bar (verticale balk met icoon)
  Widget _buildInteractionBar(InteractionType interactionType, {required bool isLeading}) {
    return Container(
      width: 40,
      decoration: BoxDecoration(
        color: interactionType.color,
      ),
      child: Center(
        child: Image.asset(
          interactionType.assetPath,
          width: 24,
          height: 24,
          color: AppColors.white,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              interactionType.fallbackIcon,
              size: 24,
              color: AppColors.white,
            );
          },
        ),
      ),
    );
  }

  /// Bouw de checkbox voor reviewing mode
  Widget _buildCheckbox() {
    return context.themedIcon('checkbox', selected: isSelected);
  }

  /// Build gradient overlay - only show gradient if interaction colors exist
  BoxDecoration? _buildGradientOverlay() {
    final leftColor = widget.prompt.interactionType?.color;
    final rightColor = widget.showMatchInteraction && widget.prompt.matchInteractionType != null
        ? widget.prompt.matchInteractionType!.color
        : null;
    
    // If no interaction colors, no overlay needed (cardBackground is on main container)
    if (leftColor == null && rightColor == null) {
      return null;
    }
    
    // If interaction colors exist, show gradient overlay
    final venyuTheme = context.venyuTheme;
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          (leftColor ?? venyuTheme.cardBackground).withValues(alpha: 0.15),
          (rightColor ?? venyuTheme.cardBackground).withValues(alpha: 0.15),
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