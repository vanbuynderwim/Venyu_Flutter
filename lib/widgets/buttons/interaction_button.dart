import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

/// InteractionButton - New toggle button implementation with Material Design interactions
class InteractionButton extends StatelessWidget {
  final InteractionType interactionType;
  final bool isSelected;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool isUpdating;

  const InteractionButton({
    super.key,
    required this.interactionType,
    required this.isSelected,
    this.onPressed,
    this.width,
    this.height,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.venyuTheme;
    
    return SizedBox(
      width: width,
      height: height ?? 56,
      child: Material(
        color: isSelected ? interactionType.color : Colors.transparent,
        borderRadius: BorderRadius.circular(AppModifiers.capsuleRadius),
        child: InkWell(
          onTap: isUpdating ? null : () {
            if (!isSelected) {
              HapticFeedback.mediumImpact();
            }
            onPressed?.call();
          },
          borderRadius: BorderRadius.circular(AppModifiers.capsuleRadius),
          highlightColor: interactionType.color.withValues(alpha: 0.2),
          splashColor: interactionType.color.withValues(alpha: 0.3),
          child: SizedBox(
            height: height ?? 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Image.asset(
                  interactionType.assetPath,
                  width: 28,
                  height: 28,
                  color: isSelected ? Colors.white : interactionType.color,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      interactionType.fallbackIcon,
                      size: 28,
                      color: isSelected ? Colors.white : theme.unselectedText,
                    );
                  },
                ),

                const SizedBox(width: 8),

                // Title
                Flexible(
                  child: Text(
                    interactionType.buttonTitle,
                    style: AppTextStyles.headline.copyWith(
                      color: isSelected ? Colors.white : interactionType.color,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// InteractionButtonRow - Widget for displaying all 4 interaction buttons with selection state
class InteractionButtonRow extends StatefulWidget {
  final Function(InteractionType)? onInteractionPressed;
  final InteractionType? selectedInteractionType;
  final double spacing;
  final double? buttonHeight;
  final bool isUpdating;

  const InteractionButtonRow({
    super.key,
    this.onInteractionPressed,
    this.selectedInteractionType,
    this.spacing = 8.0,
    this.buttonHeight,
    this.isUpdating = false,
  });

  @override
  State<InteractionButtonRow> createState() => _InteractionButtonRowState();
}

class _InteractionButtonRowState extends State<InteractionButtonRow> {
  InteractionType? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedInteractionType;
  }

  @override
  void didUpdateWidget(InteractionButtonRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedInteractionType != oldWidget.selectedInteractionType) {
      _selectedType = widget.selectedInteractionType;
    }
  }

  void _handleSelection(InteractionType type) {
    setState(() {
      _selectedType = type;
    });
    widget.onInteractionPressed?.call(type);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row - "I can help" and "I need this"
        Row(
          children: [
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.thisIsMe,
                isSelected: _selectedType == InteractionType.thisIsMe,
                onPressed: () => _handleSelection(InteractionType.thisIsMe),
                height: widget.buttonHeight ?? 48,
                isUpdating: widget.isUpdating,
              ),
            ),
            SizedBox(width: widget.spacing),
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.notRelevant,
                isSelected: _selectedType == InteractionType.notRelevant,
                onPressed: () => _handleSelection(InteractionType.notRelevant),
                height: widget.buttonHeight ?? 48,
                isUpdating: widget.isUpdating,
              ),
            ),
          ],
        ),
        SizedBox(height: widget.spacing),
        // Second row - "I can refer" and "Not relevant"
        Row(
          children: [
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.lookingForThis,
                isSelected: _selectedType == InteractionType.lookingForThis,
                onPressed: () => _handleSelection(InteractionType.lookingForThis),
                height: widget.buttonHeight ?? 48,
                isUpdating: widget.isUpdating,
              ),
            ),
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.knowSomeone,
                isSelected: _selectedType == InteractionType.knowSomeone,
                onPressed: () => _handleSelection(InteractionType.knowSomeone),
                height: widget.buttonHeight ?? 48,
                isUpdating: widget.isUpdating,
              ),
            ),
            SizedBox(width: widget.spacing),            
          ],
        ),
      ],
    );
  }
}

/// CardDetailToggleButtons - Component with 2 buttons specifically for card detail view
class CardDetailToggleButtons extends StatefulWidget {
  final Function(InteractionType)? onInteractionChanged;
  final InteractionType selectedInteractionType;
  final double spacing;
  final double? buttonHeight;
  final bool isUpdating;

  const CardDetailToggleButtons({
    super.key,
    this.onInteractionChanged,
    this.selectedInteractionType = InteractionType.lookingForThis, // Default to "Searching for"
    this.spacing = 8.0,
    this.buttonHeight,
    this.isUpdating = false,
  });

  @override
  State<CardDetailToggleButtons> createState() => _CardDetailToggleButtonsState();
}

class _CardDetailToggleButtonsState extends State<CardDetailToggleButtons> {
  late InteractionType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedInteractionType;
  }

  @override
  void didUpdateWidget(CardDetailToggleButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedInteractionType != oldWidget.selectedInteractionType) {
      _selectedType = widget.selectedInteractionType;
    }
  }

  void _handleSelection(InteractionType type) {
    setState(() {
      _selectedType = type;
    });
    widget.onInteractionChanged?.call(type);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // "Searching for" button (shown first as requested)
        Expanded(
          child: InteractionButton(
            interactionType: InteractionType.lookingForThis,
            isSelected: _selectedType == InteractionType.lookingForThis,
            onPressed: () => _handleSelection(InteractionType.lookingForThis),
            height: widget.buttonHeight ?? 56,
            isUpdating: widget.isUpdating,
          ),
        ),
        
        SizedBox(width: widget.spacing),
        
        // "I can help with" button
        Expanded(
          child: InteractionButton(
            interactionType: InteractionType.thisIsMe,
            isSelected: _selectedType == InteractionType.thisIsMe,
            onPressed: () => _handleSelection(InteractionType.thisIsMe),
            height: widget.buttonHeight ?? 56,
            isUpdating: widget.isUpdating,
          ),
        ),
      ],
    );
  }
}