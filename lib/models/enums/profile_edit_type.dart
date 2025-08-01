import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../tag.dart';

/// ProfileEditType enum - equivalent to iOS ProfileEditType
enum ProfileEditType implements OptionType {
  personalinfo,
  company,
  settings,
  blocks,
  account;

  @override
  String get id => name;

  @override
  String get title {
    switch (this) {
      case ProfileEditType.personalinfo:
        return 'Personal info';
      case ProfileEditType.company:
        return 'Company info';
      case ProfileEditType.settings:
        return 'Settings';
      case ProfileEditType.blocks:
        return 'Blocked users';
      case ProfileEditType.account:
        return 'Account';
    }
  }

  @override
  String get description {
    switch (this) {
      case ProfileEditType.personalinfo:
        return 'Name, about you, email...';
      case ProfileEditType.company:
        return 'Name, role(s), sector(s), ...';
      case ProfileEditType.settings:
        return 'Preferences';
      case ProfileEditType.blocks:
        return 'Blocked users';
      case ProfileEditType.account:
        return 'Manage your account';
    }
  }

  @override
  String? get icon {
    switch (this) {
      case ProfileEditType.personalinfo:
        return 'profile';
      case ProfileEditType.company:
        return 'company';
      case ProfileEditType.settings:
        return 'settings';
      case ProfileEditType.blocks:
        return 'blocked';
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