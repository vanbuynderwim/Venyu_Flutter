import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../models/enums/profile_edit_type.dart';
import '../widgets/buttons/option_button.dart';
import '../widgets/scaffolds/app_scaffold.dart';
import 'personal/edit_personal_info_view.dart';
import 'company/edit_company_info_view.dart';
import 'profile/edit_account_view.dart';

/// ProfileEditView - Flutter equivalent of iOS ProfileEditView
class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  bool _hasAnyChanges = false;

  @override
  Widget build(BuildContext context) {
    return AppListScaffold(
        appBar: PlatformAppBar(
          title: const Text('Edit profile'),
        ),
        children: ProfileEditType.values.map((profileEditType) {
          return OptionButton(
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
          );
        }).toList(),
    );
  }

  void _handleOptionTap(BuildContext context, ProfileEditType type) async {
    debugPrint('Tapped on profile edit option: ${type.title}');
    
    bool? hasChanges = false;
    
    switch (type) {
      case ProfileEditType.personalinfo:
        debugPrint('Navigate to Personal Info page');
        hasChanges = await Navigator.of(context).push(
          platformPageRoute(
            context: context,
            builder: (context) => const EditPersonalInfoView(),
          ),
        );
        break;
      case ProfileEditType.company:
        hasChanges = await Navigator.of(context).push(
          platformPageRoute(
            context: context,
            builder: (context) => const EditCompanyInfoView(),
          ),
        );
        break;
      //case ProfileEditType.settings:
      //  debugPrint('Navigate to Settings page');
        // TODO: Navigate to settings page
        //break;
      //case ProfileEditType.blocks:
      //  debugPrint('Navigate to Blocked Users page');
        // TODO: Navigate to blocked users page
      //  break;
      case ProfileEditType.account:
        debugPrint('Navigate to Account page');
        Navigator.of(context).push(
          platformPageRoute(
            context: context,
            builder: (context) => const EditAccountView(),
          ),
        );
        break;
    }
    
    // Track if any changes were made during this session
    if (hasChanges == true) {
      _hasAnyChanges = true;
    }
  }

  @override
  void dispose() {
    // Return result when the screen is disposed (including swipe back)
    if (_hasAnyChanges) {
      // This will be called when the screen is popped
      // But we need to ensure the parent gets the result
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // The result should already be passed via Navigator.pop() in ProfileView
      });
    }
    super.dispose();
  }
}