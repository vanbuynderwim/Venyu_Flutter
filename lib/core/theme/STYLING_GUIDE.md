# Venyu Flutter Styling Guide

Dit document beschrijft het complete styling systeem voor de Venyu Flutter app, geïnspireerd door Swift UI modifiers.

## Overzicht

Het styling systeem bestaat uit verschillende componenten die samenwerken om een consistent en uitbreidbaar themasysteem te bieden:

- **AppColors**: Kleurenpalet gebaseerd op Swift Theme.swift
- **AppFonts**: Font definities (SF Pro default, Graphie voor branding)
- **AppTextStyles**: Volledige iOS typography scale
- **AppModifiers**: Layout constanten en decoraties
- **AppButtonStyles**: Button styling systeem
- **AppInputStyles**: Input field styling met validatie states
- **AppLayoutStyles**: Layout helpers en text layouts

## Gebruik

### Import

```dart
import 'package:app/theme/app_theme.dart';
```

Dit importeert alle styling componenten.

### Buttons

```dart
// Primary button
ElevatedButton(
  onPressed: () {},
  style: AppButtonStyles.primary,
  child: Text('Primary'),
)

// Destructive button
ElevatedButton(
  onPressed: () {},
  style: AppButtonStyles.destructive,
  child: Text('Delete'),
)

// Outlined button
OutlinedButton(
  onPressed: () {},
  style: AppButtonStyles.outlined,
  child: Text('Cancel'),
)

// Gradient button
GradientButton(
  onPressed: () {},
  decoration: AppButtonStyles.primaryGradientDecoration,
  child: Text('Gradient'),
)
```

#### Beschikbare button stijlen:
- `primary` - Hoofdacties (blauw)
- `secondary` - Alternatieve acties (grijs)
- `destructive` - Gevaarlijke acties (rood/oranje)
- `success` - Positieve acties (groen)
- `outlined` - Gecontoureerde buttons
- `outlinedDestructive` - Gecontoureerde destructieve buttons
- `text` - Tekst-only buttons
- `textDestructive` - Tekst destructieve buttons
- `primarySmall/secondarySmall` - Kleine varianten
- `primaryLarge` - Grote variant
- `fab` - Floating Action Button
- `icon` - Icon buttons

### Input Fields

```dart
// Basis input
TextFormField(
  decoration: AppInputStyles.base.copyWith(
    labelText: 'Name',
    hintText: 'Enter your name',
  ),
)

// Email input
TextFormField(
  decoration: AppInputStyles.email.copyWith(
    labelText: 'Email',
  ),
)

// Search input
TextFormField(
  decoration: AppInputStyles.search,
)

// Success state
TextFormField(
  decoration: AppInputStyles.success.copyWith(
    labelText: 'Valid Input',
  ),
)

// Error state
TextFormField(
  decoration: AppInputStyles.base.copyWith(
    labelText: 'Error Input',
    errorText: 'This field is required',
  ),
)
```

#### Beschikbare input stijlen:
- `base` - Basis input styling
- `success` - Succes state (groen)
- `warning` - Waarschuwing state (oranje)
- `search` - Zoekveld met icoon
- `email` - Email veld met icoon
- `phone` - Telefoon veld met icoon
- `small` - Kleine input
- `large` - Grote input
- `textarea` - Textarea styling
- `disabled` - Uitgeschakelde input
- `borderless` - Zonder border
- `underlined` - Onderstreept

### Layout Containers

```dart
// Basis container (zonder border)
Container(
  decoration: AppLayoutStyles.container(context),
  child: child,
)

// Container met border
Container(
  decoration: AppLayoutStyles.cardDecoration(context),
  child: child,
)

// Elevated container (card)
Container(
  decoration: AppLayoutStyles.containerElevated,
  child: child,
)

// Section
Container(
  decoration: AppLayoutStyles.section,
  child: child,
)
```

### Modifiers

```dart
// Padding
Container(
  padding: AppModifiers.paddingMedium,
  child: child,
)

// Rounded corners
Container(
  decoration: AppModifiers.roundedMedium,
  child: child,
)

// Card met shadow
Container(
  decoration: AppModifiers.cardMedium,
  child: child,
)

// Border decoration
Container(
  decoration: AppModifiers.borderDecoration(
    borderColor: AppColors.primary,
    borderWidth: AppModifiers.mediumBorder,
  ),
  child: child,
)
```

### Text Layouts

```dart
// Gecentreerde tekst
AppTextLayouts.centeredText('Centered', AppTextStyles.headline)

// Tekst met background
AppTextLayouts.textWithBackground(
  text: 'Highlighted',
  style: AppTextStyles.body,
  backgroundColor: AppColors.primaryLight,
)

// Tekst met icoon
AppTextLayouts.textWithIcon(
  text: 'With Icon',
  icon: Icons.star,
  style: AppTextStyles.body,
)

// Tekst met border
AppTextLayouts.textWithBorder(
  text: 'Bordered',
  style: AppTextStyles.body,
  borderColor: AppColors.primary,
)
```

### Spacing

```dart
// Spacers
AppLayoutStyles.spacerSmall,    // 8px
AppLayoutStyles.spacerMedium,   // 16px
AppLayoutStyles.spacerLarge,    // 24px

// Horizontal spacers
AppLayoutStyles.spacerHorizontalSmall,  // 8px
AppLayoutStyles.spacerHorizontalMedium, // 16px
```

### Kleuren

```dart
// Primaire kleuren
AppColors.primary,        // Hoofd primaire kleur
AppColors.primaryLight,   // Lichte variant
AppColors.primaryDark,    // Donkere variant

// Secundaire kleuren
AppColors.secondary,      // Hoofd secundaire kleur
AppColors.secondaryLight, // Lichte variant
AppColors.secondaryDark,  // Donkere variant

// Accent kleuren
AppColors.accent,         // Hoofd accent kleur
AppColors.accentLight,    // Lichte variant

// Status kleuren
AppColors.success,        // Groen
AppColors.warning,        // Oranje
AppColors.error,          // Rood
AppColors.info,           // Blauw

// Actie kleuren
AppColors.me,            // Groen
AppColors.need,          // Blauw-groen
AppColors.know,          // Oranje
AppColors.na,            // Rood
```

### Typografie

```dart
// iOS typography scale
AppTextStyles.extraLargeTitle,  // 36pt
AppTextStyles.largeTitle,       // 32pt
AppTextStyles.title1,           // 28pt
AppTextStyles.title2,           // 22pt
AppTextStyles.title3,           // 20pt
AppTextStyles.headline,         // 18pt
AppTextStyles.subheadline,      // 15pt
AppTextStyles.body,             // 17pt
AppTextStyles.callout,          // 16pt
AppTextStyles.footnote,         // 13pt
AppTextStyles.caption1,         // 12pt
AppTextStyles.caption2,         // 11pt

// Branding stijlen (met Graphie font)
AppTextStyles.appTitle,         // Voor app naam
AppTextStyles.appSubtitle,      // Voor app tagline
AppTextStyles.promptLabel,      // Voor prompt labels
```

## Constanten

### Spacing
- `tinySpacing: 4px`
- `smallSpacing: 8px`
- `mediumSpacing: 16px`
- `largeSpacing: 24px`
- `extraLargeSpacing: 32px`

### Border Radius
- `smallRadius: 8px`
- `mediumRadius: 12px`
- `largeRadius: 16px`
- `extraLargeRadius: 24px`

### Elevation
- `noElevation: 0`
- `smallElevation: 2px`
- `mediumElevation: 4px`
- `largeElevation: 8px`

### Border Width
- `thinBorder: 1px`
- `mediumBorder: 2px`
- `thickBorder: 3px`

## Validatie

Voor input validatie is er een `InputValidation` helper class:

```dart
TextFormField(
  decoration: AppInputStyles.email,
  validator: InputValidation.validateEmail,
)

TextFormField(
  decoration: AppInputStyles.base,
  validator: (value) => InputValidation.validateRequired(value, 'Name'),
)
```

## Uitbreidingen

Het systeem is ontworpen om makkelijk uitbreidbaar te zijn:

1. **Nieuwe button stijlen**: Voeg toe aan `AppButtonStyles`
2. **Nieuwe input stijlen**: Voeg toe aan `AppInputStyles`
3. **Nieuwe layout helpers**: Voeg toe aan `AppLayoutStyles`
4. **Nieuwe modifiers**: Voeg toe aan `AppModifiers`

## iOS-style Interacties

Het theme systeem is geoptimaliseerd voor iOS-achtige interacties:

### Geen Ripple Effects
Alle buttons en interactieve elementen hebben geen Material Design ripple effects. Dit wordt bereikt door:
- `splashFactory: NoSplash.splashFactory` in alle button styles
- Globale theme configuratie zonder ripple effects

### Geen Overscroll Effects  
Scrollviews hebben geen glow of bounce overscroll effects:
- Custom `VenyuScrollBehavior` met `ClampingScrollPhysics`
- `scrollBehavior: VenyuScrollBehavior()` in MaterialApp
- Geen overscroll indicators

### Gebruik
```dart
MaterialApp(
  theme: AppTheme.theme,
  scrollBehavior: VenyuScrollBehavior(),
  // ...
)
```

## Best Practices

1. **Consistentie**: Gebruik altijd de styling constanten, niet hardcoded waardes
2. **Semantic naming**: Gebruik betekenisvolle namen voor stijlen
3. **Modulair**: Houd styling logica gescheiden van business logica
4. **Toegankelijkheid**: Zorg voor voldoende contrast en touch targets
5. **Performance**: Hergebruik decorations waar mogelijk
6. **iOS-consistentie**: Gebruik het theme systeem voor iOS-achtige interacties