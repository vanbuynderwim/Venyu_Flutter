import 'enums/venue_type.dart';
import 'enums/venue_role.dart';

/// Represents a venue for networking events or organizations.
/// 
/// A venue can be either a temporary event (conferences, meetups) or
/// a permanent organization (companies, associations). Venues serve as
/// networking hubs where users can connect and interact based on shared
/// contexts or interests.
/// 
/// Each venue includes the user's role (member or admin) which determines
/// their permissions within that venue, such as managing venue settings
/// or inviting other users.
/// 
/// The venue model contains basic information and supports JSON serialization
/// for API communication with the Supabase database.
/// 
/// Example usage:
/// ```dart
/// // Create from API response
/// final venue = Venue.fromJson(apiResponse);
/// 
/// // Check venue type and user permissions
/// if (venue.isEvent) {
///   // Handle event venue
/// } else if (venue.isPermanent) {
///   // Handle organization venue
/// }
/// 
/// if (venue.isUserAdmin) {
///   // Show admin controls
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

  /// User's role within this venue (member or admin).
  final VenueRole role;

  /// Detailed description about the venue (optional).
  final String? about;

  /// Website URL of the venue (optional).
  final String? website;

  /// Number of active profiles/members in the venue (optional).
  /// This is populated when fetching detailed venue information.
  final int? profileCount;

  /// Number of prompts associated with the venue (optional).
  /// This is populated when fetching detailed venue information.
  final int? promptCount;

  /// Number of matches in the venue (optional).
  /// This is populated when fetching detailed venue information.
  final int? matchCount;

  /// Number of connections in the venue (optional).
  /// This is populated when fetching detailed venue information.
  final int? connectionCount;

  /// Start date for the venue (for events only).
  final DateTime? startsAt;

  /// Expiration date for the venue (for events only).
  final DateTime? expiresAt;

  /// Event date (for events only).
  final DateTime? eventDate;

  /// Event hour/time (for events only).
  final DateTime? eventHour;

  /// Event location (for events only).
  final String? eventLocation;

  /// Creates a [Venue] instance.
  /// 
  /// [id], [name], [baseline], [avatarId], [type], and [role] are required.
  const Venue({
    required this.id,
    required this.name,
    required this.baseline,
    required this.avatarId,
    required this.type,
    required this.role,
    this.about,
    this.website,
    this.profileCount,
    this.promptCount,
    this.matchCount,
    this.connectionCount,
    this.startsAt,
    this.expiresAt,
    this.eventDate,
    this.eventHour,
    this.eventLocation,
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
      role: VenueRole.fromJson(json['role'] ?? 'member'),
      about: json['about'] as String?,
      website: json['website'] as String?,
      profileCount: json['profile_count'] != null 
          ? (json['profile_count'] as num).toInt() 
          : null,
      promptCount: json['prompt_count'] != null 
          ? (json['prompt_count'] as num).toInt() 
          : null,
      matchCount: json['match_count'] != null 
          ? (json['match_count'] as num).toInt() 
          : null,
      connectionCount: json['connection_count'] != null 
          ? (json['connection_count'] as num).toInt() 
          : null,
      startsAt: json['starts_at'] != null && json['starts_at'] is String
          ? DateTime.parse(json['starts_at']) 
          : null,
      expiresAt: json['expires_at'] != null && json['expires_at'] is String
          ? DateTime.parse(json['expires_at']) 
          : null,
      eventDate: json['event_date'] != null && json['event_date'] is String
          ? DateTime.parse(json['event_date']) 
          : null,
      eventHour: json['event_hour'] != null && json['event_hour'] is String
          ? DateTime.parse('2000-01-01 ${json['event_hour']}') 
          : null,
      eventLocation: json['event_location'] as String?,
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
      'role': role.toJson(),
      'about': about,
      'website': website,
      if (profileCount != null) 'profile_count': profileCount,
      if (promptCount != null) 'prompt_count': promptCount,
      if (matchCount != null) 'match_count': matchCount,
      if (connectionCount != null) 'connection_count': connectionCount,
      if (startsAt != null) 'starts_at': startsAt!.toIso8601String(),
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
      if (eventDate != null) 'event_date': eventDate!.toIso8601String(),
      if (eventHour != null) 'event_hour': '${eventHour!.hour.toString().padLeft(2, '0')}:${eventHour!.minute.toString().padLeft(2, '0')}:00',
      if (eventLocation != null) 'event_location': eventLocation,
    };
  }

  /// Returns whether this venue is a permanent organization.
  bool get isPermanent => type == VenueType.organisation;

  /// Returns whether this venue is a temporary event.
  bool get isEvent => type == VenueType.event;

  /// Returns whether the user is an admin of this venue.
  bool get isUserAdmin => role == VenueRole.admin;

  /// Returns whether the user is a member of this venue.
  bool get isUserMember => role == VenueRole.member;

  /// Returns whether the user can manage this venue.
  bool get canUserManageVenue => role.canManageVenue;

  /// Returns whether the user can invite others to this venue.
  bool get canUserInviteUsers => role.canInviteUsers;

  /// Creates a copy of this venue with updated fields.
  Venue copyWith({
    String? id,
    String? name,
    String? baseline,
    String? avatarId,
    VenueType? type,
    VenueRole? role,
    String? about,
    String? website,
    int? profileCount,
    int? promptCount,
    int? matchCount,
    int? connectionCount,
    DateTime? startsAt,
    DateTime? expiresAt,
    DateTime? eventDate,
    DateTime? eventHour,
    String? eventLocation,
  }) {
    return Venue(
      id: id ?? this.id,
      name: name ?? this.name,
      baseline: baseline ?? this.baseline,
      avatarId: avatarId ?? this.avatarId,
      type: type ?? this.type,
      role: role ?? this.role,
      about: about ?? this.about,
      website: website ?? this.website,
      profileCount: profileCount ?? this.profileCount,
      promptCount: promptCount ?? this.promptCount,
      matchCount: matchCount ?? this.matchCount,
      connectionCount: connectionCount ?? this.connectionCount,
      startsAt: startsAt ?? this.startsAt,
      expiresAt: expiresAt ?? this.expiresAt,
      eventDate: eventDate ?? this.eventDate,
      eventHour: eventHour ?? this.eventHour,
      eventLocation: eventLocation ?? this.eventLocation,
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
    return 'Venue(id: $id, name: $name, type: ${type.displayName}, role: ${role.displayName})';
  }
}