// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TagGroupModelImpl _$$TagGroupModelImplFromJson(Map<String, dynamic> json) =>
    _$TagGroupModelImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$CategoryTypeEnumMap, json['type']),
      displayOrder: (json['display_order'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TagGroupModelImplToJson(_$TagGroupModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'title': instance.title,
      'description': instance.description,
      'type': _$CategoryTypeEnumMap[instance.type]!,
      'display_order': instance.displayOrder,
      'tags': instance.tags,
    };

const _$CategoryTypeEnumMap = {
  CategoryType.personal: 'personal',
  CategoryType.company: 'company',
};
