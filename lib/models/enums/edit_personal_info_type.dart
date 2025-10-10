import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../tag.dart';

/// EditPersonalInfoType enum - equivalent to iOS EditPersonalInfoType
enum EditPersonalInfoType implements OptionType {
  name,
  bio,
  email,
  location;

  @override
  String get id => toString();

  @override
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case EditPersonalInfoType.name:
        return l10n.editPersonalInfoNameTitle;
      case EditPersonalInfoType.bio:
        return l10n.editPersonalInfoBioTitle;
      case EditPersonalInfoType.location:
        return l10n.editPersonalInfoLocationTitle;
      case EditPersonalInfoType.email:
        return l10n.editPersonalInfoEmailTitle;
    }
  }

  @override
  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case EditPersonalInfoType.name:
        return l10n.editPersonalInfoNameDescription;
      case EditPersonalInfoType.bio:
        return l10n.editPersonalInfoBioDescription;
      case EditPersonalInfoType.location:
        return l10n.editPersonalInfoLocationDescription;
      case EditPersonalInfoType.email:
        return l10n.editPersonalInfoEmailDescription;
    }
  }

  @override
  String? get icon {
    switch (this) {
      case EditPersonalInfoType.name:
        return 'profile';
      case EditPersonalInfoType.bio:
        return 'edit';
      case EditPersonalInfoType.location:
        return 'map';
      case EditPersonalInfoType.email:
        return 'email';
    }
  }

  @override
  String? get emoji => null;

  @override
  Color get color => AppColors.primair4Lilac;

  @override
  int get badge => 0;

  @override
  List<Tag>? get list => null;
}