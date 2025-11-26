import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
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
    String? confirmText,
    String? cancelText,
    bool isDestructive = true,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    confirmText ??= l10n.actionDelete;
    cancelText ??= l10n.actionCancel;
    final result = await showPlatformDialog<bool>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText!),
            cupertino: (_, _) => CupertinoDialogActionData(
              isDestructiveAction: isDestructive,
            ),
            material: (_, _) => MaterialDialogActionData(
              style: TextButton.styleFrom(
                foregroundColor: isDestructive ? Theme.of(context).colorScheme.error : null,
              ),
            ),
          ),
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText!),
            cupertino: (_, _) => CupertinoDialogActionData(
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
    final l10n = AppLocalizations.of(context)!;
    return showConfirmationDialog(
      context: context,
      title: l10n.dialogRemoveAvatarTitle,
      message: l10n.dialogRemoveAvatarMessage,
      confirmText: l10n.dialogRemoveButton,
      isDestructive: true,
    );
  }

  /// Shows a platform-aware information dialog
  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    buttonText ??= l10n.dialogOkButton;
    await showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText!),
            cupertino: (_, _) => CupertinoDialogActionData(
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
    String? title,
    required String message,
    String? buttonText,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    title ??= l10n.dialogErrorTitle;
    buttonText ??= l10n.dialogOkButton;
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
          cupertino: (_, _) => CupertinoDialogActionData(
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
    String? message,
  }) {
    final l10n = AppLocalizations.of(context)!;
    message ??= l10n.dialogLoadingMessage;
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
                  message!,
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

  /// Shows a platform-aware modal sheet with menu options
  /// Returns the selected action or null if cancelled
  ///
  /// This is a generic implementation that works with any enum type
  /// and ensures the sheet is closed before executing actions
  static Future<T?> showMenuModalSheet<T>({
    required BuildContext context,
    required List<PopupMenuOption> menuOptions,
    required List<T> actions, // Must match the order of menuOptions
    String? cancelText,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    cancelText ??= l10n.actionCancel;
    assert(menuOptions.length == actions.length,
      'menuOptions and actions must have the same length');

    return await showPlatformModalSheet<T>(
      context: context,
      material: MaterialModalSheetData(
        isScrollControlled: true,
        useRootNavigator: false,
      ),
      builder: (sheetContext) => PlatformWidget(
        cupertino: (_, _) => CupertinoActionSheet(
          actions: List.generate(
            menuOptions.length,
            (index) => CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(sheetContext, actions[index]),
              child: menuOptions[index].cupertino?.call(context, PlatformTarget.iOS).child ?? Container(),
            ),
          ),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(sheetContext),
            child: Text(cancelText!),
          ),
        ),
        material: (_, _) => SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  menuOptions.length,
                  (index) => InkWell(
                    onTap: () => Navigator.pop(sheetContext, actions[index]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: menuOptions[index].material?.call(context, PlatformTarget.android).child ?? Container(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Opens device notification settings for the app
  /// This method handles both iOS and Android platforms using the app_settings package
  static Future<void> openAppSettings(BuildContext context) async {
    try {
      // Open notification settings directly - this works on both iOS and Android
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
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