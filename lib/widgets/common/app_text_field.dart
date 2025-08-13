import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_input_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';

enum AppTextFieldStyle {
  base,
  large,
  small,
  search,
  email,
  phone,
  textarea,
}

enum AppTextFieldState {
  normal,
  success,
  warning,
  error,
}

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final bool enabled;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final AppTextFieldStyle style;
  final AppTextFieldState state;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? errorText;
  final String? helperText;
  final bool autofocus;
  final EdgeInsets? contentPadding;
  final Iterable<String>? autofillHints;
  final bool expands;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.sentences,
    this.enabled = true,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.style = AppTextFieldStyle.base,
    this.state = AppTextFieldState.normal,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.errorText,
    this.helperText,
    this.autofocus = false,
    this.contentPadding,
    this.autofillHints,
    this.expands = false,
  });

  InputDecoration _getInputDecoration(BuildContext context) {
    InputDecoration decoration;
    
    switch (style) {
      case AppTextFieldStyle.base:
        decoration = AppInputStyles.base(context);
        break;
      case AppTextFieldStyle.large:
        decoration = AppInputStyles.large(context);
        break;
      case AppTextFieldStyle.small:
        decoration = AppInputStyles.small(context);
        break;
      case AppTextFieldStyle.search:
        decoration = AppInputStyles.search(context);
        break;
      case AppTextFieldStyle.email:
        decoration = AppInputStyles.email(context);
        break;
      case AppTextFieldStyle.phone:
        decoration = AppInputStyles.phone(context);
        break;
      case AppTextFieldStyle.textarea:
        decoration = AppInputStyles.textarea(context);
        break;
    }

    switch (state) {
      case AppTextFieldState.success:
        decoration = AppInputStyles.success(context);
        break;
      case AppTextFieldState.warning:
        decoration = AppInputStyles.warning(context);
        break;
      case AppTextFieldState.error:
        final venyuTheme = context.venyuTheme;
        decoration = decoration.copyWith(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            borderSide: BorderSide(
              color: venyuTheme.error,
              width: AppModifiers.thinBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            borderSide: BorderSide(
              color: venyuTheme.error,
              width: AppModifiers.mediumBorder,
            ),
          ),
        );
        break;
      case AppTextFieldState.normal:
        break;
    }

    return decoration.copyWith(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      helperText: helperText,
    );
  }

  EdgeInsets _getPadding() {
    if (contentPadding != null) return contentPadding!;
    
    switch (style) {
      case AppTextFieldStyle.large:
        return const EdgeInsets.symmetric(
          horizontal: AppModifiers.mediumSpacing,
          vertical: AppModifiers.mediumSpacing,
        );
      case AppTextFieldStyle.small:
        return const EdgeInsets.symmetric(
          horizontal: AppModifiers.smallSpacing,
          vertical: AppModifiers.smallSpacing,
        );
      default:
        return const EdgeInsets.symmetric(
          horizontal: AppModifiers.mediumSpacing,
          vertical: AppModifiers.smallSpacing,
        );
    }
  }

  double _getBorderRadius() {
    switch (style) {
      case AppTextFieldStyle.large:
      case AppTextFieldStyle.textarea:
        return AppModifiers.largeRadius;
      case AppTextFieldStyle.small:
        return AppModifiers.smallRadius;
      default:
        return AppModifiers.mediumRadius;
    }
  }

  double _getCupertinoBorderRadius() {
    switch (style) {
      case AppTextFieldStyle.large:
      case AppTextFieldStyle.textarea:
        return AppModifiers.mediumRadius;
      case AppTextFieldStyle.small:
        return AppModifiers.smallRadius;
      default:
        return AppModifiers.tinyRadius;
    }
  }

  Widget _buildCupertinoTextField(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final padding = _getPadding();
    
    return Container(
      decoration: BoxDecoration(
        color: venyuTheme.cardBackground,
        borderRadius: BorderRadius.circular(_getCupertinoBorderRadius()),
        border: Border.all(
          color: state == AppTextFieldState.error 
            ? venyuTheme.error 
            : state == AppTextFieldState.success
              ? venyuTheme.success
              : state == AppTextFieldState.warning
                ? venyuTheme.warning
                : venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
      ),
      child: CupertinoTextField(
        controller: controller,
        placeholder: hintText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        enabled: enabled,
        obscureText: obscureText,
        maxLines: obscureText ? 1 : (expands ? null : maxLines),
        minLines: expands ? null : minLines,
        expands: expands,
        onChanged: onChanged,
        onTap: onTap,
        autofocus: autofocus,
        autofillHints: autofillHints,
        padding: padding, // Dit is de interne padding!
        decoration: const BoxDecoration(), // Geen decoratie, want die zit op de Container
        style: AppTextStyles.body.copyWith(
          color: enabled ? venyuTheme.primaryText : venyuTheme.disabledText,
        ),
        prefix: prefixIcon != null ? Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: prefixIcon,
        ) : null,
        suffix: suffixIcon != null ? Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: suffixIcon,
        ) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final padding = _getPadding();
    
    // Voor iOS gebruiken we een custom implementatie
    if (isCupertino(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null) ...[
            Text(
              labelText!,
              style: AppTextStyles.body.copyWith(
                color: venyuTheme.secondaryText,
              ),
            ),
            const SizedBox(height: 8),
          ],
          _buildCupertinoTextField(context),
          if (errorText != null || helperText != null) ...[
            const SizedBox(height: 4),
            Text(
              errorText ?? helperText!,
              style: AppTextStyles.body.copyWith(
                color: errorText != null ? venyuTheme.error : venyuTheme.secondaryText,
              ),
            ),
          ],
        ],
      );
    }
    
    // Voor Android gebruiken we de normale PlatformTextFormField
    return PlatformTextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      enabled: enabled,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : (expands ? null : maxLines),
      minLines: expands ? null : minLines,
      expands: expands,
      onChanged: onChanged,
      onTap: onTap,
      autofocus: autofocus,
      autofillHints: autofillHints,
      style: AppTextStyles.body.copyWith(
        color: enabled ? venyuTheme.primaryText : venyuTheme.disabledText,
      ),
      material: (_, __) => MaterialTextFormFieldData(
        decoration: _getInputDecoration(context).copyWith(
          contentPadding: padding,
        ),
      ),
    );
  }
}