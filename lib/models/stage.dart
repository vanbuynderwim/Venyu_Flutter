import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../widgets/buttons/option_button.dart';
import 'tag.dart';

/// Represents a connection stage in a match.
///
/// Stages track the progress of a connection between matched users,
/// such as 'reached_out', 'responded', etc.
class Stage implements OptionType {
  @override
  final String id;
  final String label;
  final String _description;
  @override
  final String? icon;

  const Stage({
    required this.id,
    required this.label,
    required String description,
    this.icon,
  }) : _description = description;

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'] as String,
      label: json['label'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'description': _description,
      'icon': icon,
    };
  }

  /// Create a copy with updated fields
  Stage copyWith({
    String? id,
    String? label,
    String? description,
    String? icon,
  }) {
    return Stage(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? _description,
      icon: icon ?? this.icon,
    );
  }

  // OptionType implementation
  @override
  String title(BuildContext context) => label;

  @override
  String description(BuildContext context) => _description;

  @override
  Color get color => AppColors.primair4Lilac;

  @override
  String? get emoji => null;

  @override
  int get badge => 0;

  @override
  List<Tag>? get list => null;
}
