import 'tag_group.dart';
import 'tag.dart';

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

  /// User's city location.
  final String? city;

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

  /// When the user redeemed their invite code.
  /// Null indicates no invite code has been redeemed yet.
  final DateTime? redeemedAt;
  
  /// Distance to this profile (in location-based queries).
  /// Used for proximity-based matching and networking.
  final double? distance;
  
  /// Whether this user has super admin privileges.
  final bool isSuperAdmin;
  
  /// Whether the user has subscribed to newsletters.
  final bool? newsletterSubscribed;
  
  /// Whether the user has an active pro subscription.
  final bool isPro;
  
  /// Whether the user has reached the connections limit (for non-Pro users).
  final bool connectionsLimitReached;
  
  /// Public key for secure communications.
  final String? publicKey;

  /// List of tag groups associated with this profile.
  /// Contains categorized tags like roles, sectors, etc.
  final List<TagGroup>? taggroups;

  /// Creates a [Profile] instance.
  /// 
  /// [id] and [firstName] are required. [isSuperAdmin] and [isPro] default to false
  /// if not explicitly provided during JSON deserialization.
  const Profile({
    required this.id,
    required this.firstName,
    this.lastName,
    this.companyName,
    this.city,
    this.bio,
    this.linkedInURL,
    this.websiteURL,
    this.contactEmail,
    this.showEmail,
    this.avatarID,
    this.timestamp,
    this.registeredAt,
    this.redeemedAt,
    this.distance,
    required this.isSuperAdmin,
    this.newsletterSubscribed,
    required this.isPro,
    required this.connectionsLimitReached,
    this.publicKey,
    this.taggroups,
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
      city: json['city'] as String?,
      bio: json['bio'] as String?,
      linkedInURL: json['linkedin_url'] as String?,
      websiteURL: json['website_url'] as String?,
      contactEmail: json['contact_email'] as String?,
      showEmail: json['show_email'] as bool?,
      avatarID: json['avatar_id'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      registeredAt: json['registered_at'] != null ? DateTime.parse(json['registered_at']) : null,
      redeemedAt: json['redeemed_at'] != null ? DateTime.parse(json['redeemed_at']) : null,
      distance: json['distance']?.toDouble(),
      isSuperAdmin: json['is_super_admin'] as bool? ?? false,
      newsletterSubscribed: json['newsletter_subscribed'] as bool?,
      isPro: json['is_pro'] as bool? ?? false,
      connectionsLimitReached: json['connections_limit_reached'] as bool? ?? false,
      publicKey: json['public_key'] as String?,
      taggroups: json['taggroups'] != null 
          ? (json['taggroups'] as List).map((tagGroup) => TagGroup.fromJson(tagGroup)).toList()
          : null,
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
      'city': city,
      'bio': bio,
      'linkedin_url': linkedInURL,
      'website_url': websiteURL,
      'contact_email': contactEmail,
      'show_email': showEmail,
      'avatar_id': avatarID,
      'timestamp': timestamp?.toIso8601String(),
      'registered_at': registeredAt?.toIso8601String(),
      'redeemed_at': redeemedAt?.toIso8601String(),
      'distance': distance,
      'is_super_admin': isSuperAdmin,
      'newsletter_subscribed': newsletterSubscribed,
      'is_pro': isPro,
      'connections_limit_reached': connectionsLimitReached,
      'public_key': publicKey,
      'taggroups': taggroups?.map((tagGroup) => tagGroup.toJson()).toList(),
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

  /// Helper function to get tags for a specific category.
  /// 
  /// Searches through [taggroups] to find a group matching the given [categoryCode]
  /// and returns its associated tags. Returns empty list if no matching group is found.
  List<Tag> _getTagsForCategory(String categoryCode) {
    if (taggroups == null) return [];
    
    final tagGroup = taggroups!.cast<TagGroup?>().firstWhere(
      (group) => group?.code == categoryCode,
      orElse: () => null,
    );
    
    return tagGroup?.tags ?? [];
  }

  /// Gets all role tags for this profile.
  /// 
  /// Roles represent the user's professional positions or job titles.
  /// Used for profile display and networking matching.
  List<Tag> get roles => _getTagsForCategory('roles');

  /// Gets all sector tags for this profile.
  /// 
  /// Sectors represent the industries or business areas the user is involved in.
  /// Used for categorization and discovery features.
  List<Tag> get sectors => _getTagsForCategory('sectors');

  /// Gets all meeting preference tags for this profile.
  /// 
  /// Meeting preferences indicate how the user prefers to connect with others.
  /// Examples: "In-person", "Virtual", "Coffee meetings", etc.
  List<Tag> get meetingPreferences => _getTagsForCategory('meetingPreferences');

  /// Gets all network goal tags for this profile.
  /// 
  /// Network goals represent what the user hopes to achieve through networking.
  /// Examples: "Find mentors", "Build partnerships", "Career growth", etc.
  List<Tag> get networkGoals => _getTagsForCategory('networkGoals');

  /// Gets the formatted role string combining roles and company information.
  /// 
  /// This computed property matches the iOS implementation and combines:
  /// - Role titles from the roles tag group
  /// - Company name if available
  /// 
  /// Returns formatted strings like:
  /// - "Developer, Designer at Acme Corp" (roles + company)
  /// - "Developer, Designer" (roles only)  
  /// - "at Acme Corp" (company only)
  /// - "" (empty if neither)
  String get role {
    // Get role titles from roles list
    final roleLabels = roles.isNotEmpty
        ? roles.map((role) => role.label).toList()
        : <String>[];
    final rolesString = roleLabels.join(', ');
    
    final hasRoles = rolesString.isNotEmpty;
    final hasCompany = companyName?.isNotEmpty == true;
    
    if (hasRoles && hasCompany) {
      return '$rolesString at $companyName';
    } else if (hasRoles && !hasCompany) {
      return rolesString;
    } else if (!hasRoles && hasCompany) {
      return 'at $companyName';
    } else {
      return '';
    }
  }

  /// Gets the formatted distance string.
  /// 
  /// Returns a formatted distance string like:
  /// - "1.2 km" for distances >= 1 km
  /// - "500 m" for distances < 1 km
  /// - null if distance is not available
  String? get formattedDistance {
    if (distance == null) return null;
    
    final distanceInKm = distance!;
    
    if (distanceInKm >= 1) {
      return '${distanceInKm.toStringAsFixed(1)} km';
    } else {
      final distanceInM = (distanceInKm * 1000).round();
      return '$distanceInM m';
    }
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
    String? city,
    String? bio,
    String? linkedInURL,
    String? websiteURL,
    String? contactEmail,
    bool? showEmail,
    String? avatarID,
    DateTime? timestamp,
    DateTime? registeredAt,
    DateTime? redeemedAt,
    double? distance,
    bool? isSuperAdmin,
    bool? newsletterSubscribed,
    bool? isPro,
    bool? connectionsLimitReached,
    String? publicKey,
    List<TagGroup>? taggroups,
  }) {
    return Profile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      companyName: companyName ?? this.companyName,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      linkedInURL: linkedInURL ?? this.linkedInURL,
      websiteURL: websiteURL ?? this.websiteURL,
      contactEmail: contactEmail ?? this.contactEmail,
      showEmail: showEmail ?? this.showEmail,
      avatarID: avatarID ?? this.avatarID,
      timestamp: timestamp ?? this.timestamp,
      registeredAt: registeredAt ?? this.registeredAt,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      distance: distance ?? this.distance,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      newsletterSubscribed: newsletterSubscribed ?? this.newsletterSubscribed,
      isPro: isPro ?? this.isPro,
      connectionsLimitReached: connectionsLimitReached ?? this.connectionsLimitReached,
      publicKey: publicKey ?? this.publicKey,
      taggroups: taggroups ?? this.taggroups,
    );
  }
}