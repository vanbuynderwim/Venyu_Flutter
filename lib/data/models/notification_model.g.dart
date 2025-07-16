// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  sender: json['sender'] == null
      ? null
      : ProfileModel.fromJson(json['sender'] as Map<String, dynamic>),
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  title: json['title'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  openedAt: json['opened_at'] == null
      ? null
      : DateTime.parse(json['opened_at'] as String),
  prompt: json['prompt'] == null
      ? null
      : PromptModel.fromJson(json['prompt'] as Map<String, dynamic>),
  match: json['match'] == null
      ? null
      : MatchModel.fromJson(json['match'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'sender': instance.sender,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'title': instance.title,
  'body': instance.body,
  'created_at': instance.createdAt.toIso8601String(),
  'opened_at': instance.openedAt?.toIso8601String(),
  'prompt': instance.prompt,
  'match': instance.match,
};

const _$NotificationTypeEnumMap = {
  NotificationType.cardSubmitted: 'cardSubmitted',
  NotificationType.cardApproved: 'cardApproved',
  NotificationType.cardRejected: 'cardRejected',
  NotificationType.matched: 'matched',
  NotificationType.connected: 'connected',
};
