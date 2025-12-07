import 'dart:core';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Centralized validation utilities for form inputs
class ValidationUtils {
  ValidationUtils._();

  // Email validation regex
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // URL validation regex - accepts with or without http(s):// and www.
  static final _urlRegex = RegExp(
    r'^(https?:\/\/)?(www\.)?([\w\-]+\.)+[\w\-]+(\/[\w\-./?%&=]*)?$',
  );

  // LinkedIn URL validation regex
  static final _linkedInRegex = RegExp(
    r'^https:\/\/www\.linkedin\.com\/in\/[a-zA-Z0-9\-]+\/?$',
  );

  /// Validates email format
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? email, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (email == null || email.trim().isEmpty) {
      return l10n.validationEmailRequired;
    }

    final trimmedEmail = email.trim();
    if (!_emailRegex.hasMatch(trimmedEmail)) {
      return l10n.validationEmailInvalid;
    }

    return null;
  }

  /// Validates general URL format
  /// Returns null if valid, error message if invalid
  static String? validateUrl(String? url, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (url == null || url.trim().isEmpty) {
      return null; // URL is optional
    }

    final trimmedUrl = url.trim();
    if (!_urlRegex.hasMatch(trimmedUrl)) {
      return l10n.validationUrlInvalid;
    }

    return null;
  }

  /// Validates LinkedIn profile URL format
  /// Returns null if valid, error message if invalid
  static String? validateLinkedInUrl(String? url, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (url == null || url.trim().isEmpty) {
      return null; // LinkedIn URL is optional
    }

    final trimmedUrl = url.trim();
    if (!_linkedInRegex.hasMatch(trimmedUrl)) {
      return l10n.validationLinkedInUrlInvalid;
    }

    return null;
  }

  /// Validates required text field
  /// Returns null if valid, error message if invalid
  static String? validateRequired(String? value, BuildContext context, {String? fieldName}) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? l10n.validationFieldRequired(fieldName)
          : l10n.validationFieldRequiredDefault;
    }
    return null;
  }

  /// Validates minimum length
  /// Returns null if valid, error message if invalid
  static String? validateMinLength(String? value, int minLength, BuildContext context, {String? fieldName}) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return null; // Let validateRequired handle empty values
    }

    if (value.trim().length < minLength) {
      return l10n.validationMinLength(fieldName ?? 'This field', minLength);
    }

    return null;
  }

  /// Validates maximum length
  /// Returns null if valid, error message if invalid
  static String? validateMaxLength(String? value, int maxLength, BuildContext context, {String? fieldName}) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.trim().length > maxLength) {
      return l10n.validationMaxLength(fieldName ?? 'This field', maxLength);
    }

    return null;
  }

  /// Validates OTP code (6 digits)
  /// Returns null if valid, error message if invalid
  static String? validateOtpCode(String? code, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (code == null || code.trim().isEmpty) {
      return l10n.validationOtpRequired;
    }

    final trimmedCode = code.trim();
    if (trimmedCode.length != 6) {
      return l10n.validationOtpLength;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(trimmedCode)) {
      return l10n.validationOtpNumeric;
    }

    return null;
  }

  /// Combines multiple validators
  /// Returns first error message found, or null if all pass
  static String? combineValidators(
    String? value,
    BuildContext context,
    List<String? Function(String?, BuildContext)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value, context);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}