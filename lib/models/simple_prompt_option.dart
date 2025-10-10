import 'package:flutter/material.dart';
import '../../widgets/buttons/option_button.dart';
import 'models.dart';

/// Simple implementation of OptionType for prompt selection views
///
/// Used for creating simple options like "Publish publicly" without requiring
/// all the complex features of a full option.
class SimplePromptOption implements OptionType {
  @override
  final String id;

  final String _title;

  final String _description;

  @override
  final Color color;

  @override
  final String? icon;

  @override
  final String? emoji;

  @override
  final int badge;

  @override
  final List<Tag>? list;

  const SimplePromptOption({
    required this.id,
    required String title,
    required String description,
    required this.color,
    this.icon,
    this.emoji,
  }) : _title = title,
       _description = description,
       badge = 0,
       list = null;

  @override
  String title(BuildContext context) => _title;

  @override
  String description(BuildContext context) => _description;
}