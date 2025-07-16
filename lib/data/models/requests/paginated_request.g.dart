// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedRequestImpl _$$PaginatedRequestImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedRequestImpl(
  limit: (json['limit'] as num).toInt(),
  cursorId: json['cursorId'] as String?,
  cursorTime: json['cursorTime'] == null
      ? null
      : DateTime.parse(json['cursorTime'] as String),
  cursorStatus: $enumDecodeNullable(_$MatchStatusEnumMap, json['cursorStatus']),
  list: $enumDecode(_$ServerListTypeEnumMap, json['list']),
);

Map<String, dynamic> _$$PaginatedRequestImplToJson(
  _$PaginatedRequestImpl instance,
) => <String, dynamic>{
  'limit': instance.limit,
  'cursorId': instance.cursorId,
  'cursorTime': instance.cursorTime?.toIso8601String(),
  'cursorStatus': _$MatchStatusEnumMap[instance.cursorStatus],
  'list': _$ServerListTypeEnumMap[instance.list]!,
};

const _$MatchStatusEnumMap = {
  MatchStatus.matched: 'matched',
  MatchStatus.connected: 'connected',
};

const _$ServerListTypeEnumMap = {
  ServerListType.matches: 'matches',
  ServerListType.notifications: 'notifications',
  ServerListType.userReviews: 'userReviews',
  ServerListType.systemReviews: 'systemReviews',
};
