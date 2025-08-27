import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../models/enums/profile_edit_type.dart';
import '../../core/utils/app_logger.dart';
import '../../widgets/buttons/option_button.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import 'edit_account_view.dart';

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
        children: [
          // Map all ProfileEditType values to OptionButtons
          ...ProfileEditType.values.map((profileEditType) {
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
          }),
        ],
    );
  }

  void _handleOptionTap(BuildContext context, ProfileEditType type) async {
    AppLogger.ui('Tapped on profile edit option: ${type.title}', context: 'ProfileEditView');
    
    bool? hasChanges = false;
    
    switch (type) {
      //case ProfileEditType.settings:
      //  AppLogger.ui('Navigate to Settings page', context: 'ProfileEditView');
        // TODO: Navigate to settings page
        //break;
      //case ProfileEditType.blocks:
      //  AppLogger.ui('Navigate to Blocked Users page', context: 'ProfileEditView');
        // TODO: Navigate to blocked users page
      //  break;
      case ProfileEditType.account:
        AppLogger.ui('Navigate to Account page', context: 'ProfileEditView');
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