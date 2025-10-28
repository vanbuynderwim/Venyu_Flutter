import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/dialog_utils.dart';
import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../models/enums/action_button_type.dart';
import '../../services/auth_service.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32, // Account for padding
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Export section
                      _buildSection(
                        context: context,
                        title: l10n.editAccountDataExportTitle,
                        description: l10n.editAccountDataExportDescription,
                        child: ActionButton(
                          label: l10n.editAccountExportDataButton,
                          type: ActionButtonType.secondary,
                          onPressed: _handleExportData,
                          isLoading: _isExporting,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Delete section
                      _buildSection(
                        context: context,
                        title: l10n.editAccountDeleteTitle,
                        description: l10n.editAccountDeleteDescription,
                        child: ActionButton(
                          label: l10n.editAccountDeleteButton,
                          type: ActionButtonType.destructive,
                          onPressed: _handleDeleteAccount,
                          isLoading: _isDeleting,
                        ),
                      ),

                      const Spacer(),

                      // Logout button
                      ActionButton(
                        label: l10n.editAccountLogoutButton,
                        type: ActionButtonType.secondary,
                        onPressed: _handleLogout,
                        isLoading: _isLoggingOut,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String description,
    required Widget child,
  }) {
    final venyuTheme = context.venyuTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.title2.copyWith(
            color: venyuTheme.primaryText,
          ),
        ),
        
        const SizedBox(height: 12),
        
        Text(
          description,
          style: AppTextStyles.subheadline.copyWith(
            color: venyuTheme.secondaryText,
            height: 1.4,
          ),
        ),
        
        const SizedBox(height: 12),
        
        child,
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