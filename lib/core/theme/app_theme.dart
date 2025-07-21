import 'package:flutter/material.dart';
import 'theme_data.dart';

// Export only theme-related components (no widgets)
export 'app_colors.dart';
export 'app_fonts.dart';
export 'app_text_styles.dart';
export 'app_modifiers.dart';
export 'app_button_styles.dart';
export 'app_input_styles.dart';  
export 'app_layout_styles.dart';
export '../utils/app_scroll_behavior.dart';
export '../utils/no_ripple_theme.dart';
export 'theme_data.dart';

/// Main App Theme class - Single entry point for all theming
class AppTheme {
  AppTheme._();

  /// Get the main theme data
  static ThemeData get theme => VenyuThemeData.theme;
}