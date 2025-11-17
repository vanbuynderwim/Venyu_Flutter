import 'package:flutter/material.dart';
import 'enums/notification_type.dart';
import 'enums/notification_target.dart';
import 'tag.dart';
import '../widgets/buttons/option_button.dart';
import '../core/theme/app_colors.dart';

class NotificationSetting implements OptionType {
  final NotificationType type;
  final NotificationTarget target;
  final String label;
  final String _description;
  final bool isActive;

  const NotificationSetting({
    required this.type,
    required this.target,
    required this.label,
    required String description,
    required this.isActive,
  }) : _description = description;

  factory NotificationSetting.fromJson(Map<String, dynamic> json) {
    return NotificationSetting(
      type: NotificationType.fromJson(json['type']),
      target: NotificationTarget.fromJson(json['target']),
      label: json['label'] as String,
      description: json['description'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'target': target.toJson(),
      'label': label,
      'description': _description,
      'is_active': isActive,
    };
  }

  /// Create a copy with updated fields
  NotificationSetting copyWith({
    NotificationType? type,
    NotificationTarget? target,
    String? label,
    String? description,
    bool? isActive,
  }) {
    return NotificationSetting(
      type: type ?? this.type,
      target: target ?? this.target,
      label: label ?? this.label,
      description: description ?? _description,
      isActive: isActive ?? this.isActive,
    );
  }

  // OptionType implementation
  @override
  String get id => '${type.value}_${target.value}';

  @override
  String title(BuildContext context) => label;

  @override
  String description(BuildContext context) => _description;

  @override
  Color get color {
    // Different colors based on target
    switch (target) {
      case NotificationTarget.email:
        return AppColors.primair4Lilac;
      case NotificationTarget.push:
        return AppColors.primair4Lilac;
    }
  }

  @override
  String? get icon {
    // Different icons based on target
    return null;
  }

  @override
  String? get emoji => null;

  @override
  int get badge => 0;

  @override
  List<Tag>? get list => null;
}
