# Constants Management

This directory contains all centralized constants for the Venyu Flutter app, organized by category for better maintainability and consistency.

## 📁 Files Overview

### `app_animations.dart`
- **Purpose**: Animation durations, curves, and transition configurations
- **Contents**: Standard durations (fast, normal, slow), common curves, page transitions
- **Usage**: `AppAnimations.normal`, `AppAnimations.defaultCurve`

### `app_assets.dart`
- **Purpose**: Type-safe access to app assets (images, icons, fonts)
- **Contents**: Icon variants, image paths, font definitions
- **Usage**: `AppAssets.icons.profile.regular`, `AppAssets.fonts.primaryFont`

### `app_dimensions.dart`
- **Purpose**: Consistent sizing throughout the app
- **Contents**: Avatar sizes, icon sizes, button heights, input dimensions
- **Usage**: `AppDimensions.avatarMedium`, `AppDimensions.buttonHeightDefault`

### `app_keys.dart`
- **Purpose**: Storage keys, identifiers, and route names
- **Contents**: SharedPreferences keys, database tables, API endpoints, navigation routes
- **Usage**: `AppKeys.userToken`, `AppKeys.profilesTable`, `AppKeys.homeRoute`

### `app_opacity.dart`
- **Purpose**: Consistent transparency values and visual feedback
- **Contents**: Interaction states, visual hierarchy, shadows, modal backgrounds
- **Usage**: `AppOpacity.disabled`, `AppOpacity.pressed`, `AppOpacity.modalBackdrop`

### `app_strings.dart`
- **Purpose**: User-facing text constants (supports future i18n)
- **Contents**: Navigation labels, actions, authentication, form validation, status messages
- **Usage**: `AppStrings.save`, `AppStrings.loading`, `AppStrings.invalidEmail`

### `app_timeouts.dart`
- **Purpose**: Network and operation timeout configurations
- **Contents**: Network requests, database operations, authentication, caching
- **Usage**: `AppTimeouts.networkRequest`, `AppTimeouts.imageLoad`

### `app_urls.dart`
- **Purpose**: External service URLs and URL building helpers
- **Contents**: S3 buckets, social media URLs, placeholder services, URL builders
- **Usage**: `AppUrls.avatarUrl(id)`, `AppUrls.placeholderIcon(text: 'AB')`

## 🎯 Benefits

### ✅ **Consistency**
- Single source of truth for all constants
- Eliminates magic numbers and hardcoded values
- Ensures consistent sizing and timing across the app

### ✅ **Maintainability**
- Easy to update values in one place
- Clear categorization makes constants easy to find
- Type-safe access prevents typos and runtime errors

### ✅ **Developer Experience**
- IDE autocompletion for all constants
- Self-documenting constant names
- Organized structure makes onboarding easier

### ✅ **Performance**
- Compile-time constants where possible
- Efficient helper methods for URL building
- Cached values for expensive computations

## 📋 Usage Examples

### Basic Usage
```dart
import 'package:venyu/core/constants/index.dart';

// Animations
AnimatedContainer(
  duration: AppAnimations.normal,
  curve: AppAnimations.defaultCurve,
  // ...
)

// Dimensions
CircleAvatar(
  radius: AppDimensions.avatarMedium / 2,
  // ...
)

// Opacity
Opacity(
  opacity: isPressed ? AppOpacity.pressed : AppOpacity.primary,
  child: // ...
)
```

### URL Building
```dart
// Avatar URL
final avatarUrl = AppUrls.avatarUrl('user123');

// Placeholder icon
final placeholderUrl = AppUrls.placeholderIcon(
  text: 'AB',
  size: 64,
  backgroundColor: '007AFF',
);

// Social media profile
final linkedInUrl = AppUrls.linkedInProfile('username');
```

### Storage and Keys
```dart
// SharedPreferences
final prefs = await SharedPreferences.getInstance();
await prefs.setString(AppKeys.userToken, token);
final savedToken = prefs.getString(AppKeys.userToken);

// Navigation
Navigator.pushNamed(context, AppKeys.profileRoute);

// Database queries
final profiles = await supabase
    .from(AppKeys.profilesTable)
    .select();
```

### Timeouts and Network
```dart
// HTTP client with timeout
final client = http.Client();
final response = await client
    .get(uri)
    .timeout(AppTimeouts.networkRequest);

// Image caching
CachedNetworkImage(
  imageUrl: imageUrl,
  cacheManager: CacheManager(
    Config(
      'imageCache',
      stalePeriod: AppTimeouts.imageCache,
    ),
  ),
);
```

## 🔧 Best Practices

### ✅ **Do**
- Use constants instead of hardcoded values
- Import from `core/constants/index.dart` for convenience
- Add new constants to appropriate category files
- Use descriptive names that indicate purpose and context
- Document any complex constants with inline comments

### ❌ **Don't**
- Hardcode magic numbers or strings in widgets
- Create constants in individual widget files
- Use generic names like `defaultValue` or `constant1`
- Mix different types of constants in the same file
- Forget to export new constants in `index.dart`

## 🔄 Migration Guide

### From Hardcoded Values
```dart
// ❌ Before
Container(
  height: 56,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
  ),
  // ...
)

// ✅ After
Container(
  height: AppDimensions.buttonHeightDefault,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
  ),
  // ...
)
```

### From Inline Strings
```dart
// ❌ Before
ElevatedButton(
  onPressed: onSave,
  child: Text('Save'),
)

// ✅ After
ElevatedButton(
  onPressed: onSave,
  child: Text(AppStrings.save),
)
```

### From Hardcoded URLs
```dart
// ❌ Before
final avatarUrl = 'https://venyu-avatars.s3.amazonaws.com/$userId.jpg';

// ✅ After
final avatarUrl = AppUrls.avatarUrl(userId);
```

This centralized constants system provides a solid foundation for consistent, maintainable, and scalable Flutter development.