/// Model representing an app version from the server
class AppVersion {
  final int version;
  final int major;
  final int minor;
  final String? content;

  const AppVersion({
    required this.version,
    required this.major,
    required this.minor,
    this.content,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      version: json['version'] as int,
      major: json['major'] as int,
      minor: json['minor'] as int,
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'major': major,
      'minor': minor,
      'content': content,
    };
  }

  @override
  String toString() => '$version.$major.$minor';
}
