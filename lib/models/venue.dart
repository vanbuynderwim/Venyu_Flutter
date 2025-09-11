import 'enums/venue_type.dart';

/// Represents a venue for networking events or organizations.
/// 
/// A venue can be either a temporary event (conferences, meetups) or
/// a permanent organization (companies, associations). Venues serve as
/// networking hubs where users can connect and interact based on shared
/// contexts or interests.
/// 
/// The venue model contains basic information and supports JSON serialization
/// for API communication with the Supabase database.
/// 
/// Example usage:
/// ```dart
/// // Create from API response
/// final venue = Venue.fromJson(apiResponse);
/// 
/// // Check venue type
/// if (venue.isEvent) {
///   // Handle event venue
/// } else if (venue.isPermanent) {
///   // Handle organization venue
/// }
/// 
/// // Convert for API request
/// final json = venue.toJson();
/// ```
class Venue {
  /// Unique identifier for this venue.
  final String id;

  /// Name of the venue (e.g., "Tech Conference 2024", "Startup Hub").
  final String name;

  /// Short descriptive tagline or baseline for the venue.
  final String baseline;

  /// Identifier for the venue's avatar/logo image.
  final String avatarId;

  /// Type of venue (event or organisation).
  final VenueType type;

  /// Detailed description about the venue (optional).
  final String? about;

  /// Number of active profiles/members in the venue (optional).
  /// This is populated when fetching detailed venue information.
  final int? profileCount;

  /// Number of prompts associated with the venue (optional).
  /// This is populated when fetching detailed venue information.
  final int? promptCount;

  /// Creates a [Venue] instance.
  /// 
  /// [id], [name], [baseline], [avatarId], and [type] are required.
  const Venue({
    required this.id,
    required this.name,
    required this.baseline,
    required this.avatarId,
    required this.type,
    this.about,
    this.profileCount,
    this.promptCount,
  });

  /// Creates a [Venue] from a JSON object.
  /// 
  /// Handles database field name mapping and type conversions.
  /// Missing or null values are handled gracefully with appropriate defaults.
  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as String,
      name: json['name'] as String,
      baseline: json['baseline'] as String,
      avatarId: json['avatar_id'] as String,
      type: VenueType.fromJson(json['type'] ?? 'organisation'),
      about: json['about'] as String?,
      profileCount: json['profile_count'] != null 
          ? (json['profile_count'] as num).toInt() 
          : null,
      promptCount: json['prompt_count'] != null 
          ? (json['prompt_count'] as num).toInt() 
          : null,
    );
  }

  /// Converts this [Venue] to a JSON object.
  /// 
  /// Maps Dart property names to database field names and handles
  /// proper serialization of enums.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'baseline': baseline,
      'avatar_id': avatarId,
      'type': type.toJson(),
      'about': about,
      if (profileCount != null) 'profile_count': profileCount,
      if (promptCount != null) 'prompt_count': promptCount,
    };
  }

  /// Returns whether this venue is a permanent organization.
  bool get isPermanent => type == VenueType.organisation;

  /// Returns whether this venue is a temporary event.
  bool get isEvent => type == VenueType.event;

  /// Creates a copy of this venue with updated fields.
  Venue copyWith({
    String? id,
    String? name,
    String? baseline,
    String? avatarId,
    VenueType? type,
    String? about,
    int? profileCount,
    int? promptCount,
  }) {
    return Venue(
      id: id ?? this.id,
      name: name ?? this.name,
      baseline: baseline ?? this.baseline,
      avatarId: avatarId ?? this.avatarId,
      type: type ?? this.type,
      about: about ?? this.about,
      profileCount: profileCount ?? this.profileCount,
      promptCount: promptCount ?? this.promptCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Venue &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Venue(id: $id, name: $name, type: ${type.displayName})';
  }
}