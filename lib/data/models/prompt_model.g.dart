// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromptModelImpl _$$PromptModelImplFromJson(Map<String, dynamic> json) =>
    _$PromptModelImpl(
      feedID: (json['feed_id'] as num?)?.toInt(),
      promptID: json['prompt_id'] as String,
      label: json['label'] as String,
      status: $enumDecodeNullable(_$PromptStatusEnumMap, json['status']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      impressionCount: (json['impression_count'] as num?)?.toInt(),
      interactionType: $enumDecodeNullable(
        _$InteractionTypeEnumMap,
        json['interaction_type'],
      ),
      matchInteractionType: $enumDecodeNullable(
        _$InteractionTypeEnumMap,
        json['match_interaction_type'],
      ),
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PromptModelImplToJson(_$PromptModelImpl instance) =>
    <String, dynamic>{
      'feed_id': instance.feedID,
      'prompt_id': instance.promptID,
      'label': instance.label,
      'status': _$PromptStatusEnumMap[instance.status],
      'created_at': instance.createdAt?.toIso8601String(),
      'impression_count': instance.impressionCount,
      'interaction_type': _$InteractionTypeEnumMap[instance.interactionType],
      'match_interaction_type':
          _$InteractionTypeEnumMap[instance.matchInteractionType],
      'profile': instance.profile,
    };

const _$PromptStatusEnumMap = {
  PromptStatus.draft: 'draft',
  PromptStatus.pendingReview: 'pendingReview',
  PromptStatus.pendingTranslation: 'pendingTranslation',
  PromptStatus.approved: 'approved',
  PromptStatus.rejected: 'rejected',
  PromptStatus.archived: 'archived',
};

const _$InteractionTypeEnumMap = {
  InteractionType.thisIsMe: 'thisIsMe',
  InteractionType.lookingForThis: 'lookingForThis',
  InteractionType.knowSomeone: 'knowSomeone',
  InteractionType.notRelevant: 'notRelevant',
};
