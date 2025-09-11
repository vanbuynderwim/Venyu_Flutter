/// Defines the types of venues available in the platform.
/// 
/// This enum represents different types of venues that can be created
/// and managed within the networking platform. Each venue type serves
/// a specific purpose for organizing connections and interactions.
/// 
/// Example usage:
/// ```dart
/// final venueType = VenueType.event;
/// print(venueType.displayName); // "Event"
/// 
/// // Parse from API response
/// final type = VenueType.fromJson('organisation');
/// ```
enum VenueType {
  /// A temporary venue for events, conferences, or meetups.
  event('event'),
  
  /// A permanent venue representing a company or organization.
  organisation('organisation');

  const VenueType(this.value);
  
  final String value;

  /// Creates a [VenueType] from a JSON string value.
  /// 
  /// Returns [VenueType.event] if the value doesn't match any type.
  static VenueType fromJson(String value) {
    return VenueType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => VenueType.event,
    );
  }

  /// Converts this [VenueType] to a JSON string value.
  String toJson() => value;

  /// Returns the user-facing display name for this venue type.
  String get displayName {
    switch (this) {
      case VenueType.event:
        return 'Event';
      case VenueType.organisation:
        return 'Community';
    }
  }

  /// Returns a description of this venue type.
  String get description {
    switch (this) {
      case VenueType.event:
        return 'Temporary venue for events, conferences, or meetups';
      case VenueType.organisation:
        return 'Permanent venue for companies or organizations';
    }
  }

  /// Returns whether this venue type has an expiration date.
  bool get hasExpiration {
    switch (this) {
      case VenueType.event:
        return true;
      case VenueType.organisation:
        return false;
    }
  }

  /// Returns the icon name for this venue type.
  /// 
  /// Used to display the appropriate icon in the UI.
  /// - Event: 'event' icon
  /// - Organisation: 'venue' icon
  String get icon {
    switch (this) {
      case VenueType.event:
        return 'event';
      case VenueType.organisation:
        return 'venue';
    }
  }

  /// Returns a unique identifier for this venue type.
  /// 
  /// Used by TagView component to uniquely identify the tag.
  String get id {
    return value; // Returns 'event' or 'organisation'
  }
}