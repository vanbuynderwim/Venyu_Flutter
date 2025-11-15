import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/dialog_utils.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../models/enums/account_settings_type.dart';
import '../../services/auth_service.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/option_button.dart';

/// Account settings view for data export, logout, and account deletion
/// 
/// This view provides users with account management options including:
/// - Export all personal data
/// - Logout from the application
/// - Permanently delete their account
class EditAccountView extends StatefulWidget {
  const EditAccountView({super.key});

  @override
  State<EditAccountView> createState() => _EditAccountViewState();
}

class _EditAccountViewState extends State<EditAccountView> {
  bool _isExporting = false;
  bool _isDeleting = false;
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.editAccountTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAccountSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a settings section with label and option buttons
  Widget _buildAccountSection() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section label
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 8),
          child: Text(
            l10n.editAccountSectionLabel,
            style: AppTextStyles.headline.copyWith(
              color: context.venyuTheme.primaryText,
            ),
          ),
        ),

        // Logout button
        OptionButton(
          option: AccountSettingsType.logout,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          disabled: _isLoggingOut,
          onSelect: _handleLogout,
        ),

        // Export data button
        OptionButton(
          option: AccountSettingsType.exportData,
          isButton: true,
          isChevronVisible: true,
          isCheckmarkVisible: false,
          withDescription: true,
          disabled: _isExporting,
          onSelect: _handleExportData,
        ),

        // Delete account button
        OptionButton(
          option: AccountSettingsType.deleteAccount,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          disabled: _isDeleting,
          onSelect: _handleDeleteAccount,
        ),
      ],
    );
  }

  /// Handle data export request
  Future<void> _handleExportData() async {
    if (_isExporting) return;

    final l10n = AppLocalizations.of(context)!;

    // Show confirmation dialog first
    final bool shouldExport = await DialogUtils.showConfirmationDialog(
      context: context,
      title: l10n.editAccountExportDialogTitle,
      message: l10n.editAccountExportDialogMessage,
      confirmText: l10n.editAccountExportDialogConfirm,
      isDestructive: false
    );

    if (!shouldExport || !mounted) return;

    setState(() {
      _isExporting = true;
    });

    try {
      await ProfileManager.shared.exportData();

      if (mounted) {
        ToastService.success(
          context: context,
          message: l10n.editAccountExportSuccessMessage,
        );
      }
    } catch (error) {
      AppLogger.error('Export data failed', context: 'EditAccountView', error: error);

      if (mounted) {
        ToastService.error(
          context: context,
          message: l10n.editAccountExportErrorMessage,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  /// Handle account deletion
  Future<void> _handleDeleteAccount() async {
    if (_isDeleting) return;

    final l10n = AppLocalizations.of(context)!;

    // Show confirmation dialog first
    final bool shouldDelete = await DialogUtils.showConfirmationDialog(
      context: context,
      title: l10n.editAccountDeleteDialogTitle,
      message: l10n.editAccountDeleteDialogMessage,
      confirmText: l10n.editAccountDeleteDialogConfirm,
      isDestructive: true,
    );

    if (!shouldDelete || !mounted) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      // Delete the account
      await ProfileManager.shared.deleteAccount();

      // Sign out after deletion
      await AuthService.shared.signOut();

      // Navigate back to AuthFlow which will show LoginView based on auth state
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          platformPageRoute(
            context: context,
            builder: (context) => const AuthFlow(),
          ),
          (route) => false,
        );
      }
    } catch (error) {
      AppLogger.error('Delete account failed', context: 'EditAccountView', error: error);

      if (mounted) {
        ToastService.error(
          context: context,
          message: l10n.editAccountDeleteErrorMessage,
        );

        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  /// Handle logout
  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    final l10n = AppLocalizations.of(context)!;

    // Show confirmation dialog first
    final bool shouldLogout = await DialogUtils.showConfirmationDialog(
      context: context,
      title: l10n.editAccountLogoutDialogTitle,
      message: l10n.editAccountLogoutDialogMessage,
      confirmText: l10n.editAccountLogoutDialogConfirm,
      isDestructive: true,
    );

    if (!shouldLogout || !mounted) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await AuthService.shared.signOut();

      // Navigate back to AuthFlow which will show LoginView based on auth state
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          platformPageRoute(
            context: context,
            builder: (context) => const AuthFlow(),
          ),
          (route) => false,
        );
      }
    } catch (error) {
      AppLogger.error('Logout failed', context: 'EditAccountView', error: error);

      if (mounted) {
        ToastService.error(
          context: context,
          message: l10n.editAccountLogoutErrorMessage,
        );

        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }
}