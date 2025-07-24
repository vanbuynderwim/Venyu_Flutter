import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../tag.dart';

/// EditCompanyInfoType enum - equivalent to iOS EditCompanyInfoType
enum EditCompanyInfoType implements OptionType {
  company,
  position,
  location;

  @override
  String get id => toString();

  @override
  String get title {
    switch (this) {
      case EditCompanyInfoType.company:
        return 'Company';
      case EditCompanyInfoType.position:
        return 'Position';
      case EditCompanyInfoType.location:
        return 'Location';
    }
  }

  @override
  String get description {
    switch (this) {
      case EditCompanyInfoType.company:
        return 'Your current company';
      case EditCompanyInfoType.position:
        return 'Your job title or role';
      case EditCompanyInfoType.location:
        return 'Work location or city';
    }
  }

  @override
  String? get icon {
    switch (this) {
      case EditCompanyInfoType.company:
        return AppAssets.icons.company.outlined;
      case EditCompanyInfoType.position:
        return AppAssets.icons.profile.outlined;
      case EditCompanyInfoType.location:
        return AppAssets.icons.location.outlined;
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