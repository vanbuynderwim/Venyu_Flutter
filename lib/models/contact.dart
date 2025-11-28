import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../widgets/buttons/option_button.dart';
import 'tag.dart';

/// Represents a contact setting for a user's profile.
///
/// Contact settings include things like phone number, email, LinkedIn, etc.
/// Each contact setting has a type (defined by id), display label, description,
/// icon, and an optional value that the user has set.
class Contact implements OptionType {
  @override
  final String id;
  final String label;
  final String _description;
  @override
  final String? icon;
  final String? value;

  const Contact({
    required this.id,
    required this.label,
    required String description,
    this.icon,
    this.value,
  }) : _description = description;

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      label: json['label'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'description': _description,
      'icon': icon,
      'value': value,
    };
  }

  /// Create a copy with updated fields
  Contact copyWith({
    String? id,
    String? label,
    String? description,
    String? icon,
    String? value,
  }) {
    return Contact(
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? _description,
      icon: icon ?? this.icon,
      value: value ?? this.value,
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
  List<Tag>? get list {
    // Return a tag with the value if it's set, otherwise null
    if (value != null && value!.isNotEmpty) {
      return [
        Tag(
          id: id,
          label: value!,
          icon: null,
          emoji: null,
        ),
      ];
    }
    return null;
  }

  /// Whether this contact has a value set
  bool get hasValue => value != null && value!.isNotEmpty;
}
