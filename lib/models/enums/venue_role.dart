/// Defines the roles users can have within a venue.
/// 
/// This enum represents different permission levels and responsibilities
/// that users can have in venues such as events or organizations.
/// Each role has specific capabilities and access levels.
/// 
/// Example usage:
/// ```dart
/// final userRole = VenueRole.admin;
/// print(userRole.displayName); // "Admin"
/// print(userRole.canManageVenue); // true
/// 
/// // Parse from API response
/// final role = VenueRole.fromJson('member');
/// ```
enum VenueRole {
  /// Standard member with basic access and participation rights.
  member('member'),
  
  /// Administrator with full management and configuration rights.
  admin('admin');

  const VenueRole(this.value);
  
  final String value;

  /// Creates a [VenueRole] from a JSON string value.
  /// 
  /// Returns [VenueRole.member] if the value doesn't match any role.
  static VenueRole fromJson(String value) {
    return VenueRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => VenueRole.member,
    );
  }

  /// Converts this [VenueRole] to a JSON string value.
  String toJson() => value;

  /// Returns the user-facing display name for this venue role.
  String get displayName {
    switch (this) {
      case VenueRole.member:
        return 'Member';
      case VenueRole.admin:
        return 'Admin';
    }
  }

  /// Returns a description of this venue role's responsibilities.
  String get description {
    switch (this) {
      case VenueRole.member:
        return 'Standard member with basic access rights';
      case VenueRole.admin:
        return 'Administrator with full management rights';
    }
  }

  /// Returns whether this role can manage venue settings.
  bool get canManageVenue {
    switch (this) {
      case VenueRole.member:
        return false;
      case VenueRole.admin:
        return true;
    }
  }

  /// Returns whether this role can invite other users to the venue.
  bool get canInviteUsers {
    switch (this) {
      case VenueRole.member:
        return false;
      case VenueRole.admin:
        return true;
    }
  }

  /// Returns whether this role can manage other members.
  bool get canManageMembers {
    switch (this) {
      case VenueRole.member:
        return false;
      case VenueRole.admin:
        return true;
    }
  }

  /// Returns whether this role has administrative privileges.
  bool get isAdmin => this == VenueRole.admin;

  /// Returns whether this role is a basic member.
  bool get isMember => this == VenueRole.member;
}