import 'package:flutter/material.dart';
import 'app_text_styles.dart';
import 'app_modifiers.dart';
import 'venyu_theme.dart';

/// Venyu Input Field Styles - Consistent input styling with validation states
/// 
/// Provides standardized input decorations that automatically adapt to the current theme.
/// All styles support both light and dark modes through VenyuTheme integration.
/// 
/// Example usage:
/// ```dart
/// PlatformTextFormField(
///   material: (_, __) => MaterialTextFormFieldData(
///     decoration: AppInputStyles.base(context),
///   ),
/// )
/// ```
class AppInputStyles {
  AppInputStyles._();

  /// Base input decoration with theme-aware styling
  static InputDecoration base(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return InputDecoration(
      filled: true,
      fillColor: venyuTheme.cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(
          color: venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(
          color: venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(
          color: venyuTheme.primary,
          width: AppModifiers.mediumBorder,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(
          color: venyuTheme.error,
          width: AppModifiers.thinBorder,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(
          color: venyuTheme.error,
          width: AppModifiers.mediumBorder,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(
          color: venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
      ),
      contentPadding: AppModifiers.inputPadding,
      hintStyle: AppTextStyles.body.copyWith(
        color: venyuTheme.secondaryText,
      ),
      labelStyle: AppTextStyles.subheadline.copyWith(
        color: venyuTheme.secondaryText,
      ),
      errorStyle: AppTextStyles.footnote.copyWith(
        color: venyuTheme.error,
      ),
      helperStyle: AppTextStyles.footnote.copyWith(
        color: venyuTheme.secondaryText,
      ),
      floatingLabelStyle: AppTextStyles.subheadline.copyWith(
        color: venyuTheme.primary,
      ),
    );
  }

  /// Success state input
  static InputDecoration success(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return base(context).copyWith(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(
          color: venyuTheme.success,
          width: AppModifiers.thinBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(
          color: venyuTheme.success,
          width: AppModifiers.mediumBorder,
        ),
      ),
      suffixIcon: Icon(
        Icons.check_circle_outline,
        color: venyuTheme.success,
        size: 20,
      ),
    );
  }

  /// Warning state input
  static InputDecoration warning(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return base(context).copyWith(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(
          color: venyuTheme.warning,
          width: AppModifiers.thinBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.mediumRadius),
        borderSide: BorderSide(
          color: venyuTheme.warning,
          width: AppModifiers.mediumBorder,
        ),
      ),
      suffixIcon: Icon(
        Icons.warning_amber_outlined,
        color: venyuTheme.warning,
        size: 20,
      ),
    );
  }

  /// Search input style
  static InputDecoration search(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return base(context).copyWith(
      hintText: 'Search...',
      prefixIcon: Icon(
        Icons.search,
        color: venyuTheme.secondaryText,
        size: 20,
      ),
      suffixIcon: null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppModifiers.mediumSpacing,
        vertical: AppModifiers.mediumSpacing,
      ),
    );
  }

  /// Password input style
  static InputDecoration passwordDecoration(
    BuildContext context, {
    required bool isObscured,
    required VoidCallback onToggleVisibility,
  }) {
    final venyuTheme = context.venyuTheme;
    
    return base(context).copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: venyuTheme.secondaryText,
          size: 20,
        ),
        onPressed: onToggleVisibility,
      ),
    );
  }

  /// Email input style
  static InputDecoration email(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return base(context).copyWith(
      prefixIcon: Icon(
        Icons.email_outlined,
        color: venyuTheme.secondaryText,
        size: 20,
      ),
    );
  }

  /// Phone input style
  static InputDecoration phone(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return base(context).copyWith(
      prefixIcon: Icon(
        Icons.phone_outlined,
        color: venyuTheme.secondaryText,
        size: 20,
      ),
    );
  }

  /// Small input style
  static InputDecoration small(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return base(context).copyWith(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
        borderSide: BorderSide(
          color: venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
        borderSide: BorderSide(
          color: venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.smallRadius),
        borderSide: BorderSide(
          color: venyuTheme.primary,
          width: AppModifiers.mediumBorder,
        ),
      ),
      contentPadding: AppModifiers.buttonPaddingSmall,
      isDense: true,
    );
  }

  /// Large input style
  static InputDecoration large(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return base(context).copyWith(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
        borderSide: BorderSide(
          color: venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
        borderSide: BorderSide(
          color: venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
        borderSide: BorderSide(
          color: venyuTheme.primary,
          width: AppModifiers.mediumBorder,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppModifiers.largeSpacing,
        vertical: AppModifiers.largeSpacing,
      ),
    );
  }

  /// Textarea style
  static InputDecoration textarea(BuildContext context) {
    return base(context).copyWith(
      alignLabelWithHint: false, // Keep hint text at top, not centered
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppModifiers.mediumSpacing,
        vertical: AppModifiers.mediumSpacing,
      ),
    );
  }

  /// Disabled input style
  static InputDecoration disabled(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return base(context).copyWith(
      enabled: false,
      fillColor: venyuTheme.disabledBackground,
      labelStyle: AppTextStyles.subheadline.copyWith(
        color: venyuTheme.disabledText,
      ),
      hintStyle: AppTextStyles.body.copyWith(
        color: venyuTheme.disabledText,
      ),
    );
  }

  /// Borderless input style
  static InputDecoration borderless(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return InputDecoration(
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: AppModifiers.inputPadding,
      hintStyle: AppTextStyles.body.copyWith(
        color: venyuTheme.secondaryText,
      ),
    );
  }

  /// Underlined input style
  static InputDecoration underlined(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return InputDecoration(
      filled: false,
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: venyuTheme.primary,
          width: AppModifiers.mediumBorder,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: venyuTheme.error,
          width: AppModifiers.thinBorder,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: venyuTheme.error,
          width: AppModifiers.mediumBorder,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppModifiers.mediumSpacing,
      ),
      hintStyle: AppTextStyles.body.copyWith(
        color: venyuTheme.secondaryText,
      ),
      labelStyle: AppTextStyles.subheadline.copyWith(
        color: venyuTheme.secondaryText,
      ),
    );
  }
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