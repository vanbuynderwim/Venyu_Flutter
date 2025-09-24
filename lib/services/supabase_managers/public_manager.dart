import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/app_logger.dart';
import 'base_supabase_manager.dart';

/// PublicManager - Handles all public/anonymous operations
///
/// This manager is responsible for operations that don't require authentication:
/// - Waitlist registration
/// - Public content access
/// - Newsletter signups (future)
/// - Contact forms (future)
///
/// All methods in this manager use executeAnonymousRequest to ensure
/// they work without authentication requirements.
class PublicManager extends BaseSupabaseManager {
  static PublicManager? _instance;

  /// The singleton instance of [PublicManager].
  static PublicManager get shared {
    _instance ??= PublicManager._internal();
    return _instance!;
  }

  /// Private constructor for singleton pattern.
  PublicManager._internal();

  // MARK: - Waitlist Management

  /// Join the waitlist with name, company, and email.
  ///
  /// This is an anonymous function that doesn't require authentication.
  /// Calls the venyu_api_v1.join_waitlist database function.
  ///
  /// Parameters:
  /// - [name]: The user's full name
  /// - [company]: The user's company name
  /// - [email]: The user's email address
  ///
  /// Throws:
  /// - [PostgrestException] if the database operation fails
  /// - Various validation errors from the database function
  Future<void> joinWaitlist({
    required String name,
    required String company,
    required String email,
  }) async {
    return executeAnonymousRequest(() async {
      AppLogger.info('Attempting to join waitlist', context: 'PublicManager');

      // Validate inputs locally first
      if (name.trim().isEmpty) {
        throw const PostgrestException(
          message: 'Name cannot be empty',
          code: 'validation_error',
        );
      }

      if (company.trim().isEmpty) {
        throw const PostgrestException(
          message: 'Company cannot be empty',
          code: 'validation_error',
        );
      }

      if (email.trim().isEmpty) {
        throw const PostgrestException(
          message: 'Email cannot be empty',
          code: 'validation_error',
        );
      }

      // Basic email validation
      final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.\w+$');
      if (!emailRegex.hasMatch(email.trim())) {
        throw const PostgrestException(
          message: 'Invalid email format',
          code: 'validation_error',
        );
      }

      try {
        // Call the database function
        await client.rpc(
          'join_waitlist',
          params: {
            'payload': {
              'name': name.trim(),
              'company': company.trim(),
              'email': email.trim().toLowerCase(),
            },
          },
        );

        AppLogger.success('Successfully joined waitlist for: ${email.trim()}', context: 'PublicManager');
      } catch (error) {
        // Log the error but let executeAnonymousRequest handle it
        AppLogger.error('Failed to join waitlist', error: error, context: 'PublicManager');

        // If it's already a PostgrestException, rethrow as-is
        if (error is PostgrestException) {
          rethrow;
        }

        // Otherwise wrap it
        throw PostgrestException(
          message: 'Failed to join waitlist: ${error.toString()}',
          code: 'unknown_error',
        );
      }
    });
  }

  // MARK: - Future Public Functions

  // Future methods for public operations can be added here:
  // - checkWaitlistStatus(email: String)
  // - subscribeNewsletter(email: String)
  // - submitContactForm(name: String, email: String, message: String)
  // - getPublicStats()
  // - getPublicContent()
}