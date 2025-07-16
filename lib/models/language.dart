class Language {
  final String code;

  const Language({
    required this.code,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
    };
  }

  // Helper methods
  String get displayName {
    switch (code) {
      case 'en':
        return 'English';
      case 'nl':
        return 'Nederlands';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'es':
        return 'Español';
      default:
        return code.toUpperCase();
    }
  }
}