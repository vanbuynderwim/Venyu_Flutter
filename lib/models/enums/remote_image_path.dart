enum RemoteImagePath {
  avatars('avatars'),
  venues('venues'),
  icons('icons');

  const RemoteImagePath(this.value);
  
  final String value;

  static RemoteImagePath fromJson(String value) {
    return RemoteImagePath.values.firstWhere(
      (path) => path.value == value,
      orElse: () => RemoteImagePath.avatars,
    );
  }

  String toJson() => value;

  // Helper methods
  String get basePath {
    switch (this) {
      case RemoteImagePath.avatars:
        return '/storage/v1/object/public/avatars/';
      case RemoteImagePath.venues:
        return '/storage/v1/object/public/venues/';
      case RemoteImagePath.icons:
        return '/storage/v1/object/public/icons/';
    }
  }

  String buildUrl(String baseUrl, String filename) {
    return '$baseUrl$basePath$filename';
  }
}