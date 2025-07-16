// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TagModelImpl _$$TagModelImplFromJson(Map<String, dynamic> json) =>
    _$TagModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      displayOrder: (json['display_order'] as num).toInt(),
      emoji: json['emoji'] as String?,
      isSelected: json['is_selected'] as bool?,
    );

Map<String, dynamic> _$$TagModelImplToJson(_$TagModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'display_order': instance.displayOrder,
      'emoji': instance.emoji,
      'is_selected': instance.isSelected,
    };
