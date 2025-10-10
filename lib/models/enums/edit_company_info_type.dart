import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../tag.dart';

/// EditCompanyInfoType enum - equivalent to iOS EditCompanyInfoType
enum EditCompanyInfoType implements OptionType {
  name;

  @override
  String get id => toString();

  @override
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case EditCompanyInfoType.name:
        return l10n.editCompanyInfoNameTitle;
    }
  }

  @override
  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case EditCompanyInfoType.name:
        return l10n.editCompanyInfoNameDescription;
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