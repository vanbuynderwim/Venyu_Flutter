import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../tag.dart';

/// EditPersonalInfoType enum - equivalent to iOS EditPersonalInfoType
enum EditPersonalInfoType implements OptionType {
  name,
  bio,
  email;

  @override
  String get id => toString();

  @override
  String get title {
    switch (this) {
      case EditPersonalInfoType.name:
        return 'Your identity';
      case EditPersonalInfoType.bio:
        return 'About you';
      case EditPersonalInfoType.email:
        return 'Email';
    }
  }

  @override
  String get description {
    switch (this) {
      case EditPersonalInfoType.name:
        return 'Your name and LinkedIn';
      case EditPersonalInfoType.bio:
        return 'A short intro about yourself.';
      case EditPersonalInfoType.email:
        return 'Your email address.';
    }
  }

  @override
  String? get icon {
    switch (this) {
      case EditPersonalInfoType.name:
        return AppAssets.icons.profile.outlined;
      case EditPersonalInfoType.bio:
        return AppAssets.icons.edit.outlined;
      case EditPersonalInfoType.email:
        return AppAssets.icons.email.outlined;
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