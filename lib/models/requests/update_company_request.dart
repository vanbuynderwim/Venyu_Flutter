/// Request model for updating company name and website URL
/// Flutter equivalent of Swift UpdateCompanyRequest struct
class UpdateCompanyRequest {
  final String companyName;
  final String websiteURL;

  const UpdateCompanyRequest({
    required this.companyName,
    required this.websiteURL,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'website_url': websiteURL,
    };
  }

  /// Create from JSON
  factory UpdateCompanyRequest.fromJson(Map<String, dynamic> json) {
    return UpdateCompanyRequest(
      companyName: json['company_name'] ?? '',
      websiteURL: json['website_url'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UpdateCompanyRequest(companyName: $companyName, websiteURL: $websiteURL)';
  }
}