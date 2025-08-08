/// Venyu App Fonts
class AppFonts {
  AppFonts._();

  // Font families
  static const String graphie = 'Graphie';
  
  /// System font family - automatically uses the correct system font per platform:
  /// - iOS: San Francisco (SF Pro)
  /// - Android: Roboto  
  /// - Web: system-ui fallback
  /// - Windows: Segoe UI
  /// - macOS: San Francisco
  /// - Linux: system default
  /// 
  /// By not specifying a fontFamily (null), Flutter automatically uses
  /// the platform's default system font.
  static const String? system = null;
  
  // Font weights
  static const int thin = 100;
  static const int extraLight = 200;
  static const int light = 300;
  static const int regular = 400;
  static const int book = 450;
  static const int semiBold = 600;
  static const int bold = 700;
  static const int extraBold = 800;
  
  /// Default font family for the app
  /// 
  /// Returns null to use system default fonts automatically.
  /// This ensures each platform uses its native font:
  /// - iOS uses San Francisco
  /// - Android uses Roboto
  /// - Other platforms use their respective system fonts
  static const String? defaultFontFamily = system;
  
  /// Helper method to get the appropriate font family for text styles
  /// Returns null for system font, or a specific font name for custom fonts
  static String? getFontFamily({bool useSystem = true}) {
    return useSystem ? system : null;
  }
}