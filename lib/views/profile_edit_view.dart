import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../models/enums/profile_edit_type.dart';
import '../widgets/buttons/option_button.dart';

/// ProfileEditView - Flutter equivalent of iOS ProfileEditView
class ProfileEditView extends StatelessWidget {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Edit profile'),
      ),
      backgroundColor: AppColors.primair7Pearl,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // List of profile edit options
              Column(
                children: ProfileEditType.values.map((profileEditType) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OptionButton(
                      option: profileEditType,
                      isSelected: false,
                      isMultiSelect: false,
                      isSelectable: false,
                      isCheckmarkVisible: false,
                      isChevronVisible: true,
                      isButton: true,
                      withDescription: true,
                      onSelect: () {
                        _handleOptionTap(context, profileEditType);
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOptionTap(BuildContext context, ProfileEditType type) {
    debugPrint('Tapped on profile edit option: ${type.title}');
    
    // TODO: Navigate to specific pages based on type
    switch (type) {
      case ProfileEditType.personalinfo:
        debugPrint('Navigate to Personal Info page');
        // TODO: Navigate to personal info edit page
        break;
      case ProfileEditType.company:
        debugPrint('Navigate to Company Info page');
        // TODO: Navigate to company info edit page
        break;
      case ProfileEditType.settings:
        debugPrint('Navigate to Settings page');
        // TODO: Navigate to settings page
        break;
      case ProfileEditType.blocks:
        debugPrint('Navigate to Blocked Users page');
        // TODO: Navigate to blocked users page
        break;
      case ProfileEditType.account:
        debugPrint('Navigate to Account page');
        // TODO: Navigate to account management page
        break;
    }
  }
}