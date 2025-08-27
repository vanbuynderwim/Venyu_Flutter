import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_strings.dart';
import '../theme/app_text_styles.dart';

/// Centralized utility for creating platform-aware dialogs
class DialogUtils {
  DialogUtils._();

  /// Shows a platform-aware confirmation dialog
  /// Returns true if confirmed, false if cancelled or dismissed
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = AppStrings.delete,
    String cancelText = AppStrings.cancel,
    bool isDestructive = true,
  }) async {
    final result = await showPlatformDialog<bool>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
            cupertino: (_, __) => CupertinoDialogActionData(
              isDestructiveAction: isDestructive,
            ),
            material: (_, __) => MaterialDialogActionData(
              style: TextButton.styleFrom(
                foregroundColor: isDestructive ? Theme.of(context).colorScheme.error : null,
              ),
            ),
          ),
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
            cupertino: (_, __) => CupertinoDialogActionData(
              isDefaultAction: true,
            ),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  /// Shows a confirmation dialog specifically for removing avatar
  /// Returns true if confirmed, false if cancelled or dismissed
  static Future<bool> showRemoveAvatarDialog(BuildContext context) async {
    return showConfirmationDialog(
      context: context,
      title: 'Remove Avatar',
      message: 'Are you sure you want to remove your avatar?',
      confirmText: 'Remove',
      cancelText: 'Cancel',
      isDestructive: true,
    );
  }

  /// Shows a platform-aware information dialog
  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    await showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
            cupertino: (_, __) => CupertinoDialogActionData(
              isDefaultAction: true,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a platform-aware error dialog
  static Future<void> showErrorDialog({
    required BuildContext context,
    String title = 'Error',
    required String message,
    String buttonText = 'OK',
  }) async {
    await showInfoDialog(
      context: context,
      title: title,
      message: message,
      buttonText: buttonText,
    );
  }

  /// Shows a platform-aware choice dialog with custom actions
  static Future<T?> showChoiceDialog<T>({
    required BuildContext context,
    required String title,
    String? message,
    required List<DialogChoice<T>> choices,
  }) async {
    return await showPlatformDialog<T>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text(title),
        content: message != null ? Text(message) : null,
        actions: choices.map((choice) => PlatformDialogAction(
          onPressed: () => Navigator.of(context).pop(choice.value),
          child: Text(choice.label),
          cupertino: (_, __) => CupertinoDialogActionData(
            isDefaultAction: choice.isDefault,
            isDestructiveAction: choice.isDestructive,
          ),
        )).toList(),
      ),
    );
  }

  /// Shows a loading dialog that can be dismissed
  static void showLoadingDialog({
    required BuildContext context,
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlatformCircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: AppTextStyles.subheadline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Dismisses any currently shown dialog
  static void dismissDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Opens device settings for app permissions
  /// This method handles both iOS and Android platforms
  static Future<void> openAppSettings(BuildContext context) async {
    try {
      // For iOS
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        final url = Uri.parse('app-settings:');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      } else {
        // For Android, use package-specific settings
        final url = Uri.parse('package:com.getvenyu.app');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      }
    } catch (error) {
      debugPrint('❌ Error opening app settings: $error');
    }
  }
}

/// Represents a choice in a choice dialog
class DialogChoice<T> {
  const DialogChoice({
    required this.label,
    required this.value,
    this.isDefault = false,
    this.isDestructive = false,
  });

  final String label;
  final T value;
  final bool isDefault;
  final bool isDestructive;
}