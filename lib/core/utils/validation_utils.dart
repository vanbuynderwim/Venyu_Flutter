import 'dart:core';

/// Centralized validation utilities for form inputs
class ValidationUtils {
  ValidationUtils._();

  // Email validation regex
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // URL validation regex
  static final _urlRegex = RegExp(
    r'^https?:\/\/([\w\-]+\.)+[\w\-]+(\/[\w\-./?%&=]*)?$',
  );

  // LinkedIn URL validation regex
  static final _linkedInRegex = RegExp(
    r'^https:\/\/www\.linkedin\.com\/in\/[a-zA-Z0-9\-]+\/?$',
  );

  /// Validates email format
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmedEmail = email.trim();
    if (!_emailRegex.hasMatch(trimmedEmail)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates general URL format
  /// Returns null if valid, error message if invalid
  static String? validateUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return null; // URL is optional
    }

    final trimmedUrl = url.trim();
    if (!_urlRegex.hasMatch(trimmedUrl)) {
      return 'Please enter a valid URL (starting with http:// or https://)';
    }

    return null;
  }

  /// Validates LinkedIn profile URL format
  /// Returns null if valid, error message if invalid
  static String? validateLinkedInUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return null; // LinkedIn URL is optional
    }

    final trimmedUrl = url.trim();
    if (!_linkedInRegex.hasMatch(trimmedUrl)) {
      return 'Please enter a valid LinkedIn profile URL\n(e.g., https://www.linkedin.com/in/yourname)';
    }

    return null;
  }

  /// Validates required text field
  /// Returns null if valid, error message if invalid
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validates minimum length
  /// Returns null if valid, error message if invalid
  static String? validateMinLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Let validateRequired handle empty values
    }

    if (value.trim().length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters long';
    }

    return null;
  }

  /// Validates maximum length
  /// Returns null if valid, error message if invalid
  static String? validateMaxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.trim().length > maxLength) {
      return '${fieldName ?? 'This field'} cannot exceed $maxLength characters';
    }

    return null;
  }

  /// Validates OTP code (6 digits)
  /// Returns null if valid, error message if invalid
  static String? validateOtpCode(String? code) {
    if (code == null || code.trim().isEmpty) {
      return 'Verification code is required';
    }

    final trimmedCode = code.trim();
    if (trimmedCode.length != 6) {
      return 'Verification code must be 6 digits';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(trimmedCode)) {
      return 'Verification code must contain only numbers';
    }

    return null;
  }

  /// Combines multiple validators
  /// Returns first error message found, or null if all pass
  static String? combineValidators(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}