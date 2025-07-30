import 'package:flutter/material.dart';
import '../../models/prompt.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import 'role_view.dart';
import 'status_badge_view.dart';

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
            borderRadius: _getBorderRadius(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: _getBorderRadius(),
                border: Border.all(
                  color: context.venyuTheme.borderColor,
                  width: 0.5,
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
                                color: context.venyuTheme.primaryText,
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
        );
  }

  /// Bouw de interaction type bar (verticale balk met icoon)
  Widget _buildInteractionBar(InteractionType interactionType, {required bool isLeading}) {
    return Container(
      width: 40,
      decoration: BoxDecoration(
        color: interactionType.color,
        borderRadius: _getInteractionBarBorderRadius(isLeading: isLeading),
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
    return context.themedIcon('checkbox', selected: isSelected);
  }

  /// Bouw de gradient achtergrond
  LinearGradient _buildGradient() {
    final venyuTheme = context.venyuTheme;
    final leftColor = widget.prompt.interactionType?.color ?? venyuTheme.cardBackground;
    final rightColor = widget.showMatchInteraction && widget.prompt.matchInteractionType != null
        ? widget.prompt.matchInteractionType!.color
        : venyuTheme.cardBackground;
    
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
    debugPrint('🔍 CardItem _getBorderRadius: isSharedPromptView=${widget.isSharedPromptView}, isFirst=${widget.isFirst}, isLast=${widget.isLast}');
    
    if (!widget.isSharedPromptView) {
      // Individual card - fully rounded
      debugPrint('  → Individual card: fully rounded');
      return BorderRadius.circular(AppModifiers.defaultRadius);
    } else if (widget.isFirst && widget.isLast) {
      // Single card in shared view - no top radius (connects to header), rounded bottom
      debugPrint('  → Single card in shared view: rounded bottom only');
      return const BorderRadius.only(
        bottomLeft: Radius.circular(AppModifiers.defaultRadius),
        bottomRight: Radius.circular(AppModifiers.defaultRadius),
      );
    } else if (widget.isFirst) {
      // First card in shared view - no rounded corners (connects to header)
      debugPrint('  → First card in shared view: no rounded corners');
      return BorderRadius.zero;
    } else if (widget.isLast) {
      // Last card in shared view - only rounded bottom
      debugPrint('  → Last card in shared view: rounded bottom only');
      return const BorderRadius.only(
        bottomLeft: Radius.circular(AppModifiers.defaultRadius),
        bottomRight: Radius.circular(AppModifiers.defaultRadius),
      );
    } else {
      // Middle cards in shared view - no rounded corners
      debugPrint('  → Middle card in shared view: no rounded corners');
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
    
    if (!widget.isSharedPromptView) {
      // Individual card - rounded corners where no interaction bars exist
      topLeft = widget.prompt.interactionType != null ? 0 : AppModifiers.defaultRadius;
      topRight = (widget.showMatchInteraction && widget.prompt.matchInteractionType != null) 
          ? 0 
          : AppModifiers.defaultRadius;
      bottomLeft = widget.prompt.interactionType != null ? 0 : AppModifiers.defaultRadius;
      bottomRight = (widget.showMatchInteraction && widget.prompt.matchInteractionType != null) 
          ? 0 
          : AppModifiers.defaultRadius;
    } else if (widget.isLast) {
      // Last card in shared view - only bottom radius where no interaction bars exist
      bottomLeft = widget.prompt.interactionType != null ? 0 : AppModifiers.defaultRadius;
      bottomRight = (widget.showMatchInteraction && widget.prompt.matchInteractionType != null) 
          ? 0 
          : AppModifiers.defaultRadius;
    }
    // First and middle cards in shared view have no rounded corners for content
    
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  /// Krijg de border radius voor interaction bars
  BorderRadius _getInteractionBarBorderRadius({required bool isLeading}) {
    debugPrint('🎨 InteractionBar borderRadius: isLeading=$isLeading, isSharedPromptView=${widget.isSharedPromptView}, isFirst=${widget.isFirst}, isLast=${widget.isLast}');
    
    if (!widget.isSharedPromptView) {
      // Individual card - standard rounded corners on appropriate sides
      return isLeading 
          ? const BorderRadius.only(
              topLeft: Radius.circular(AppModifiers.defaultRadius),
              bottomLeft: Radius.circular(AppModifiers.defaultRadius),
            )
          : const BorderRadius.only(
              topRight: Radius.circular(AppModifiers.defaultRadius),
              bottomRight: Radius.circular(AppModifiers.defaultRadius),
            );
    } else if (widget.isFirst && widget.isLast) {
      // Single card in shared view - no top radius, rounded bottom
      return isLeading 
          ? const BorderRadius.only(
              bottomLeft: Radius.circular(AppModifiers.defaultRadius),
            )
          : const BorderRadius.only(
              bottomRight: Radius.circular(AppModifiers.defaultRadius),
            );
    } else if (widget.isFirst) {
      // First card in shared view - no rounded corners
      return BorderRadius.zero;
    } else if (widget.isLast) {
      // Last card in shared view - only rounded bottom
      return isLeading 
          ? const BorderRadius.only(
              bottomLeft: Radius.circular(AppModifiers.defaultRadius),
            )
          : const BorderRadius.only(
              bottomRight: Radius.circular(AppModifiers.defaultRadius),
            );
    } else {
      // Middle cards in shared view - no rounded corners
      return BorderRadius.zero;
    }
  }

}