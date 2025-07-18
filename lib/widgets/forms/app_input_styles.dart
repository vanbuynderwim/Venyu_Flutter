import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';

/// Venyu Input Field Styles - Consistent input styling with validation states
class AppInputStyles {
  AppInputStyles._();

  /// Base input decoration
  static InputDecoration get base => InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      borderSide: BorderSide(
        color: AppColors.secondaryLight,
        width: AppModifiers.thinBorder,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      borderSide: BorderSide(
        color: AppColors.secondaryLight,
        width: AppModifiers.thinBorder,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      borderSide: BorderSide(
        color: AppColors.primary,
        width: AppModifiers.mediumBorder,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      borderSide: BorderSide(
        color: AppColors.error,
        width: AppModifiers.thinBorder,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      borderSide: BorderSide(
        color: AppColors.error,
        width: AppModifiers.mediumBorder,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      borderSide: BorderSide(
        color: AppColors.secundair6Rocket,
        width: AppModifiers.thinBorder,
      ),
    ),
    contentPadding: AppModifiers.inputPadding,
    hintStyle: AppTextStyles.body.copyWith(
      color: AppColors.textLight,
    ),
    labelStyle: AppTextStyles.subheadline.copyWith(
      color: AppColors.textSecondary,
    ),
    errorStyle: AppTextStyles.footnote.copyWith(
      color: AppColors.error,
    ),
    helperStyle: AppTextStyles.footnote.copyWith(
      color: AppColors.textLight,
    ),
    floatingLabelStyle: AppTextStyles.subheadline.copyWith(
      color: AppColors.primary,
    ),
  );

  /// Success state input
  static InputDecoration get success => base.copyWith(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      borderSide: BorderSide(
        color: AppColors.success,
        width: AppModifiers.thinBorder,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      borderSide: BorderSide(
        color: AppColors.success,
        width: AppModifiers.mediumBorder,
      ),
    ),
    suffixIcon: Icon(
      Icons.check_circle_outline,
      color: AppColors.success,
      size: 20,
    ),
  );

  /// Warning state input
  static InputDecoration get warning => base.copyWith(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      borderSide: BorderSide(
        color: AppColors.warning,
        width: AppModifiers.thinBorder,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
      borderSide: BorderSide(
        color: AppColors.warning,
        width: AppModifiers.mediumBorder,
      ),
    ),
    suffixIcon: Icon(
      Icons.warning_amber_outlined,
      color: AppColors.warning,
      size: 20,
    ),
  );

  /// Search input style
  static InputDecoration get search => base.copyWith(
    hintText: 'Search...',
    prefixIcon: Icon(
      Icons.search,
      color: AppColors.textLight,
      size: 20,
    ),
    suffixIcon: null,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppModifiers.mediumSpacing,
      vertical: AppModifiers.mediumSpacing,
    ),
  );

  /// Password input style
  static InputDecoration passwordDecoration({
    required bool isObscured,
    required VoidCallback onToggleVisibility,
  }) => base.copyWith(
    suffixIcon: IconButton(
      icon: Icon(
        isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: AppColors.textLight,
        size: 20,
      ),
      onPressed: onToggleVisibility,
    ),
  );

  /// Email input style
  static InputDecoration get email => base.copyWith(
    prefixIcon: Icon(
      Icons.email_outlined,
      color: AppColors.textLight,
      size: 20,
    ),
  );

  /// Phone input style
  static InputDecoration get phone => base.copyWith(
    prefixIcon: Icon(
      Icons.phone_outlined,
      color: AppColors.textLight,
      size: 20,
    ),
  );

  /// Small input style
  static InputDecoration get small => base.copyWith(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
      borderSide: BorderSide(
        color: AppColors.secondaryLight,
        width: AppModifiers.thinBorder,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
      borderSide: BorderSide(
        color: AppColors.secondaryLight,
        width: AppModifiers.thinBorder,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
      borderSide: BorderSide(
        color: AppColors.primary,
        width: AppModifiers.mediumBorder,
      ),
    ),
    contentPadding: AppModifiers.buttonPaddingSmall,
    isDense: true,
  );

  /// Large input style
  static InputDecoration get large => base.copyWith(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
      borderSide: BorderSide(
        color: AppColors.secondaryLight,
        width: AppModifiers.thinBorder,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
      borderSide: BorderSide(
        color: AppColors.secondaryLight,
        width: AppModifiers.thinBorder,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
      borderSide: BorderSide(
        color: AppColors.primary,
        width: AppModifiers.mediumBorder,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppModifiers.largeSpacing,
      vertical: AppModifiers.largeSpacing,
    ),
  );

  /// Textarea style
  static InputDecoration get textarea => base.copyWith(
    alignLabelWithHint: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppModifiers.mediumSpacing,
      vertical: AppModifiers.mediumSpacing,
    ),
  );

  /// Disabled input style
  static InputDecoration get disabled => base.copyWith(
    enabled: false,
    fillColor: AppColors.secundair7Cascadingwhite,
    labelStyle: AppTextStyles.subheadline.copyWith(
      color: AppColors.textLight,
    ),
    hintStyle: AppTextStyles.body.copyWith(
      color: AppColors.textLight,
    ),
  );

  /// Borderless input style
  static InputDecoration get borderless => InputDecoration(
    filled: false,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding: AppModifiers.inputPadding,
    hintStyle: AppTextStyles.body.copyWith(
      color: AppColors.textLight,
    ),
  );

  /// Underlined input style
  static InputDecoration get underlined => InputDecoration(
    filled: false,
    border: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.secondaryLight,
        width: AppModifiers.thinBorder,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.secondaryLight,
        width: AppModifiers.thinBorder,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primary,
        width: AppModifiers.mediumBorder,
      ),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.error,
        width: AppModifiers.thinBorder,
      ),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.error,
        width: AppModifiers.mediumBorder,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: AppModifiers.mediumSpacing,
    ),
    hintStyle: AppTextStyles.body.copyWith(
      color: AppColors.textLight,
    ),
    labelStyle: AppTextStyles.subheadline.copyWith(
      color: AppColors.textSecondary,
    ),
  );
}

/// Input validation helper
class InputValidation {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}