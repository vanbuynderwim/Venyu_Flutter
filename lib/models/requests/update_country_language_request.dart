/// UpdateCountryAndLanguageRequest - Request model for profile RPC calls
/// 
/// This model matches the iOS UpdateCountryAndLanguageRequest structure
/// and is used to pass device information when fetching user profiles.
class UpdateCountryAndLanguageRequest {
  final String countryCode;
  final String languageCode;
  final String appVersion;

  const UpdateCountryAndLanguageRequest({
    required this.countryCode,
    required this.languageCode,
    required this.appVersion,
  });

  /// Convert to JSON for RPC call
  Map<String, dynamic> toJson() {
    return {
      'country_code': countryCode,
      'language_code': languageCode,
      'app_version': appVersion,
    };
  }

  /// Create from JSON (if needed for deserialization)
  factory UpdateCountryAndLanguageRequest.fromJson(Map<String, dynamic> json) {
    return UpdateCountryAndLanguageRequest(
      countryCode: json['countryCode'] as String,
      languageCode: json['languageCode'] as String,
      appVersion: json['appVersion'] as String,
    );
  }

  @override
  String toString() {
    return 'UpdateCountryAndLanguageRequest(countryCode: $countryCode, languageCode: $languageCode, appVersion: $appVersion)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateCountryAndLanguageRequest &&
        other.countryCode == countryCode &&
        other.languageCode == languageCode &&
        other.appVersion == appVersion;
  }

  @override
  int get hashCode {
    return countryCode.hashCode ^ 
           languageCode.hashCode ^ 
           appVersion.hashCode;
  }
}