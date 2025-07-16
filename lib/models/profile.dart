class Profile {
  final String id;
  final String firstName;
  final String? lastName;
  final String? companyName;
  final String? bio;
  final String? linkedInURL;
  final String? websiteURL;
  final String? contactEmail;
  final bool? showEmail;
  final String? avatarID;
  final DateTime? timestamp;
  final DateTime? registeredAt;
  final double? distance;
  final bool isSuperAdmin;
  final bool? newsletterSubscribed;
  final String? publicKey;

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

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      companyName: json['company_name'] as String?,
      bio: json['bio'] as String?,
      linkedInURL: json['linked_in_url'] as String?,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'company_name': companyName,
      'bio': bio,
      'linked_in_url': linkedInURL,
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

  // Helper methods
  String get fullName {
    if (lastName != null && lastName!.isNotEmpty) {
      return '$firstName $lastName';
    }
    return firstName;
  }

  String get displayName {
    if (companyName != null && companyName!.isNotEmpty) {
      return '$fullName - $companyName';
    }
    return fullName;
  }
}