import 'package:flutter/material.dart';
import '../models/enums/interaction_type.dart';
import '../core/constants/app_assets.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// InteractionButton - Flutter equivalent van Swift InteractionButton
class InteractionButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 56, // Verhoogd naar 56px zoals in Swift app
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Meer verticale padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildButtonContent(),
        ),
      ),
    );
  }

  /// Bouw de button content gebaseerd op iconPosition
  List<Widget> _buildButtonContent() {
    final icon = Image.asset(
      _getButtonImagePath(),
      width: 20,
      height: 20,
      errorBuilder: (context, error, stackTrace) {
        // Fallback naar Material Icons als asset niet gevonden
        return Icon(
          _getFallbackIcon(),
          size: 20,
          color: Colors.white,
        );
      },
    );
    
    final text = Text(
      _getButtonTitle(),
      style: AppTextStyles.headline.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    
    return [
        icon,
        const SizedBox(width: 8),
        text,
      ];
  }

  /// Krijg de achtergrondkleur voor het InteractionType
  Color _getBackgroundColor() {
    switch (interactionType) {
      case InteractionType.thisIsMe:
        return AppColors.me; // Groen
      case InteractionType.lookingForThis:
        return AppColors.need; // Blauw-groen
      case InteractionType.knowSomeone:
        return AppColors.know; // Oranje
      case InteractionType.notRelevant:
        return AppColors.na; // Rood
    }
  }

  /// Krijg het image path voor het InteractionType
  String _getButtonImagePath() {
    switch (interactionType) {
      case InteractionType.thisIsMe:
        return AppAssets.icons.labelMe.path; // label_me
      case InteractionType.lookingForThis:
        return AppAssets.icons.labelSearch.path; // label_search
      case InteractionType.knowSomeone:
        return AppAssets.icons.labelAt.path; // label_at
      case InteractionType.notRelevant:
        return AppAssets.icons.labelSkip.path; // label_skip
    }
  }

  /// Krijg fallback Material icon
  IconData _getFallbackIcon() {
    switch (interactionType) {
      case InteractionType.thisIsMe:
        return Icons.person;
      case InteractionType.lookingForThis:
        return Icons.lightbulb;
      case InteractionType.knowSomeone:
        return Icons.handshake;
      case InteractionType.notRelevant:
        return Icons.block;
    }
  }

  /// Krijg de button title voor het InteractionType
  String _getButtonTitle() {
    switch (interactionType) {
      case InteractionType.thisIsMe:
        return 'I can help';
      case InteractionType.lookingForThis:
        return 'I need this';
      case InteractionType.knowSomeone:
        return 'I can refer';
      case InteractionType.notRelevant:
        return 'Not relevant';
    }
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