/// Represents a user profile with personal and professional information.
/// 
/// This model contains all user data including basic information, social links,
/// contact details, and system metadata. It supports both authenticated users
/// and public profile views with distance calculations for location-based features.
/// 
/// The profile data is synchronized with the Supabase database and includes
/// JSON serialization for API communication.
/// 
/// Example usage:
/// ```dart
/// // Create from API response
/// final profile = Profile.fromJson(apiResponse);
/// 
/// // Access computed properties
/// print(profile.displayName); // "John Doe - Acme Corp"
/// print(profile.fullName);    // "John Doe"
/// 
/// // Convert for API request
/// final json = profile.toJson();
/// ```
class Profile {
  /// Unique identifier for this profile.
  final String id;
  
  /// User's first name (required).
  final String firstName;
  
  /// User's last name (optional).
  final String? lastName;
  
  /// Name of the user's company or organization.
  final String? companyName;
  
  /// User's biography or professional description.
  final String? bio;
  
  /// LinkedIn profile URL for professional networking.
  final String? linkedInURL;
  
  /// Personal or company website URL.
  final String? websiteURL;
  
  /// Email address for contact purposes.
  final String? contactEmail;
  
  /// Whether the email address should be publicly visible.
  final bool? showEmail;
  
  /// Identifier for the user's profile avatar image.
  final String? avatarID;
  
  /// When this profile record was last updated.
  final DateTime? timestamp;
  
  /// When the user completed the registration process.
  /// Null indicates an incomplete registration.
  final DateTime? registeredAt;
  
  /// Distance to this profile (in location-based queries).
  /// Used for proximity-based matching and networking.
  final double? distance;
  
  /// Whether this user has super admin privileges.
  final bool isSuperAdmin;
  
  /// Whether the user has subscribed to newsletters.
  final bool? newsletterSubscribed;
  
  /// Public key for secure communications.
  final String? publicKey;

  /// Creates a [Profile] instance.
  /// 
  /// [id] and [firstName] are required. [isSuperAdmin] defaults to false
  /// if not explicitly provided during JSON deserialization.
  const Profile({
    required this.id,
    required this.firstName,
    this.lastName,
    this.companyName,
    this.bio,
    this.linkedInURL,
    this.websiteURL,
    this.contactEmail,
    this.showEmail,
    this.avatarID,
    this.timestamp,
    this.registeredAt,
    this.distance,
    required this.isSuperAdmin,
    this.newsletterSubscribed,
    this.publicKey,
  });

  /// Creates a [Profile] from a JSON object.
  /// 
  /// Handles database field name mapping and type conversions.
  /// Missing or null values are handled gracefully with appropriate defaults.
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      companyName: json['company_name'] as String?,
      bio: json['bio'] as String?,
      linkedInURL: json['linkedin_url'] as String?,
      websiteURL: json['website_url'] as String?,
      contactEmail: json['contact_email'] as String?,
      showEmail: json['show_email'] as bool?,
      avatarID: json['avatar_id'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      registeredAt: json['registered_at'] != null ? DateTime.parse(json['registered_at']) : null,
      distance: json['distance']?.toDouble(),
      isSuperAdmin: json['is_super_admin'] as bool? ?? false,
      newsletterSubscribed: json['newsletter_subscribed'] as bool?,
      publicKey: json['public_key'] as String?,
    );
  }

  /// Converts this [Profile] to a JSON object.
  /// 
  /// Maps Dart property names to database field names and handles
  /// proper serialization of DateTime objects and null values.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'company_name': companyName,
      'bio': bio,
      'linkedin_url': linkedInURL,
      'website_url': websiteURL,
      'contact_email': contactEmail,
      'show_email': showEmail,
      'avatar_id': avatarID,
      'timestamp': timestamp?.toIso8601String(),
      'registered_at': registeredAt?.toIso8601String(),
      'distance': distance,
      'is_super_admin': isSuperAdmin,
      'newsletter_subscribed': newsletterSubscribed,
      'public_key': publicKey,
    };
  }

  /// Returns the user's full name combining first and last names.
  /// 
  /// If [lastName] is null or empty, returns only [firstName].
  /// 
  /// Example:
  /// ```dart
  /// // With last name: "John Doe"
  /// // Without last name: "John"
  /// ```
  String get fullName {
    if (lastName != null && lastName!.isNotEmpty) {
      return '$firstName $lastName';
    }
    return firstName;
  }

  /// Returns a formatted display name including company information.
  /// 
  /// If [companyName] is available, combines it with [fullName].
  /// Otherwise, returns just [fullName].
  /// 
  /// Example:
  /// ```dart
  /// // With company: "John Doe - Acme Corp"
  /// // Without company: "John Doe"
  /// ```
  String get displayName {
    if (companyName != null && companyName!.isNotEmpty) {
      return '$fullName - $companyName';
    }
    return fullName;
  }

  /// Creates a copy of this profile with the given fields replaced.
  /// 
  /// Useful for updating specific profile fields without mutating the original.
  /// Any null parameter retains the current value.
  Profile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? companyName,
    String? bio,
    String? linkedInURL,
    String? websiteURL,
    String? contactEmail,
    bool? showEmail,
    String? avatarID,
    DateTime? timestamp,
    DateTime? registeredAt,
    double? distance,
    bool? isSuperAdmin,
    bool? newsletterSubscribed,
    String? publicKey,
  }) {
    return Profile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      companyName: companyName ?? this.companyName,
      bio: bio ?? this.bio,
      linkedInURL: linkedInURL ?? this.linkedInURL,
      websiteURL: websiteURL ?? this.websiteURL,
      contactEmail: contactEmail ?? this.contactEmail,
      showEmail: showEmail ?? this.showEmail,
      avatarID: avatarID ?? this.avatarID,
      timestamp: timestamp ?? this.timestamp,
      registeredAt: registeredAt ?? this.registeredAt,
      distance: distance ?? this.distance,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      newsletterSubscribed: newsletterSubscribed ?? this.newsletterSubscribed,
      publicKey: publicKey ?? this.publicKey,
    );
  }
}