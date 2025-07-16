# Flutter Enums - Complete Implementation

Dit bestand bevat een overzicht van alle geïmplementeerde enums in de Flutter app, gebaseerd op de Swift iOS app.

## ✅ Geïmplementeerde Enums

### Core Functionality
- **CategoryType** - `personal`, `company`
- **InteractionType** - `thisIsMe`, `lookingForThis`, `knowSomeone`, `notRelevant`
- **MatchStatus** - `matched`, `connected`
- **MatchResponse** - `interested`, `notInterested`
- **NotificationType** - `cardSubmitted`, `cardApproved`, `cardRejected`, `matched`, `connected`
- **PromptStatus** - `draft`, `pendingReview`, `pendingTranslation`, `approved`, `rejected`, `archived`

### Feedback & Reviews
- **FeedbackType** - 13 verschillende feedback types (positief/negatief)
- **ReviewType** - `user`, `system`

### UI & Navigation
- **CircleSections** - `posts`, `about`, `media`, `profiles`
- **ProfileSections** - `cards`, `reviews`, `venues`
- **ToastStyle** - `error`, `warning`, `success`, `info`
- **ImageSourceType** - `camera`, `photoLibrary`
- **PagesType** - `profileEdit`, `location`

### System & Storage
- **KeychainKeys** - 11 verschillende storage keys
- **RemoteImagePath** - `avatars`, `venues`, `icons`

## 🔧 Functionaliteit

### JSON Serialization
Alle enums met String raw values hebben:
- `fromJson(String value)` - Converteert JSON string naar enum
- `toJson()` - Converteert enum naar JSON string

### Helper Methods
Veel enums bevatten helper methods zoals:
- `title` - Gebruiksvriendelijke titel
- `description` - Beschrijving
- `icon` - Icon naam
- `isPositive` / `isNegative` - Status checks
- `themeColor` - UI kleuren

### Categorisatie
KeychainKeys bevat helper methods om keys te categoriseren:
- `isOnboardingKey` - Voor onboarding status
- `isTokenKey` - Voor security tokens
- `isProfileKey` - Voor profiel informatie

## 📱 Gebruik

```dart
// Import alle enums
import 'models/models.dart';

// Gebruik in code
final feedback = FeedbackType.goodConnection;
final isPositive = feedback.isPositive; // true

final toast = ToastStyle.success;
final color = toast.themeColor; // Colors.green

// JSON serialization
final json = feedback.toJson(); // "good_connection"
final fromJson = FeedbackType.fromJson('linkedin_connected');
```

## 🔄 Synchronisatie met Swift

Alle enums zijn 100% gesynchroniseerd met hun Swift equivalenten:
- **Raw values** - Identieke string waarden
- **Cases** - Alle cases geïmplementeerd
- **Functionaliteit** - Vergelijkbare helper methods

## 🎯 Voordelen

- **Type-safe** - Compile-time checks
- **Consistent** - Uniforme API across alle enums
- **Maintainable** - Eenvoudig te onderhouden
- **Extensible** - Makkelijk uit te breiden
- **Well-documented** - Duidelijke helper methods