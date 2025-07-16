# Supabase Services - Flutter Implementation

Deze implementatie repliceert de Swift SupabaseManager.swift functionaliteit volgens Flutter best practices.

## 🏗️ Architectuur

### Clean Architecture Layers:
```
📁 presentation/     <- UI layer (widgets, providers)
📁 domain/          <- Business logic (use cases, repositories interfaces)
📁 data/            <- Data layer (repositories implementations, models)
📁 core/            <- Shared code (enums, exceptions, constants)
📁 services/        <- External services (Supabase client)
📁 config/          <- Configuration (dependency injection)
```

## 🔧 Setup

### 1. Dependencies
```yaml
dependencies:
  supabase_flutter: ^2.9.1
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  device_info_plus: ^10.1.2
  package_info_plus: ^8.1.1
  get_it: ^8.0.0

dev_dependencies:
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
```

### 2. Code Generation
```bash
flutter pub get
flutter pub run build_runner build
```

## 📝 Gebruik

### 1. Dependency Injection
```dart
// In main.dart
await InjectionContainer.init();

// In je widget
final profileUsecase = sl<GetMyProfileUsecase>();
```

### 2. Repository Pattern
```dart
// Interface
abstract class SupabaseRepository {
  Future<ProfileModel> getMyProfile(UpdateCountryLanguageRequest request);
}

// Implementation
class SupabaseRepositoryImpl implements SupabaseRepository {
  @override
  Future<ProfileModel> getMyProfile(UpdateCountryLanguageRequest request) async {
    return _executeAuthenticatedRequest(() async {
      final response = await _client.rpc('get_my_profile', params: {
        'payload': request.toJson(),
      });
      return ProfileModel.fromJson(response);
    });
  }
}
```

### 3. Use Cases
```dart
final usecase = GetMyProfileUsecase(repository);
final profile = await usecase.call(
  countryCode: 'NL',
  languageCode: 'en',
  appVersion: '1.0.0',
);
```

### 4. Provider Pattern
```dart
class ProfileProvider extends ChangeNotifier {
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final profile = await _getMyProfileUsecase.call(
        countryCode: 'NL',
        languageCode: 'en',
        appVersion: '1.0.0',
      );
      _profile = profile;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

## 🔒 Authentication

### Sign In Methods:
```dart
final repository = sl<SupabaseRepository>();

// Apple Sign In
await repository.signInWithApple();

// LinkedIn Sign In
await repository.signInWithLinkedIn();

// Sign Out
await repository.signOut();
```

## 📊 RPC Functions

### Profile Management:
```dart
// Get profile
final profile = await repository.getMyProfile(UpdateCountryLanguageRequest(
  countryCode: 'NL',
  languageCode: 'en',
  appVersion: '1.0.0',
));

// Update profile name
await repository.updateProfileName(UpdateNameRequest(
  firstName: 'John',
  lastName: 'Doe',
  linkedInURL: 'https://linkedin.com/in/johndoe',
  linkedInURLValid: true,
));

// Update bio
await repository.updateProfileBio('My bio text');

// Update location
await repository.updateProfileLocation(52.3676, 4.9041);
```

### Tags & Categories:
```dart
// Get all tag groups
final allTagGroups = await repository.getAllTagGroups();

// Get tag groups by category
final personalTags = await repository.getTagGroups(CategoryType.personal);
final companyTags = await repository.getTagGroups(CategoryType.company);

// Get specific tag group
final tagGroup = await repository.getTagGroup('interests');
```

### Notifications & Badges:
```dart
// Get badges (unread counts)
final badges = await repository.getBadges();

// Get notifications (paginated)
final notifications = await repository.getNotifications(PaginatedRequest(
  limit: 20,
  list: ServerListType.notifications,
));

// Mark notification as read
await repository.updateNotification(notificationId);
```

### Matches:
```dart
// Get matches (paginated)
final matches = await repository.getMatches(PaginatedRequest(
  limit: 10,
  list: ServerListType.matches,
));

// Get specific match
final match = await repository.getMatch(matchId);
```

## 🚨 Error Handling

### Exception Types:
```dart
try {
  final profile = await repository.getMyProfile(request);
} on SupabaseException catch (e) {
  print('Supabase error: ${e.message}');
} on AuthException catch (e) {
  print('Auth error: ${e.message}');
} on NetworkException catch (e) {
  print('Network error: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

### Error Wrapper:
```dart
Future<T> _executeAuthenticatedRequest<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on PostgrestException catch (e) {
    throw SupabaseException(e.message);
  } catch (e) {
    throw SupabaseException(e.toString());
  }
}
```

## 🎯 Models

### Freezed Models:
```dart
@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String firstName,
    String? lastName,
    // ...
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
```

### Request Models:
```dart
@freezed
class UpdateNameRequest with _$UpdateNameRequest {
  const factory UpdateNameRequest({
    required String firstName,
    required String lastName,
    required String linkedInURL,
    required bool linkedInURLValid,
  }) = _UpdateNameRequest;

  factory UpdateNameRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNameRequestFromJson(json);
}
```

## 📱 Device Management

### Device Info:
```dart
// Automatic device info collection
await repository.handleDeviceToken(fcmToken);

// Returns device info including:
// - OS type (iOS/Android)
// - Device model
// - System version
// - App version
```

## 🔄 Next Steps

1. **Generate Code**: Run `flutter pub run build_runner build`
2. **Add More RPC Functions**: Extend repository with additional Swift functions
3. **Implement Storage**: Add file upload/download functionality
4. **Add Real-time**: Implement Supabase real-time subscriptions
5. **Add Tests**: Create unit tests for repository and use cases

## 📚 Swift Mapping

| Swift Function | Flutter Implementation |
|---|---|
| `getMyProfile()` | `repository.getMyProfile()` |
| `updateProfileName()` | `repository.updateProfileName()` |
| `getAllTagGroups()` | `repository.getAllTagGroups()` |
| `getMatches()` | `repository.getMatches()` |
| `getBadges()` | `repository.getBadges()` |
| `signInWithApple()` | `repository.signInWithApple()` |
| `blockProfile()` | `repository.blockProfile()` |

Deze implementatie biedt dezelfde functionaliteit als de Swift SupabaseManager maar volgt Flutter/Dart best practices! 🚀