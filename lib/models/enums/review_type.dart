import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../tag.dart';

/// ReviewType enum - equivalent to iOS ReviewType
enum ReviewType implements OptionType {
  user,
  system;

  @override
  String get id => name;

  @override
  String title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ReviewType.user:
        return l10n.reviewTypeUserTitle;
      case ReviewType.system:
        return l10n.reviewTypeSystemTitle;
    }
  }

  @override
  String description(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ReviewType.user:
        return l10n.reviewTypeUserDescription;
      case ReviewType.system:
        return l10n.reviewTypeSystemDescription;
    }
  }

  @override
  String? get icon {
    switch (this) {
      case ReviewType.user:
        return 'profile';
      case ReviewType.system:
        return 'ai';
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

  // JSON serialization
  String get value => name;

  static ReviewType fromJson(String value) {
    return ReviewType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ReviewType.user,
    );
  }

  String toJson() => value;
}