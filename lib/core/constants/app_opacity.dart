/// App Opacity - Consistent opacity values throughout the app
/// 
/// This class contains all opacity constants to ensure consistency
/// in visual feedback and transparency effects.
class AppOpacity {
  AppOpacity._();

  /// Interaction states
  static const double disabled = 0.5;
  static const double disabledButton = 0.7;
  static const double pressed = 0.8;
  static const double hovered = 0.9;
  static const double focused = 0.95;

  /// Visual hierarchy
  static const double primary = 1.0;
  static const double secondary = 0.8;
  static const double tertiary = 0.6;
  static const double subtle = 0.4;
  static const double faint = 0.2;
  static const double barely = 0.1;

  /// Shadows and overlays
  static const double shadowLight = 0.1;
  static const double shadowMedium = 0.15;
  static const double shadowStrong = 0.2;
  static const double shadowDark = 0.3;

  /// Modal and overlay backgrounds
  static const double modalBackdrop = 0.6;
  static const double overlayBackground = 0.8;
  static const double scrimBackground = 0.4;

  /// Loading states
  static const double loadingOverlay = 0.7;
  static const double shimmerBase = 0.3;
  static const double shimmerHighlight = 0.1;

  /// Status indicators
  static const double errorState = 0.9;
  static const double warningState = 0.8;
  static const double successState = 0.9;
  static const double infoState = 0.8;

  /// Helper method to apply opacity to colors
  static double forState({
    required bool isDisabled,
    required bool isPressed,
    required bool isHovered,
  }) {
    if (isDisabled) return disabled;
    if (isPressed) return pressed;
    if (isHovered) return hovered;
    return primary;
  }
}