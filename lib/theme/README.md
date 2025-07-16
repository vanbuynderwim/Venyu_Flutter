# Venyu Flutter Theme System

Een volledig custom theme systeem dat identiek is aan de Swift iOS app, zonder Material of Cupertino afhankelijkheden.

## 🎨 Architectuur

```
lib/theme/
├── app_theme.dart          # Main theme entry point
├── app_colors.dart         # Color constants (matching Swift Theme.swift)
├── app_text_styles.dart    # iOS typography scale + Graphie font styles
├── app_fonts.dart          # Font family constants
├── theme_data.dart         # Flutter ThemeData configuration
└── README.md              # This file
```

## 🚀 Gebruik

### Basic Setup
```dart
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

MaterialApp(
  theme: AppTheme.theme,
  home: MyHomePage(),
)
```

### Colors
```dart
import 'theme/app_theme.dart';

// Primary colors (7 shades of blue/purple)
Container(color: AppColors.primair1Galaxy)    // Darkest blue
Container(color: AppColors.primair4Lilac)     // Default primary
Container(color: AppColors.primair7Pearl)     // Lightest blue

// Secondary colors (7 shades of grey/black)
Container(color: AppColors.secundair1Deepblack)  // Darkest grey
Container(color: AppColors.secundair3Slategray)  // Default secondary
Container(color: AppColors.secundair7Cascadingwhite) // Lightest grey

// Accent colors (4 shades of orange/red)
Container(color: AppColors.accent1Tangerine)  // Darkest orange
Container(color: AppColors.accent4Bluch)      // Lightest orange

// Action colors (interaction-specific)
Container(color: AppColors.me)    // Green - for "me" actions
Container(color: AppColors.need)  // Blue-green - for "need" actions
Container(color: AppColors.know)  // Orange - for "know" actions
Container(color: AppColors.na)    // Red - for "n/a" actions

// Convenience colors
Container(color: AppColors.primary)     // primair3Berry
Container(color: AppColors.secondary)   // secundair3Slategray
Container(color: AppColors.accent)      // accent1Tangerine
Container(color: AppColors.background)  // alabasterWhite
Container(color: AppColors.surface)     // softCloudGray
```

### Typography
```dart
import 'theme/app_theme.dart';

// iOS Typography Scale
Text('Extra Large Title', style: AppTextStyles.extraLargeTitle)  // 36pt Bold
Text('Large Title', style: AppTextStyles.largeTitle)            // 34pt Regular
Text('Title 1', style: AppTextStyles.title1)                    // 28pt Regular
Text('Title 2', style: AppTextStyles.title2)                    // 22pt Regular
Text('Title 3', style: AppTextStyles.title3)                    // 20pt Regular
Text('Headline', style: AppTextStyles.headline)                 // 17pt Semibold
Text('Subheadline', style: AppTextStyles.subheadline)          // 15pt Regular
Text('Body', style: AppTextStyles.body)                        // 17pt Regular
Text('Callout', style: AppTextStyles.callout)                  // 16pt Regular
Text('Footnote', style: AppTextStyles.footnote)                // 13pt Regular
Text('Caption 1', style: AppTextStyles.caption1)               // 12pt Regular
Text('Caption 2', style: AppTextStyles.caption2)               // 11pt Regular

// Special Graphie Font Styles
Text('venyu', style: AppTextStyles.appTitle)                   // 46pt Graphie - App title
Text('Make the net work', style: AppTextStyles.appSubtitle)    // 20pt Graphie - Subtitle
Text('Prompt text', style: AppTextStyles.promptLabel)          // 40pt Graphie Semibold

// Color variations
Text('Primary text', style: AppTextStyles.primary(AppTextStyles.headline))
Text('Accent text', style: AppTextStyles.accent(AppTextStyles.body))
Text('On primary', style: AppTextStyles.onPrimary(AppTextStyles.headline))
```

### Fonts
```dart
import 'theme/app_theme.dart';

// Available font families
TextStyle(fontFamily: AppFonts.graphie)  // Custom Graphie font
TextStyle(fontFamily: AppFonts.system)   // System font fallback

// Available font weights
TextStyle(fontWeight: FontWeight.w100)  // Thin
TextStyle(fontWeight: FontWeight.w200)  // ExtraLight
TextStyle(fontWeight: FontWeight.w300)  // Light
TextStyle(fontWeight: FontWeight.w400)  // Regular
TextStyle(fontWeight: FontWeight.w500)  // Book
TextStyle(fontWeight: FontWeight.w600)  // SemiBold
TextStyle(fontWeight: FontWeight.w700)  // Bold
TextStyle(fontWeight: FontWeight.w800)  // ExtraBold
```

## 🎯 Functionaliteit

### Cross-Platform Consistency
- **useMaterial3: false** - Geen Material 3 features
- **platform: TargetPlatform.fuchsia** - Neutrale platform voor consistente look
- **Geen Cupertino afhankelijkheden** - Volledig custom components

### Theme Components
- **AppBar**: Transparant met custom text styles
- **Buttons**: Eigen styling met border radius 12
- **Cards**: Wit met shadow en rounded corners
- **Inputs**: Filled style met custom borders
- **Navigation**: Custom bottom navigation styling

### Toast/Notification Colors
De ToastStyle enum gebruikt automatisch de juiste kleuren:
```dart
ToastStyle.success.themeColor  // AppColors.me (green)
ToastStyle.warning.themeColor  // AppColors.know (orange)
ToastStyle.error.themeColor    // AppColors.na (red)
ToastStyle.info.themeColor     // AppColors.need (blue-green)
```

## 📱 Graphie Font

De Graphie font is volledig geïntegreerd met alle weights:
- **Thin** (100) + Italic
- **ExtraLight** (200) + Italic  
- **Light** (300) + Italic
- **Regular** (400) + Italic
- **Book** (500) + Italic
- **SemiBold** (600) + Italic
- **Bold** (700) + Italic
- **ExtraBold** (800) + Italic

## 🔧 Extensibility

### Nieuwe kleuren toevoegen
```dart
// In app_colors.dart
static const Color myNewColor = Color(0xFF123456);

// In theme_data.dart (indien nodig)
// Voeg toe aan ColorScheme of andere theme properties
```

### Nieuwe text styles toevoegen
```dart
// In app_text_styles.dart
static TextStyle myNewStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  fontFamily: AppFonts.graphie,
  color: AppColors.textPrimary,
);
```

## ✅ Voordelen

- **100% identiek aan Swift app** - Kleuren en fonts exact gematched
- **Cross-platform consistent** - Zelfde look op iOS, Android, Web
- **Type-safe** - Compile-time checks voor kleuren en fonts
- **Maintainable** - Alle styling op één plek
- **Extensible** - Gemakkelijk nieuwe styles toe te voegen
- **Performance** - Geen runtime overhead van Material/Cupertino
- **Designer-friendly** - Directe mapping naar design tokens