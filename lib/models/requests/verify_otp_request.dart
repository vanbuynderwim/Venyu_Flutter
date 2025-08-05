/// Request model for verifying OTP codes sent to email addresses.
/// 
/// This model is used when verifying the OTP code sent to a user's email
/// address during email verification process. It includes the email,
/// verification code, and newsletter subscription preference.
class VerifyOTPRequest {
  /// The email address to verify
  final String email;
  
  /// The 6-digit OTP code sent to the email
  final String code;
  
  /// Whether the user wants to subscribe to the newsletter
  final bool subscribed;

  const VerifyOTPRequest({
    required this.email,
    required this.code,
    this.subscribed = false,
  });

  /// Convert the request to JSON for API calls
  Map<String, dynamic> toJson() => {
    'email': email,
    'code': code,
    'subscribed': subscribed,
  };

  /// Create request from JSON response
  factory VerifyOTPRequest.fromJson(Map<String, dynamic> json) => VerifyOTPRequest(
    email: json['email'] ?? '',
    code: json['code'] ?? '',
    subscribed: json['subscribed'] ?? false,
  );

  @override
  String toString() => 'VerifyOTPRequest(email: $email, code: $code, subscribed: $subscribed)';
}