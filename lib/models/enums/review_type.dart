import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import '../../core/theme/app_colors.dart';
import '../tag.dart';

/// ReviewType enum - equivalent to iOS ReviewType
enum ReviewType implements OptionType {
  user,
  system;

  @override
  String get id => name;

  @override
  String get title {
    switch (this) {
      case ReviewType.user:
        return 'User generated';
      case ReviewType.system:
        return 'AI generated';
    }
  }

  @override
  String get description {
    switch (this) {
      case ReviewType.user:
        return 'Cards submitted by users';
      case ReviewType.system:
        return 'Daily generated cards by AI';
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