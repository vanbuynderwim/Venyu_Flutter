import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_modifiers.dart';

/// Venyu Layout Styles - Consistent layout components and text layouts
class AppLayoutStyles {
  AppLayoutStyles._();

  /// Container styles
  static BoxDecoration get container => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
  );

  static BoxDecoration get containerWithBorder => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
    border: Border.all(
      color: AppColors.secondaryLight,
      width: AppModifiers.thinBorder,
    ),
  );

  static BoxDecoration get containerElevated => AppModifiers.cardMedium;

  /// Section styles
  static BoxDecoration get section => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
  );

  static BoxDecoration get sectionElevated => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.secundair6Rocket.withValues(alpha: 0.1),
        blurRadius: AppModifiers.smallElevation,
        offset: const Offset(0, 1),
      ),
    ],
  );

  /// Header styles
  static BoxDecoration get header => BoxDecoration(
    color: AppColors.background,
    border: Border(
      bottom: BorderSide(
        color: AppColors.secondaryLight,
        width: AppModifiers.thinBorder,
      ),
    ),
  );

  static BoxDecoration get headerElevated => BoxDecoration(
    color: AppColors.background,
    boxShadow: [
      BoxShadow(
        color: AppColors.secundair6Rocket.withValues(alpha: 0.1),
        blurRadius: AppModifiers.smallElevation,
        offset: const Offset(0, 1),
      ),
    ],
  );

  /// List item styles
  static BoxDecoration get listItem => BoxDecoration(
    color: AppColors.white,
    border: Border(
      bottom: BorderSide(
        color: AppColors.secundair7Cascadingwhite,
        width: AppModifiers.thinBorder,
      ),
    ),
  );

  static BoxDecoration get listItemElevated => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.secundair6Rocket.withValues(alpha: 0.05),
        blurRadius: AppModifiers.smallElevation,
        offset: const Offset(0, 1),
      ),
    ],
  );

  /// Dialog styles
  static BoxDecoration get dialog => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
    boxShadow: [
      BoxShadow(
        color: AppColors.secundair6Rocket.withValues(alpha: 0.3),
        blurRadius: AppModifiers.largeElevation,
        offset: const Offset(0, 4),
      ),
    ],
  );

  /// Bottom sheet styles
  static BoxDecoration get bottomSheet => BoxDecoration(
    color: AppColors.white,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(AppModifiers.largeRadius),
      topRight: Radius.circular(AppModifiers.largeRadius),
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.secundair6Rocket.withValues(alpha: 0.2),
        blurRadius: AppModifiers.mediumElevation,
        offset: const Offset(0, -2),
      ),
    ],
  );

  /// Snackbar styles
  static BoxDecoration get snackbar => BoxDecoration(
    color: AppColors.secundair2Offblack,
    borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
  );

  static BoxDecoration get snackbarSuccess => BoxDecoration(
    color: AppColors.success,
    borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
  );

  static BoxDecoration get snackbarError => BoxDecoration(
    color: AppColors.error,
    borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
  );

  static BoxDecoration get snackbarWarning => BoxDecoration(
    color: AppColors.warning,
    borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
  );

  /// Badge styles
  static BoxDecoration get badge => BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppModifiers.extraLargeRadius),
  );

  static BoxDecoration get badgeSuccess => BoxDecoration(
    color: AppColors.success,
    borderRadius: BorderRadius.circular(AppModifiers.extraLargeRadius),
  );

  static BoxDecoration get badgeError => BoxDecoration(
    color: AppColors.error,
    borderRadius: BorderRadius.circular(AppModifiers.extraLargeRadius),
  );

  static BoxDecoration get badgeWarning => BoxDecoration(
    color: AppColors.warning,
    borderRadius: BorderRadius.circular(AppModifiers.extraLargeRadius),
  );

  /// Divider styles
  static Widget get divider => Divider(
    height: 1,
    thickness: AppModifiers.thinBorder,
    color: AppColors.secundair7Cascadingwhite,
  );

  static Widget get dividerThick => Divider(
    height: AppModifiers.smallSpacing,
    thickness: AppModifiers.thinBorder,
    color: AppColors.secundair7Cascadingwhite,
  );

  /// Spacer widgets
  static Widget get spacerTiny => const SizedBox(height: AppModifiers.tinySpacing);
  static Widget get spacerSmall => const SizedBox(height: AppModifiers.smallSpacing);
  static Widget get spacerMedium => const SizedBox(height: AppModifiers.mediumSpacing);
  static Widget get spacerLarge => const SizedBox(height: AppModifiers.largeSpacing);
  static Widget get spacerExtraLarge => const SizedBox(height: AppModifiers.extraLargeSpacing);

  static Widget get spacerHorizontalTiny => const SizedBox(width: AppModifiers.tinySpacing);
  static Widget get spacerHorizontalSmall => const SizedBox(width: AppModifiers.smallSpacing);
  static Widget get spacerHorizontalMedium => const SizedBox(width: AppModifiers.mediumSpacing);
  static Widget get spacerHorizontalLarge => const SizedBox(width: AppModifiers.largeSpacing);
  static Widget get spacerHorizontalExtraLarge => const SizedBox(width: AppModifiers.extraLargeSpacing);
}

/// Text layout helpers
class AppTextLayouts {
  AppTextLayouts._();

  /// Text alignment helpers
  static Widget centeredText(String text, TextStyle style) => Center(
    child: Text(text, style: style, textAlign: TextAlign.center),
  );

  static Widget leftAlignedText(String text, TextStyle style) => Align(
    alignment: Alignment.centerLeft,
    child: Text(text, style: style, textAlign: TextAlign.left),
  );

  static Widget rightAlignedText(String text, TextStyle style) => Align(
    alignment: Alignment.centerRight,
    child: Text(text, style: style, textAlign: TextAlign.right),
  );

  /// Text with padding
  static Widget paddedText(String text, TextStyle style, {EdgeInsets? padding}) => Padding(
    padding: padding ?? AppModifiers.paddingMedium,
    child: Text(text, style: style),
  );

  /// Text with background
  static Widget textWithBackground({
    required String text,
    required TextStyle style,
    required Color backgroundColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) => Container(
    padding: padding ?? AppModifiers.paddingSmall,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(AppModifiers.smallRadius),
    ),
    child: Text(text, style: style),
  );

  /// Text with border
  static Widget textWithBorder({
    required String text,
    required TextStyle style,
    required Color borderColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) => Container(
    padding: padding ?? AppModifiers.paddingSmall,
    decoration: BoxDecoration(
      border: Border.all(color: borderColor),
      borderRadius: borderRadius ?? BorderRadius.circular(AppModifiers.smallRadius),
    ),
    child: Text(text, style: style),
  );

  /// Expandable text
  static Widget expandableText({
    required String text,
    required TextStyle style,
    int maxLines = 3,
  }) => LayoutBuilder(
    builder: (context, constraints) {
      final span = TextSpan(text: text, style: style);
      final tp = TextPainter(
        text: span,
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: constraints.maxWidth);

      if (tp.didExceedMaxLines) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: style,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            TextButton(
              onPressed: () {
                // Handle expand functionality
              },
              child: const Text('Show more'),
            ),
          ],
        );
      } else {
        return Text(text, style: style);
      }
    },
  );

  /// Rich text helpers
  static Widget richText({
    required String normalText,
    required String highlightedText,
    required TextStyle normalStyle,
    required TextStyle highlightedStyle,
  }) => RichText(
    text: TextSpan(
      text: normalText,
      style: normalStyle,
      children: [
        TextSpan(
          text: highlightedText,
          style: highlightedStyle,
        ),
      ],
    ),
  );

  /// Text with icon
  static Widget textWithIcon({
    required String text,
    required IconData icon,
    required TextStyle style,
    Color? iconColor,
    double? iconSize,
    bool iconAtEnd = false,
  }) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (!iconAtEnd) ...[
        Icon(icon, color: iconColor ?? style.color, size: iconSize ?? 20),
        const SizedBox(width: AppModifiers.smallSpacing),
      ],
      Text(text, style: style),
      if (iconAtEnd) ...[
        const SizedBox(width: AppModifiers.smallSpacing),
        Icon(icon, color: iconColor ?? style.color, size: iconSize ?? 20),
      ],
    ],
  );
}