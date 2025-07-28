/// Request model for updating profile name and LinkedIn URL
/// Dart equivalent of Swift UpdateNameRequest struct
class UpdateNameRequest {
  final String firstName;
  final String lastName;
  final String linkedInURL;
  final bool linkedInURLValid;

  const UpdateNameRequest({
    required this.firstName,
    required this.lastName,
    required this.linkedInURL,
    required this.linkedInURLValid,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'linkedin_url': linkedInURL,
      'linkedin_url_valid': linkedInURLValid,
    };
  }

  /// Create from JSON
  factory UpdateNameRequest.fromJson(Map<String, dynamic> json) {
    return UpdateNameRequest(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      linkedInURL: json['linkedin_url'] ?? '',
      linkedInURLValid: json['linkedin_url_valid'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UpdateNameRequest(firstName: $firstName, lastName: $lastName, linkedInURL: $linkedInURL, linkedInURLValid: $linkedInURLValid)';
  }
}