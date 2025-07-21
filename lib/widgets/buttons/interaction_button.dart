import 'package:flutter/material.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';

/// InteractionButton - Flutter equivalent van Swift InteractionButton
class InteractionButton extends StatefulWidget {
  final InteractionType interactionType;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const InteractionButton({
    super.key,
    required this.interactionType,
    this.onPressed,
    this.width,
    this.height,
  });

  @override
  State<InteractionButton> createState() => _InteractionButtonState();
}

class _InteractionButtonState extends State<InteractionButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height ?? 56, // Verhoogd naar 56px zoals in Swift app
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          onTapDown: widget.onPressed != null ? (_) => setState(() => isPressed = true) : null,
          onTapUp: widget.onPressed != null ? (_) => setState(() => isPressed = false) : null,
          onTapCancel: widget.onPressed != null ? () => setState(() => isPressed = false) : null,
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
          child: Opacity(
            opacity: isPressed ? 0.8 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: widget.interactionType.color,
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildButtonContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Bouw de button content gebaseerd op iconPosition
  List<Widget> _buildButtonContent() {
    final icon = Image.asset(
      widget.interactionType.assetPath,
      width: 20,
      height: 20,
      errorBuilder: (context, error, stackTrace) {
        // Fallback naar Material Icons als asset niet gevonden
        return Icon(
          widget.interactionType.fallbackIcon,
          size: 20,
          color: Colors.white,
        );
      },
    );
    
    final text = Text(
      widget.interactionType.buttonTitle,
      style: AppTextStyles.headline.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    
    // Icon position bepaalt de volgorde (voor nu altijd icon-first)
    return [
        icon,
        const SizedBox(width: 8),
        text,
      ];
  }

}

/// InteractionButtonRow - Widget voor het weergeven van alle 4 de interaction buttons
class InteractionButtonRow extends StatelessWidget {
  final Function(InteractionType)? onInteractionPressed;
  final double spacing;
  final double? buttonHeight;

  const InteractionButtonRow({
    super.key,
    this.onInteractionPressed,
    this.spacing = 8.0,
    this.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Eerste rij - "I can help" en "I need this"
        Row(
          children: [
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.thisIsMe,
                onPressed: () => onInteractionPressed?.call(InteractionType.thisIsMe),
                height: buttonHeight ?? 56,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.lookingForThis,
                onPressed: () => onInteractionPressed?.call(InteractionType.lookingForThis),
                height: buttonHeight ?? 56,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        // Tweede rij - "I can refer" en "Not relevant"
        Row(
          children: [
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.knowSomeone,
                onPressed: () => onInteractionPressed?.call(InteractionType.knowSomeone),
                height: buttonHeight ?? 56,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: InteractionButton(
                interactionType: InteractionType.notRelevant,
                onPressed: () => onInteractionPressed?.call(InteractionType.notRelevant),
                height: buttonHeight ?? 56,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// InteractionButtonColumn - Widget voor het weergeven van alle 4 de interaction buttons in een kolom
class InteractionButtonColumn extends StatelessWidget {
  final Function(InteractionType)? onInteractionPressed;
  final double spacing;
  final double? buttonHeight;

  const InteractionButtonColumn({
    super.key,
    this.onInteractionPressed,
    this.spacing = 8.0,
    this.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InteractionButton(
          interactionType: InteractionType.thisIsMe,
          onPressed: () => onInteractionPressed?.call(InteractionType.thisIsMe),
          height: buttonHeight,
          width: double.infinity,
        ),
        SizedBox(height: spacing),
        InteractionButton(
          interactionType: InteractionType.lookingForThis,
          onPressed: () => onInteractionPressed?.call(InteractionType.lookingForThis),
          height: buttonHeight,
          width: double.infinity,
        ),
        SizedBox(height: spacing),
        InteractionButton(
          interactionType: InteractionType.knowSomeone,
          onPressed: () => onInteractionPressed?.call(InteractionType.knowSomeone),
          height: buttonHeight,
          width: double.infinity,
        ),
        SizedBox(height: spacing),
        InteractionButton(
          interactionType: InteractionType.notRelevant,
          onPressed: () => onInteractionPressed?.call(InteractionType.notRelevant),
          height: buttonHeight,
          width: double.infinity,
        ),
      ],
    );
  }
}