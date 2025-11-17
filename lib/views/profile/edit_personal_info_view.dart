import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/utils/app_logger.dart';
import '../../l10n/app_localizations.dart';
import '../../models/enums/edit_personal_info_type.dart';
import '../../widgets/buttons/option_button.dart';
import 'edit_bio_view.dart';
import 'edit_city_view.dart';
import 'edit_email_info_view.dart';
import 'edit_name_view.dart';

/// Edit Personal Info View - Edit personal information fields
///
/// This view provides access to edit all personal information fields:
/// - Name
/// - Bio
/// - Email
/// - Location
class EditPersonalInfoView extends StatelessWidget {
  const EditPersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.accountSettingsPersonalInfoTitle),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Loop through all EditPersonalInfoType values
              for (final type in EditPersonalInfoType.values)
                OptionButton(
                  option: type,
                  isButton: true,
                  isChevronVisible: true,
                  isSelectable: false,
                  withDescription: true,
                  onSelect: () => _handlePersonalInfoTap(context, type),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle personal info option tap - navigate to specific edit view
  void _handlePersonalInfoTap(BuildContext context, EditPersonalInfoType type) async {
    AppLogger.ui('Tapped on personal info type: ${type.title(context)}', context: 'EditPersonalInfoView');

    switch (type) {
      case EditPersonalInfoType.name:
        await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditNameView(),
          ),
        );
        break;
      case EditPersonalInfoType.bio:
        await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditBioView(),
          ),
        );
        break;
      case EditPersonalInfoType.location:
        await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditCityView(),
          ),
        );
        break;
      case EditPersonalInfoType.email:
        await Navigator.push<bool>(
          context,
          platformPageRoute(
            context: context,
            builder: (context) => const EditEmailInfoView(),
          ),
        );
        break;
    }
  }
}
