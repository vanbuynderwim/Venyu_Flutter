// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile_model.dart';
import 'prompt_model.dart';
import 'match_model.dart';
import '../../core/enums/notification_type.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    ProfileModel? sender,
    required NotificationType type,
    required String title,
    required String body,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'opened_at') DateTime? openedAt,
    PromptModel? prompt,
    MatchModel? match,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}