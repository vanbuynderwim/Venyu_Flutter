import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/dialog_utils.dart';
import '../../core/utils/app_logger.dart';
import '../../main.dart';
import '../../models/enums/action_button_type.dart';
import '../../services/session_manager.dart';
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
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Account settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Export section
              _buildSection(
                context: context,
                title: 'Data Export',
                description: 'You can request a copy of all your personal data. This includes your profile information, cards, matches, and activity history. The export will be sent to your registered email address.',
                child: ActionButton(
                  label: 'Export all your data',
                  type: ActionButtonType.secondary,
                  onPressed: _handleExportData,
                  isLoading: _isExporting,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Delete section
              _buildSection(
                context: context,
                title: 'Delete Account',
                description: 'Deleting your account is permanent. All your data, including your profile, cards and matches will be removed.',
                child: ActionButton(
                  label: 'Delete account',
                  type: ActionButtonType.destructive,
                  onPressed: _handleDeleteAccount,
                  isLoading: _isDeleting,
                ),
              ),
              
              const Spacer(),
              
              // Logout button
              ActionButton(
                label: 'Logout',
                type: ActionButtonType.secondary,
                onPressed: _handleLogout,
                isLoading: _isLoggingOut,
              ),
            ],
          ),
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

    // Show confirmation dialog first
    final bool? shouldExport = await DialogUtils.showChoiceDialog<bool>(
      context: context,
      title: 'Export data',
      message: 'You will receive a data export link in your email as soon as your data is ready.',
      choices: [
        const DialogChoice<bool>(
          label: 'Cancel',
          value: false,
          isDefault: true,
        ),
        const DialogChoice<bool>(
          label: 'Export',
          value: true,
        ),
      ],
    );

    if (shouldExport != true || !mounted) return;

    setState(() {
      _isExporting = true;
    });

    try {
      await ProfileManager.shared.exportData();
      
      if (mounted) {
        ToastService.success(
          context: context,
          message: 'An email will be sent once the export is ready',
        );
      }
    } catch (error) {
      AppLogger.error('Export data failed', context: 'EditAccountView', error: error);
      
      if (mounted) {
        ToastService.error(
          context: context,
          message: 'Something went wrong. Please try again later.',
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

    // Show confirmation dialog first
    final bool? shouldDelete = await DialogUtils.showChoiceDialog<bool>(
      context: context,
      title: 'Delete account',
      message: 'Your account and all its data will be permanently deleted immediately. This action cannot be undone. Are you sure you want to continue?',
      choices: [
        const DialogChoice<bool>(
          label: 'Cancel',
          value: false,
          isDefault: true,
        ),
        const DialogChoice<bool>(
          label: 'Delete',
          value: true,
          isDestructive: true,
        ),
      ],
    );

    if (shouldDelete != true || !mounted) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      // Delete the account
      await ProfileManager.shared.deleteAccount();
      
      // Sign out after deletion
      await SessionManager.shared.signOut();
      
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
          message: 'Something went wrong. Please try again later.',
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

    // Show confirmation dialog first
    final bool? shouldLogout = await DialogUtils.showChoiceDialog<bool>(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      choices: [
        const DialogChoice<bool>(
          label: 'Cancel',
          value: false,
          isDefault: true,
        ),
        const DialogChoice<bool>(
          label: 'Logout',
          value: true,
          isDestructive: true,
        ),
      ],
    );

    if (shouldLogout != true || !mounted) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await SessionManager.shared.signOut();
      
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
          message: 'Something went wrong. Please try again later.',
        );
        
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }
}