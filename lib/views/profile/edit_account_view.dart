import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../core/utils/dialog_utils.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/url_helper.dart';
import '../../core/utils/device_info.dart';
import '../../core/providers/app_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../models/enums/account_settings_type.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/option_button.dart';
import 'edit_personal_info_view.dart';
import 'edit_company_name_view.dart';
import '../notifications/notification_settings_view.dart';

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
  String _appVersion = '';
  bool _autoIntroduction = false;
  bool _isUpdatingAutoIntroduction = false;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _loadAutoIntroductionSetting();
  }

  /// Load auto-introduction setting from profile
  void _loadAutoIntroductionSetting() {
    final profile = ProfileService.shared.currentProfile;
    if (profile != null) {
      setState(() {
        _autoIntroduction = profile.autoIntroduction ?? false;
      });
    }
  }

  /// Load app version
  Future<void> _loadAppVersion() async {
    final version = await DeviceInfo.detectAppVersion();
    if (mounted) {
      setState(() {
        _appVersion = version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.editAccountTitle),
      ),
      body: SafeArea(
        bottom: Platform.isAndroid,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileSection(),
              const SizedBox(height: 24),
              _buildSettingsSection(),
              const SizedBox(height: 24),
              _buildFeedbackSection(),
              const SizedBox(height: 24),
              _buildSupportLegalSection(),
              const SizedBox(height: 24),
              _buildAccountSection(),
              const SizedBox(height: 24),
              _buildFooterSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the Profile section with option buttons
  Widget _buildProfileSection() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section label
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 8),
          child: Text(
            l10n.editAccountProfileSectionLabel,
            style: AppTextStyles.headline.copyWith(
              color: context.venyuTheme.primaryText,
            ),
          ),
        ),

        // Personal info button
        OptionButton(
          option: AccountSettingsType.personalInfo,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handlePersonalInfo(context),
        ),

        // Company name button
        OptionButton(
          option: AccountSettingsType.companyName,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handleCompanyName(context),
        ),
      ],
    );
  }

  /// Build the Settings section with option buttons
  Widget _buildSettingsSection() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section label
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 8),
          child: Text(
            l10n.editAccountSettingsSectionLabel,
            style: AppTextStyles.headline.copyWith(
              color: context.venyuTheme.primaryText,
            ),
          ),
        ),

        // Notifications button
        OptionButton(
          option: AccountSettingsType.notifications,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handleNotifications(context),
        ),

        // Auto-introduction toggle
        OptionButton(
          option: AccountSettingsType.autoIntroduction,
          isSelected: _autoIntroduction,
          isMultiSelect: true,
          isButton: true,
          withDescription: true,
          disabled: _isUpdatingAutoIntroduction,
          onSelect: _isUpdatingAutoIntroduction ? null : () => _handleAutoIntroductionToggle(!_autoIntroduction),
        ),
      ],
    );
  }

  /// Handle auto-introduction toggle
  Future<void> _handleAutoIntroductionToggle(bool value) async {
    if (_isUpdatingAutoIntroduction) return;

    setState(() {
      _isUpdatingAutoIntroduction = true;
    });

    try {
      await ProfileManager.shared.updateProfileSetting('auto_introduction', value);

      if (mounted) {
        setState(() {
          _autoIntroduction = value;
        });

        // Update local profile
        final currentProfile = context.profileService.currentProfile;
        if (currentProfile != null) {
          // Refresh profile to get updated data
          final refreshedProfile = await ProfileManager.shared.fetchUserProfile();
          ProfileService.shared.updateCurrentProfile(refreshedProfile);
        }
      }
    } catch (error) {
      AppLogger.error('Failed to update auto-introduction setting', error: error, context: 'EditAccountView');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastService.error(
          context: context,
          message: l10n.editAccountSettingsUpdateError,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingAutoIntroduction = false;
        });
      }
    }
  }

  /// Build the Feedback section with option buttons
  Widget _buildFeedbackSection() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section label
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 8),
          child: Text(
            l10n.editAccountFeedbackSectionLabel,
            style: AppTextStyles.headline.copyWith(
              color: context.venyuTheme.primaryText,
            ),
          ),
        ),

        // Feature request button
        OptionButton(
          option: AccountSettingsType.featureRequest,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handleFeatureRequest(context),
        ),        

        // Rate us button
        OptionButton(
          option: AccountSettingsType.rateUs,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handleRateUs(context),
        ),

        // Follow us button
        OptionButton(
          option: AccountSettingsType.followUs,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handleFollowUs(context),
        ),

        // Testimonial button
        OptionButton(
          option: AccountSettingsType.testimonial,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handleTestimonial(context),
        ),

        // Bug report button
        OptionButton(
          option: AccountSettingsType.bug,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handleBugReport(context),
        ),
      ],
    );
  }

  /// Build the Support & Legal section with option buttons
  Widget _buildSupportLegalSection() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section label
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 8),
          child: Text(
            l10n.editAccountSupportLegalSectionLabel,
            style: AppTextStyles.headline.copyWith(
              color: context.venyuTheme.primaryText,
            ),
          ),
        ),

        // Support button
        OptionButton(
          option: AccountSettingsType.support,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handleSupport(context),
        ),

        // Terms button
        OptionButton(
          option: AccountSettingsType.terms,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handleTerms(context),
        ),

        // Privacy button
        OptionButton(
          option: AccountSettingsType.privacy,
          isButton: true,
          isChevronVisible: true,
          isSelectable: false,
          withDescription: true,
          onSelect: () => _handlePrivacy(context),
        ),
      ],
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

        // Export data button
        OptionButton(
          option: AccountSettingsType.exportData,
          isButton: true,
          isChevronVisible: false,
          isCheckmarkVisible: false,
          withDescription: true,
          disabled: _isExporting,
          onSelect: _handleExportData,
        ),

        // Logout button
        OptionButton(
          option: AccountSettingsType.logout,
          isButton: true,
          isChevronVisible: false,
          isSelectable: false,
          withDescription: true,
          disabled: _isLoggingOut,
          onSelect: _handleLogout,
        ),

        

        // Delete account button
        OptionButton(
          option: AccountSettingsType.deleteAccount,
          isButton: true,
          isChevronVisible: false,
          isSelectable: false,
          withDescription: true,
          disabled: _isDeleting,
          onSelect: _handleDeleteAccount,
        ),
      ],
    );
  }

  /// Build the footer section with logo and version
  Widget _buildFooterSection() {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Center(
            child: Image.asset(
              'assets/images/visuals/logo.png',
              color: context.venyuTheme.primary,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_appVersion.isNotEmpty)
          Text(
            'v$_appVersion',
            style: AppTextStyles.footnote.copyWith(
              color: context.venyuTheme.secondaryText,
            ),
          ),
        const SizedBox(height: 24),
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

  /// Build email body with user and device information
  Future<String> _buildEmailBody() async {
    try {
      // Gather device and user information
      final profile = await ProfileManager.shared.fetchUserProfile();
      final userId = profile.id;
      final platform = Platform.isIOS ? 'iOS' : 'Android';
      final appVersion = await DeviceInfo.detectAppVersion();

      // Return prefilled body with user and device info
      return '''


---
User ID: $userId
Platform: $platform
App Version: $appVersion
''';
    } catch (e) {
      AppLogger.error('Failed to gather email info', error: e, context: 'EditAccountView');
      return ''; // Return empty body on error
    }
  }

  /// Handle feature request - opens email to ideas@getvenyu.com
  Future<void> _handleFeatureRequest(BuildContext context) async {
    final body = await _buildEmailBody();

    if (!mounted) return;

    UrlHelper.composeEmail(
      this.context,
      'ideas@getvenyu.com',
      subject: 'Feature Request',
      body: body,
    );
  }

  /// Handle testimonial - opens email to testimonials@getvenyu.com
  Future<void> _handleTestimonial(BuildContext context) async {
    final body = await _buildEmailBody();

    if (!mounted) return;

    UrlHelper.composeEmail(
      this.context,
      'testimonials@getvenyu.com',
      subject: 'Testimonial',
      body: body,
    );
  }

  /// Handle bug report - opens email to bugs@getvenyu.com
  Future<void> _handleBugReport(BuildContext context) async {
    final body = await _buildEmailBody();

    if (!mounted) return;

    UrlHelper.composeEmail(
      this.context,
      'bugs@getvenyu.com',
      subject: 'Bug Report',
      body: body,
    );
  }

  /// Handle support request - opens email to support@getvenyu.com
  Future<void> _handleSupport(BuildContext context) async {
    final body = await _buildEmailBody();

    if (!mounted) return;

    UrlHelper.composeEmail(
      this.context,
      'support@getvenyu.com',
      subject: 'Support Request',
      body: body,
    );
  }

  /// Handle terms - opens terms and conditions URL
  void _handleTerms(BuildContext context) {
    UrlHelper.openWebsite(
      context,
      'https://www.getvenyu.com/legal/terms-and-conditions',
    );
  }

  /// Handle privacy - opens privacy policy URL
  void _handlePrivacy(BuildContext context) {
    UrlHelper.openWebsite(
      context,
      'https://www.getvenyu.com/legal/privacy-policy',
    );
  }

  /// Handle personal info - navigate to personal info edit view
  void _handlePersonalInfo(BuildContext context) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => const EditPersonalInfoView(),
      ),
    );
  }

  /// Handle company name - navigate to company name edit view
  void _handleCompanyName(BuildContext context) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => const EditCompanyNameView(),
      ),
    );
  }

  /// Handle notifications - navigate to notification settings view
  void _handleNotifications(BuildContext context) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => const NotificationSettingsView(),
      ),
    );
  }

  /// Handle follow us - opens Venyu LinkedIn company page
  void _handleFollowUs(BuildContext context) {
    UrlHelper.openWebsite(
      context,
      'https://www.linkedin.com/company/getvenyu/',
    );
  }

  /// Handle rate us - opens App Store/Play Store rating page
  void _handleRateUs(BuildContext context) {
    if (Platform.isIOS) {
      // iOS App Store rating page
      const appId = '6742804932'; // e.g., '123456789'
      UrlHelper.openWebsite(
        context,
        'https://apps.apple.com/app/id$appId?action=write-review',
      );
    } else if (Platform.isAndroid) {
      // Android Play Store rating page
      const packageName = 'com.getvenyu.app';
      UrlHelper.openWebsite(
        context,
        'https://play.google.com/store/apps/details?id=$packageName',
      );
    } else {
      // Fallback for other platforms
      UrlHelper.openWebsite(
        context,
        'https://www.getvenyu.com',
      );
    }
  }
}