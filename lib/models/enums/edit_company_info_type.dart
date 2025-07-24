import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../tag.dart';

/// EditCompanyInfoType enum - equivalent to iOS EditCompanyInfoType
enum EditCompanyInfoType implements OptionType {
  name;

  @override
  String get id => toString();

  @override
  String get title {
    switch (this) {
      case EditCompanyInfoType.name:
        return 'Name & website';
    }
  }

  @override
  String get description {
    switch (this) {
      case EditCompanyInfoType.name:
        return 'The name of your company';
    }
  }

  @override
  String? get icon {
    switch (this) {
      case EditCompanyInfoType.name:
        return 'company';
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