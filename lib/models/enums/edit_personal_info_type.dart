import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
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
        return 'profile';
      case EditPersonalInfoType.bio:
        return 'edit';
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