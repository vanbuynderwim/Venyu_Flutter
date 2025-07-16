class SupabaseException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const SupabaseException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    return 'SupabaseException: $message ${code != null ? '(Code: $code)' : ''}';
  }
}

class AuthException extends SupabaseException {
  const AuthException(super.message, {super.code, super.originalError});
}

class NetworkException extends SupabaseException {
  const NetworkException(super.message, {super.code, super.originalError});
}

class ValidationException extends SupabaseException {
  const ValidationException(super.message, {super.code, super.originalError});
}