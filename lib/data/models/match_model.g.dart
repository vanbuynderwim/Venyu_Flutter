// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchModelImpl _$$MatchModelImplFromJson(Map<String, dynamic> json) =>
    _$MatchModelImpl(
      id: json['id'] as String,
      profile: ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
      status: $enumDecode(_$MatchStatusEnumMap, json['status']),
      score: (json['score'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
      response: $enumDecodeNullable(_$MatchResponseEnumMap, json['response']),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      prompts: (json['prompts'] as List<dynamic>?)
          ?.map((e) => PromptModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      connections: (json['connections'] as List<dynamic>?)
          ?.map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadCount: (json['unread_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MatchModelImplToJson(_$MatchModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile': instance.profile,
      'status': _$MatchStatusEnumMap[instance.status]!,
      'score': instance.score,
      'reason': instance.reason,
      'response': _$MatchResponseEnumMap[instance.response],
      'updated_at': instance.updatedAt?.toIso8601String(),
      'prompts': instance.prompts,
      'connections': instance.connections,
      'unread_count': instance.unreadCount,
    };

const _$MatchStatusEnumMap = {
  MatchStatus.matched: 'matched',
  MatchStatus.connected: 'connected',
};

const _$MatchResponseEnumMap = {
  MatchResponse.interested: 'interested',
  MatchResponse.notInterested: 'notInterested',
};
