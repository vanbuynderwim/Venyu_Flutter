import 'package:flutter/material.dart';
import 'tag.dart';
import 'enums/category_type.dart';
import '../widgets/buttons/option_button.dart';
import '../core/theme/app_colors.dart';

class TagGroup implements OptionType {
  @override
  final String id;
  final String label;
  final String? desc;
  @override
  final String? icon;
  final CategoryType? type;
  final bool? isMultiSelect;
  final String code;
  final List<Tag>? tags;

  const TagGroup({
    required this.id,
    required this.label,
    this.desc,
    this.icon,
    this.type,
    this.isMultiSelect,
    required this.code,
    this.tags,
  });

  factory TagGroup.fromJson(Map<String, dynamic> json) {
    return TagGroup(
      id: json['id'] as String,
      label: json['label'] as String,
      desc: json['desc'] as String?,
      icon: json['icon'] as String?,
      type: json['type'] != null ? CategoryType.fromJson(json['type']) : null,
      isMultiSelect: json['is_multi_select'] as bool?,
      code: json['code'] as String,
      tags: json['tags'] != null 
          ? (json['tags'] as List).map((tag) => Tag.fromJson(tag)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'desc': desc,
      'icon': icon,
      'type': type?.toJson(),
      'is_multi_select': isMultiSelect,
      'code': code,
      'tags': tags?.map((tag) => tag.toJson()).toList(),
    };
  }

  // Helper methods
  List<Tag> get selectedTags {
    if (tags == null) return [];
    return tags!.where((tag) => tag.isSelected == true).toList();
  }

  int get selectedCount => selectedTags.length;

  bool get hasSelectedTags => selectedCount > 0;

  // OptionType implementation
  @override
  String get title => label;

  @override
  String get description => desc ?? '';

  @override
  Color get color => hasSelectedTags 
      ? AppColors.primair4Lilac 
      : AppColors.secundair4Quicksilver;

  @override
  String? get emoji => null;

  @override
  int get badge => 0;

  @override
  List<Tag>? get list => tags;
}