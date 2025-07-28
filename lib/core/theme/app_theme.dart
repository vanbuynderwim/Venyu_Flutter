import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'venyu_theme.dart';

// Export only theme-related components (no widgets)
export 'app_colors.dart';
export 'app_fonts.dart';
export 'app_text_styles.dart';
export 'app_modifiers.dart';
export 'app_button_styles.dart';
export 'app_input_styles.dart';  
export 'app_layout_styles.dart';
export 'app_spacing_theme.dart';
export 'venyu_theme.dart';

/// Main App Theme class - Single entry point for all theming
class AppTheme {
  AppTheme._();

  /// Get the light theme data
  static ThemeData get lightTheme => VenyuThemeData.lightTheme;
  
  /// Get the dark theme data
  static ThemeData get darkTheme => VenyuThemeData.darkTheme;
  
  /// Get the light Cupertino theme data
  static CupertinoThemeData get cupertinoLightTheme => VenyuThemeData.cupertinoLightTheme;
  
  /// Get the dark Cupertino theme data
  static CupertinoThemeData get cupertinoDarkTheme => VenyuThemeData.cupertinoDarkTheme;
  
  // Legacy getters for backward compatibility
  static ThemeData get theme => lightTheme;
  static CupertinoThemeData get cupertinoTheme => cupertinoLightTheme;
}