import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/toast_service.dart';
import '../utils/app_logger.dart';

/// Helper class for URL launching operations
/// 
/// Provides centralized methods for opening external URLs, composing emails,
/// and opening social media profiles. All methods include proper error handling
/// and user feedback via ToastService.
class UrlHelper {
  /// Opens a website URL in the external browser
  /// 
  /// Automatically adds https:// prefix if no protocol is specified.
  /// Shows error toast if URL cannot be opened.
  static Future<void> openWebsite(BuildContext context, String websiteUrl) async {
    try {
      // Ensure URL has a protocol
      String url = websiteUrl;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$websiteUrl';
      }
      
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ToastService.error(
            context: context,
            message: 'Could not open website',
          );
        }
      }
    } catch (e) {
      AppLogger.error('Failed to open website', error: e, context: 'UrlHelper');
      if (context.mounted) {
        ToastService.error(
          context: context,
          message: 'Could not open website',
        );
      }
    }
  }

  /// Opens LinkedIn profile URL
  /// 
  /// Shows error toast if LinkedIn cannot be opened.
  static Future<void> openLinkedIn(BuildContext context, String linkedInUrl) async {
    try {
      final uri = Uri.parse(linkedInUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ToastService.error(
            context: context,
            message: 'Could not open LinkedIn profile',
          );
        }
      }
    } catch (e) {
      AppLogger.error('Failed to open LinkedIn', error: e, context: 'UrlHelper');
      if (context.mounted) {
        ToastService.error(
          context: context,
          message: 'Could not open LinkedIn profile',
        );
      }
    }
  }

  /// Composes an email with optional subject and body
  ///
  /// Opens the default email client with pre-filled fields.
  /// Shows error toast if email client cannot be opened.
  static Future<void> composeEmail(
    BuildContext context,
    String emailAddress, {
    String? subject,
    String? body,
  }) async {
    try {
      // Build mailto URL manually to avoid + encoding issues
      // Uri.queryParameters encodes spaces as +, but for mailto we want %20
      String mailtoUrl = 'mailto:$emailAddress';

      final queryParams = <String>[];
      if (subject != null) {
        queryParams.add('subject=${Uri.encodeComponent(subject)}');
      }
      if (body != null) {
        queryParams.add('body=${Uri.encodeComponent(body)}');
      }

      if (queryParams.isNotEmpty) {
        mailtoUrl += '?${queryParams.join('&')}';
      }

      // Replace + with %20 for proper space encoding in mailto URLs
      mailtoUrl = mailtoUrl.replaceAll('+', '%20');

      final emailUri = Uri.parse(mailtoUrl);

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          ToastService.error(
            context: context,
            message: 'Could not open email app',
          );
        }
      }
    } catch (e) {
      AppLogger.error('Failed to compose email', error: e, context: 'UrlHelper');
      if (context.mounted) {
        ToastService.error(
          context: context,
          message: 'Could not open email app',
        );
      }
    }
  }

  /// Opens a phone number for calling
  /// 
  /// Shows error toast if phone app cannot be opened.
  static Future<void> callPhone(BuildContext context, String phoneNumber) async {
    try {
      final telUri = Uri(scheme: 'tel', path: phoneNumber);
      
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        if (context.mounted) {
          ToastService.error(
            context: context,
            message: 'Could not open phone app',
          );
        }
      }
    } catch (e) {
      AppLogger.error('Failed to open phone', error: e, context: 'UrlHelper');
      if (context.mounted) {
        ToastService.error(
          context: context,
          message: 'Could not open phone app',
        );
      }
    }
  }

  /// Opens a location in maps app
  /// 
  /// Can handle addresses or coordinates.
  /// Shows error toast if maps app cannot be opened.
  static Future<void> openMaps(BuildContext context, String location) async {
    try {
      // Try Apple Maps first on iOS, Google Maps on Android
      final encodedLocation = Uri.encodeComponent(location);
      final googleMapsUri = Uri.parse('https://maps.google.com/?q=$encodedLocation');
      
      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ToastService.error(
            context: context,
            message: 'Could not open maps',
          );
        }
      }
    } catch (e) {
      AppLogger.error('Failed to open maps', error: e, context: 'UrlHelper');
      if (context.mounted) {
        ToastService.error(
          context: context,
          message: 'Could not open maps',
        );
      }
    }
  }
}