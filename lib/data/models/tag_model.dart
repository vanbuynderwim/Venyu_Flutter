// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_model.freezed.dart';
part 'tag_model.g.dart';

@freezed
class TagModel with _$TagModel {
  const factory TagModel({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'display_order') required int displayOrder,
    String? emoji,
    @JsonKey(name: 'is_selected') bool? isSelected,
  }) = _TagModel;

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);
}