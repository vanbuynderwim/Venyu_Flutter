import 'package:flutter/material.dart';
import 'theme_data.dart';

// Export all theme components
export 'app_colors.dart';
export 'app_fonts.dart';
export 'app_text_styles.dart';
export 'app_modifiers.dart';
export '../../widgets/forms/app_button_styles.dart';
export '../../widgets/forms/app_input_styles.dart';
export '../../widgets/forms/app_layout_styles.dart';
export '../utils/app_scroll_behavior.dart';
export '../utils/no_ripple_theme.dart';
export '../../widgets/buttons/interaction_button.dart';
export '../../widgets/buttons/option_button.dart';
export '../../widgets/common/tag_view.dart';
export '../../widgets/common/progress_bar.dart';
export '../../widgets/common/page_layout.dart';
export '../../widgets/buttons/action_button.dart';
export '../../widgets/common/section_type.dart';
export '../../widgets/buttons/section_button.dart';
export 'theme_data.dart';

/// Main App Theme class - Single entry point for all theming
class AppTheme {
  AppTheme._();

  /// Get the main theme data
  static ThemeData get theme => VenyuThemeData.theme;
}