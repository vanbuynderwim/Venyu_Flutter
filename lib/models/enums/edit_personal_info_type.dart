import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
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
    switch (this) {
      case EditPersonalInfoType.name:
        return 'Name';
      case EditPersonalInfoType.bio:
        return 'Bio';
      case EditPersonalInfoType.location:
        return 'City';
      case EditPersonalInfoType.email:
        return 'Email';
    }
  }

  @override
  String description(BuildContext context) {
    switch (this) {
      case EditPersonalInfoType.name:
        return 'Your name and LinkedIn URL.';
      case EditPersonalInfoType.bio:
        return 'A short intro about yourself.';
      case EditPersonalInfoType.location:
        return 'The city you live in.';
      case EditPersonalInfoType.email:
        return 'Your contact email address.';
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