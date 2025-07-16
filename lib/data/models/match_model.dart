// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile_model.dart';
import 'prompt_model.dart';
import '../../core/enums/match_status.dart';
import '../../core/enums/match_response.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

@freezed
class MatchModel with _$MatchModel {
  const factory MatchModel({
    required String id,
    required ProfileModel profile,
    required MatchStatus status,
    double? score,
    String? reason,
    MatchResponse? response,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    List<PromptModel>? prompts,
    List<MatchModel>? connections,
    @JsonKey(name: 'unread_count') int? unreadCount,
  }) = _MatchModel;

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
}