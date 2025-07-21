/// App URLs - Centralized URL constants for external services and APIs
/// 
/// This class contains all URL constants for consistency and
/// easy maintenance of external service endpoints.
class AppUrls {
  AppUrls._();

  /// External service base URLs
  static const String placeholderImageBase = 'https://via.placeholder.com';
  static const String gravatarBase = 'https://www.gravatar.com/avatar';
  
  /// AWS S3 buckets
  static const String avatarBucket = 'https://venyu-avatars.s3.amazonaws.com';
  static const String documentsBucket = 'https://venyu-documents.s3.amazonaws.com';
  static const String imagesBucket = 'https://venyu-images.s3.amazonaws.com';

  /// Social media URLs
  static const String linkedInBase = 'https://www.linkedin.com';
  static const String twitterBase = 'https://twitter.com';
  static const String facebookBase = 'https://www.facebook.com';

  /// Helper methods for building URLs
  
  /// Generate a placeholder icon URL with customizable parameters
  static String placeholderIcon({
    required String text,
    int size = 64,
    String backgroundColor = '007AFF',
    String textColor = 'FFFFFF',
  }) {
    return '$placeholderImageBase/$size/$backgroundColor/$textColor?text=$text';
  }

  /// Generate an avatar URL from S3 bucket
  static String avatarUrl(String avatarId, {String extension = 'jpg'}) {
    return '$avatarBucket/$avatarId.$extension';
  }

  /// Generate a document URL from S3 bucket
  static String documentUrl(String documentId, {String extension = 'pdf'}) {
    return '$documentsBucket/$documentId.$extension';
  }

  /// Generate an image URL from S3 bucket
  static String imageUrl(String imageId, {String extension = 'jpg'}) {
    return '$imagesBucket/$imageId.$extension';
  }

  /// Generate a Gravatar URL from email
  static String gravatarUrl(String email, {int size = 200}) {
    final emailHash = email.toLowerCase().trim(); // In real app, use crypto hash
    return '$gravatarBase/$emailHash?s=$size&d=identicon';
  }

  /// Generate LinkedIn profile URL
  static String linkedInProfile(String username) {
    return '$linkedInBase/in/$username';
  }

  /// Generate Twitter profile URL  
  static String twitterProfile(String username) {
    return '$twitterBase/$username';
  }

  /// Generate Facebook profile URL
  static String facebookProfile(String username) {
    return '$facebookBase/$username';
  }

  /// Validate URL format
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}