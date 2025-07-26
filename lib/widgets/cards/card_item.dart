import 'package:flutter/material.dart';
import '../../models/prompt.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/constants/app_assets.dart';
import 'role_view.dart';
import 'status_badge_view.dart';

/// CardItem - Flutter equivalent van Swift CardItemView
class CardItem extends StatefulWidget {
  final Prompt prompt;
  final bool reviewing;
  final bool isLast;
  final bool isSharedPromptView;
  final bool showMatchInteraction;
  final Function(Prompt)? onCardSelected;

  const CardItem({
    super.key,
    required this.prompt,
    this.reviewing = false,
    this.isLast = false,
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
    return Column(
      children: [
        Material(
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
            borderRadius: _getBorderRadius(),
            child: Container(
              decoration: AppLayoutStyles.defaultBorder(context).copyWith(
                borderRadius: _getBorderRadius(),
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
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: _buildGradient(),
                          borderRadius: _getContentBorderRadius(),
                        ),
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
                              const SizedBox(height: 16),
                            
                            // Prompt label
                            Text(
                              widget.prompt.label,
                              style: AppTextStyles.callout.copyWith(
                                color: AppColors.secundair1Deepblack,
                              ),
                              maxLines: null,
                            ),
                            
                            // Status badge
                            if (widget.prompt.status != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
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
        ),
      ],
    );
  }

  /// Bouw de interaction type bar (verticale balk met icoon)
  Widget _buildInteractionBar(InteractionType interactionType, {required bool isLeading}) {
    return Container(
      width: 40,
      decoration: BoxDecoration(
        color: interactionType.color,
        borderRadius: isLeading 
            ? const BorderRadius.only(
                topLeft: Radius.circular(AppModifiers.defaultRadius),
                bottomLeft: Radius.circular(AppModifiers.defaultRadius),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(AppModifiers.defaultRadius),
                bottomRight: Radius.circular(AppModifiers.defaultRadius),
              ),
      ),
      child: Center(
        child: Image.asset(
          interactionType.assetPath,
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              interactionType.fallbackIcon,
              size: 24,
              color: Colors.white,
            );
          },
        ),
      ),
    );
  }

  /// Bouw de checkbox voor reviewing mode
  Widget _buildCheckbox() {
    return Image.asset(
      isSelected 
          ? AppAssets.icons.checkboxOn.selected
          : AppAssets.icons.checkboxOff.regular,
      width: 24,
      height: 24,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          size: 24,
          color: isSelected ? AppColors.primary : AppColors.textLight,
        );
      },
    );
  }

  /// Bouw de gradient achtergrond
  LinearGradient _buildGradient() {
    final leftColor = widget.prompt.interactionType?.color ?? AppColors.white;
    final rightColor = widget.showMatchInteraction && widget.prompt.matchInteractionType != null
        ? widget.prompt.matchInteractionType!.color
        : AppColors.white;
    
    return LinearGradient(
      colors: [
        leftColor.withValues(alpha: 0.15),
        rightColor.withValues(alpha: 0.15),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  /// Krijg de border radius voor de container
  BorderRadius _getBorderRadius() {
    if (widget.isLast && widget.isSharedPromptView) {
      return const BorderRadius.only(
        bottomLeft: Radius.circular(AppModifiers.defaultRadius),
        bottomRight: Radius.circular(AppModifiers.defaultRadius),
      );
    } else if (!widget.isSharedPromptView) {
      return BorderRadius.circular(AppModifiers.defaultRadius);
    } else {
      return BorderRadius.zero;
    }
  }

  /// Krijg de border radius voor de content container
  BorderRadius _getContentBorderRadius() {
    // Content heeft geen border radius aan de zijkanten waar interaction bars zitten
    double topLeft = 0;
    double topRight = 0;
    double bottomLeft = 0;
    double bottomRight = 0;
    
    if (widget.isLast && widget.isSharedPromptView) {
      bottomLeft = widget.prompt.interactionType != null ? 0 : AppModifiers.defaultRadius;
      bottomRight = (widget.showMatchInteraction && widget.prompt.matchInteractionType != null) 
          ? 0 
          : AppModifiers.defaultRadius;
    } else if (!widget.isSharedPromptView) {
      topLeft = widget.prompt.interactionType != null ? 0 : AppModifiers.defaultRadius;
      topRight = (widget.showMatchInteraction && widget.prompt.matchInteractionType != null) 
          ? 0 
          : AppModifiers.defaultRadius;
      bottomLeft = widget.prompt.interactionType != null ? 0 : AppModifiers.defaultRadius;
      bottomRight = (widget.showMatchInteraction && widget.prompt.matchInteractionType != null) 
          ? 0 
          : AppModifiers.defaultRadius;
    }
    
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

}