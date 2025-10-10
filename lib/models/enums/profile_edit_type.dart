import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../tag.dart';

/// ProfileEditType enum - equivalent to iOS ProfileEditType
enum ProfileEditType implements OptionType {
  //settings,
  //blocks,
  account;

  @override
  String get id => name;

  @override
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      //case ProfileEditType.settings:
      //  return 'Settings';
      //case ProfileEditType.blocks:
      //  return 'Blocked users';
      case ProfileEditType.account:
        return l10n.profileEditAccountTitle;
    }
  }

  @override
  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      //case ProfileEditType.settings:
      //  return 'Preferences';
      //case ProfileEditType.blocks:
      //  return 'Blocked users';
      case ProfileEditType.account:
        return l10n.profileEditAccountDescription;
    }
  }

  @override
  String? get icon {
    switch (this) {
      //case ProfileEditType.settings:
      //  return 'settings';
      //case ProfileEditType.blocks:
      //  return 'blocked';
      case ProfileEditType.account:
        return 'account';
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