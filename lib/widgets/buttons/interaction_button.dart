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
  final String? customTitle;

  const InteractionButton({
    super.key,
    required this.interactionType,
    required this.isSelected,
    this.onPressed,
    this.width,
    this.height,
    this.isUpdating = false,
    this.customTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.venyuTheme;
    final bool isDisabled = onPressed == null;

    // Use gray color when disabled, otherwise use interaction type color
    final Color buttonColor = isDisabled
        ? theme.disabledText
        : interactionType.color;
    final Color backgroundColor = isSelected
        ? (isDisabled ? theme.disabledText : interactionType.color)
        : Colors.transparent;

    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0,
      child: SizedBox(
        width: width,
        height: height ?? 56,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppModifiers.capsuleRadius),
          child: InkWell(
            onTap: isUpdating ? null : () {
              if (!isSelected) {
                HapticFeedback.mediumImpact();
              }
              onPressed?.call();
            },
            borderRadius: BorderRadius.circular(AppModifiers.capsuleRadius),
            highlightColor: buttonColor.withValues(alpha: 0.2),
            splashColor: buttonColor.withValues(alpha: 0.3),
            child: SizedBox(
              height: height ?? 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  
                  // Title
                  Flexible(
                    child: Text(
                      customTitle ?? interactionType.buttonTitle(context),
                      style: AppTextStyles.headline2.copyWith(
                        color: isSelected ? Colors.white : buttonColor,
                        fontWeight: FontWeight.w700,
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
  final InteractionType? enabledInteractionType; // Only this button will be enabled in tutorial mode
  final InteractionType? promptInteractionType; // The prompt's interaction type for matching button titles

  const InteractionButtonRow({
    super.key,
    this.onInteractionPressed,
    this.selectedInteractionType,
    this.spacing = 8.0,
    this.buttonHeight,
    this.isUpdating = false,
    this.enabledInteractionType,
    this.promptInteractionType,
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

  bool _isButtonEnabled(InteractionType type) {
    // If no specific button is enabled (normal mode), all buttons are enabled
    if (widget.enabledInteractionType == null) return true;
    // In tutorial mode, only the specified button is enabled
    return widget.enabledInteractionType == type;
  }

  /// Get the appropriate button title based on whether it matches the prompt's interaction type
  String? _getButtonTitle(BuildContext context, InteractionType buttonType) {
    // If no prompt interaction type is provided, use default title
    if (widget.promptInteractionType == null) return null;

    // If button type matches prompt type, use the "too" variant
    if (buttonType == widget.promptInteractionType) {
      return buttonType.buttonTitleWhenMatchingPrompt(context);
    }

    // Otherwise use default title
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row - "I can help" and "Not relevant"
        Row(
          children: [
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.thisIsMe,
                isSelected: _selectedType == InteractionType.thisIsMe,
                onPressed: _isButtonEnabled(InteractionType.thisIsMe)
                    ? () => _handleSelection(InteractionType.thisIsMe)
                    : null,
                height: widget.buttonHeight ?? 40,
                isUpdating: widget.isUpdating || !_isButtonEnabled(InteractionType.thisIsMe),
                customTitle: _getButtonTitle(context, InteractionType.thisIsMe),
              ),
            ),
            SizedBox(width: widget.spacing),
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.lookingForThis,
                isSelected: _selectedType == InteractionType.lookingForThis,
                onPressed: _isButtonEnabled(InteractionType.lookingForThis)
                    ? () => _handleSelection(InteractionType.lookingForThis)
                    : null,
                height: widget.buttonHeight ?? 40,
                isUpdating: widget.isUpdating || !_isButtonEnabled(InteractionType.lookingForThis),
                customTitle: _getButtonTitle(context, InteractionType.lookingForThis),
              ),
            ),
          ],
        ),
        SizedBox(height: widget.spacing),
        // Second row - "I need this" and "I can refer"
        Row(
          children: [
            
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.knowSomeone,
                isSelected: _selectedType == InteractionType.knowSomeone,
                onPressed: _isButtonEnabled(InteractionType.knowSomeone)
                    ? () => _handleSelection(InteractionType.knowSomeone)
                    : null,
                height: widget.buttonHeight ?? 40,
                isUpdating: widget.isUpdating || !_isButtonEnabled(InteractionType.knowSomeone),
                customTitle: _getButtonTitle(context, InteractionType.knowSomeone),
              ),
            ),

            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.notRelevant,
                isSelected: _selectedType == InteractionType.notRelevant,
                onPressed: _isButtonEnabled(InteractionType.notRelevant)
                    ? () => _handleSelection(InteractionType.notRelevant)
                    : null,
                height: widget.buttonHeight ?? 40,
                isUpdating: widget.isUpdating || !_isButtonEnabled(InteractionType.notRelevant),
                customTitle: _getButtonTitle(context, InteractionType.notRelevant),
              ),
            ),
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