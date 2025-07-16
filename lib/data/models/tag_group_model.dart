// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'tag_model.dart';
import '../../core/enums/category_type.dart';

part 'tag_group_model.freezed.dart';
part 'tag_group_model.g.dart';

@freezed
class TagGroupModel with _$TagGroupModel {
  const factory TagGroupModel({
    required String id,
    required String code,
    required String title,
    String? description,
    required CategoryType type,
    @JsonKey(name: 'display_order') required int displayOrder,
    List<TagModel>? tags,
  }) = _TagGroupModel;

  factory TagGroupModel.fromJson(Map<String, dynamic> json) =>
      _$TagGroupModelFromJson(json);
}