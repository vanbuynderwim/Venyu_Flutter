import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/utils/app_logger.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import '../../widgets/common/sub_title.dart';
import '../../widgets/buttons/option_button.dart';
import '../../models/notification_setting.dart';
import '../../models/enums/notification_target.dart';
import '../../services/supabase_managers/notification_manager.dart';
import '../../core/providers/app_providers.dart';

/// NotificationSettingsView - Page for managing notification preferences
class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() => _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  // Services
  late final NotificationManager _notificationManager;

  // State
  final List<NotificationSetting> _settings = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _notificationManager = NotificationManager.shared;
    _loadSettings();
  }

  Future<void> _loadSettings({bool forceRefresh = false}) async {
    final authService = context.authService;
    if (!authService.isAuthenticated) return;

    if (forceRefresh || _settings.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = true;
          if (forceRefresh) {
            _settings.clear();
          }
        });
      }

      try {
        final settings = await _notificationManager.fetchNotificationSettings();
        if (mounted) {
          setState(() {
            _settings.clear();
            _settings.addAll(settings);
            _isLoading = false;
          });
        }
      } catch (error) {
        AppLogger.error('Error fetching notification settings', context: 'NotificationSettingsView', error: error);
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _loadSettings(forceRefresh: true);
  }

  Future<void> _handleToggle(NotificationSetting setting, bool value) async {
    // Optimistically update UI
    final index = _settings.indexWhere((s) => s.id == setting.id);
    if (index != -1) {
      setState(() {
        _settings[index] = setting.copyWith(isActive: value);
      });
    }

    try {
      // Toggle on server
      await _notificationManager.toggleNotificationSetting(
        setting.type,
        setting.target,
      );
      AppLogger.success('Notification setting toggled successfully', context: 'NotificationSettingsView');
    } catch (error) {
      AppLogger.error('Error toggling notification setting', context: 'NotificationSettingsView', error: error);

      // Revert optimistic update on error
      if (mounted) {
        setState(() {
          _settings[index] = setting.copyWith(isActive: !value);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Group settings by target
    final pushSettings = _settings.where((s) => s.target == NotificationTarget.push).toList();
    final emailSettings = _settings.where((s) => s.target == NotificationTarget.email).toList();

    return AppScaffold(
      useSafeArea: false,
      appBar: PlatformAppBar(
        title: Text(l10n.notificationSettingsTitle),
      ),
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const LoadingStateWidget()
            : _settings.isEmpty
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: EmptyStateWidget(
                        message: l10n.emptyStateNotificationSettingsTitle,
                        description: l10n.emptyStateNotificationSettingsDescription,
                        iconName: "notification",
                        height: MediaQuery.of(context).size.height * 0.6,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Push notifications section
                          if (pushSettings.isNotEmpty) ...[
                            SubTitle(
                              iconName: 'notification',
                              title: l10n.notificationSettingsPushSection,
                            ),
                            const SizedBox(height: 8),
                            ...pushSettings.map((setting) => OptionButton(
                                  option: setting,
                                  isSelected: setting.isActive,
                                  isMultiSelect: true,
                                  withDescription: true,
                                  isButton: true,
                                  onSelect: () => _handleToggle(setting, !setting.isActive),
                                )),
                          ],
                          // Email notifications section
                          if (emailSettings.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            SubTitle(
                              iconName: 'email',
                              title: l10n.notificationSettingsEmailSection,
                            ),
                            const SizedBox(height: 8),
                            ...emailSettings.map((setting) => OptionButton(
                                  option: setting,
                                  isSelected: setting.isActive,
                                  isMultiSelect: true,
                                  withDescription: true,
                                  isButton: true,
                                  onSelect: () => _handleToggle(setting, !setting.isActive),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
