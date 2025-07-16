// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile_model.dart';
import '../../core/enums/prompt_status.dart';
import '../../core/enums/interaction_type.dart';

part 'prompt_model.freezed.dart';
part 'prompt_model.g.dart';

@freezed
class PromptModel with _$PromptModel {
  const factory PromptModel({
    @JsonKey(name: 'feed_id') int? feedID,
    @JsonKey(name: 'prompt_id') required String promptID,
    required String label,
    PromptStatus? status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'impression_count') int? impressionCount,
    @JsonKey(name: 'interaction_type') InteractionType? interactionType,
    @JsonKey(name: 'match_interaction_type') InteractionType? matchInteractionType,
    ProfileModel? profile,
  }) = _PromptModel;

  factory PromptModel.fromJson(Map<String, dynamic> json) =>
      _$PromptModelFromJson(json);
}