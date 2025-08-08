import 'package:flutter/material.dart';

/// Login button type variants for authentication buttons.
/// 
/// Defines the available login providers for authentication.
/// All login buttons use consistent white background with dark text
/// and preserve original logo colors.
/// 
/// Example usage:
/// ```dart
/// LoginButton(
///   type: LoginButtonType.linkedIn,
///   label: 'Sign in with LinkedIn',
///   icon: Image.asset('assets/images/visuals/linkedInLogo.png'),
///   onPressed: () => signInWithLinkedIn(),
/// )
/// ```
enum LoginButtonType {
  linkedIn(
    value: 'linkedIn',
    label: 'Sign in with LinkedIn',
    iconPath: 'assets/images/visuals/linkedin_logo.png',
  ),
  apple(
    value: 'apple',
    label: 'Sign in with Apple',
    iconPath: 'assets/images/visuals/apple_logo.png',
  ),
  google(
    value: 'google',
    label: 'Sign in with Google',
    iconPath: 'assets/images/visuals/google_logo.png',
  );

  const LoginButtonType({
    required this.value,
    required this.label,
    required this.iconPath,
  });
  
  final String value;
  final String label;
  final String iconPath;

  /// Creates a [LoginButtonType] from a JSON string value.
  /// 
  /// Returns [LoginButtonType.linkedIn] if the value doesn't match any type.
  static LoginButtonType fromJson(String value) {
    return LoginButtonType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => LoginButtonType.linkedIn,
    );
  }
  
  /// Returns the icon widget for this login button type.
  /// Uses the pre-defined icon path to load the appropriate logo.
  Widget get icon => Image.asset(
    iconPath,
  );

  /// Converts this [LoginButtonType] to a JSON string value.
  String toJson() => value;

  /// Returns the text color for login buttons.
  /// All buttons use dark text on white background for consistency.
  Color textColor(BuildContext context) => Colors.black87;

  /// Returns the font weight for login buttons.
  /// All login buttons use semibold weight for consistency and emphasis.
  FontWeight get fontWeight => FontWeight.w600; // semibold
}