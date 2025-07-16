// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prompt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PromptModel _$PromptModelFromJson(Map<String, dynamic> json) {
  return _PromptModel.fromJson(json);
}

/// @nodoc
mixin _$PromptModel {
  @JsonKey(name: 'feed_id')
  int? get feedID => throw _privateConstructorUsedError;
  @JsonKey(name: 'prompt_id')
  String get promptID => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  PromptStatus? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'impression_count')
  int? get impressionCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'interaction_type')
  InteractionType? get interactionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'match_interaction_type')
  InteractionType? get matchInteractionType =>
      throw _privateConstructorUsedError;
  ProfileModel? get profile => throw _privateConstructorUsedError;

  /// Serializes this PromptModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PromptModelCopyWith<PromptModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromptModelCopyWith<$Res> {
  factory $PromptModelCopyWith(
    PromptModel value,
    $Res Function(PromptModel) then,
  ) = _$PromptModelCopyWithImpl<$Res, PromptModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'feed_id') int? feedID,
    @JsonKey(name: 'prompt_id') String promptID,
    String label,
    PromptStatus? status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'impression_count') int? impressionCount,
    @JsonKey(name: 'interaction_type') InteractionType? interactionType,
    @JsonKey(name: 'match_interaction_type')
    InteractionType? matchInteractionType,
    ProfileModel? profile,
  });

  $ProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class _$PromptModelCopyWithImpl<$Res, $Val extends PromptModel>
    implements $PromptModelCopyWith<$Res> {
  _$PromptModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedID = freezed,
    Object? promptID = null,
    Object? label = null,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? impressionCount = freezed,
    Object? interactionType = freezed,
    Object? matchInteractionType = freezed,
    Object? profile = freezed,
  }) {
    return _then(
      _value.copyWith(
            feedID: freezed == feedID
                ? _value.feedID
                : feedID // ignore: cast_nullable_to_non_nullable
                      as int?,
            promptID: null == promptID
                ? _value.promptID
                : promptID // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PromptStatus?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            impressionCount: freezed == impressionCount
                ? _value.impressionCount
                : impressionCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            interactionType: freezed == interactionType
                ? _value.interactionType
                : interactionType // ignore: cast_nullable_to_non_nullable
                      as InteractionType?,
            matchInteractionType: freezed == matchInteractionType
                ? _value.matchInteractionType
                : matchInteractionType // ignore: cast_nullable_to_non_nullable
                      as InteractionType?,
            profile: freezed == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as ProfileModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileModelCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileModelCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PromptModelImplCopyWith<$Res>
    implements $PromptModelCopyWith<$Res> {
  factory _$$PromptModelImplCopyWith(
    _$PromptModelImpl value,
    $Res Function(_$PromptModelImpl) then,
  ) = __$$PromptModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'feed_id') int? feedID,
    @JsonKey(name: 'prompt_id') String promptID,
    String label,
    PromptStatus? status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'impression_count') int? impressionCount,
    @JsonKey(name: 'interaction_type') InteractionType? interactionType,
    @JsonKey(name: 'match_interaction_type')
    InteractionType? matchInteractionType,
    ProfileModel? profile,
  });

  @override
  $ProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$PromptModelImplCopyWithImpl<$Res>
    extends _$PromptModelCopyWithImpl<$Res, _$PromptModelImpl>
    implements _$$PromptModelImplCopyWith<$Res> {
  __$$PromptModelImplCopyWithImpl(
    _$PromptModelImpl _value,
    $Res Function(_$PromptModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedID = freezed,
    Object? promptID = null,
    Object? label = null,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? impressionCount = freezed,
    Object? interactionType = freezed,
    Object? matchInteractionType = freezed,
    Object? profile = freezed,
  }) {
    return _then(
      _$PromptModelImpl(
        feedID: freezed == feedID
            ? _value.feedID
            : feedID // ignore: cast_nullable_to_non_nullable
                  as int?,
        promptID: null == promptID
            ? _value.promptID
            : promptID // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PromptStatus?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        impressionCount: freezed == impressionCount
            ? _value.impressionCount
            : impressionCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        interactionType: freezed == interactionType
            ? _value.interactionType
            : interactionType // ignore: cast_nullable_to_non_nullable
                  as InteractionType?,
        matchInteractionType: freezed == matchInteractionType
            ? _value.matchInteractionType
            : matchInteractionType // ignore: cast_nullable_to_non_nullable
                  as InteractionType?,
        profile: freezed == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as ProfileModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PromptModelImpl implements _PromptModel {
  const _$PromptModelImpl({
    @JsonKey(name: 'feed_id') this.feedID,
    @JsonKey(name: 'prompt_id') required this.promptID,
    required this.label,
    this.status,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'impression_count') this.impressionCount,
    @JsonKey(name: 'interaction_type') this.interactionType,
    @JsonKey(name: 'match_interaction_type') this.matchInteractionType,
    this.profile,
  });

  factory _$PromptModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromptModelImplFromJson(json);

  @override
  @JsonKey(name: 'feed_id')
  final int? feedID;
  @override
  @JsonKey(name: 'prompt_id')
  final String promptID;
  @override
  final String label;
  @override
  final PromptStatus? status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'impression_count')
  final int? impressionCount;
  @override
  @JsonKey(name: 'interaction_type')
  final InteractionType? interactionType;
  @override
  @JsonKey(name: 'match_interaction_type')
  final InteractionType? matchInteractionType;
  @override
  final ProfileModel? profile;

  @override
  String toString() {
    return 'PromptModel(feedID: $feedID, promptID: $promptID, label: $label, status: $status, createdAt: $createdAt, impressionCount: $impressionCount, interactionType: $interactionType, matchInteractionType: $matchInteractionType, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromptModelImpl &&
            (identical(other.feedID, feedID) || other.feedID == feedID) &&
            (identical(other.promptID, promptID) ||
                other.promptID == promptID) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.impressionCount, impressionCount) ||
                other.impressionCount == impressionCount) &&
            (identical(other.interactionType, interactionType) ||
                other.interactionType == interactionType) &&
            (identical(other.matchInteractionType, matchInteractionType) ||
                other.matchInteractionType == matchInteractionType) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    feedID,
    promptID,
    label,
    status,
    createdAt,
    impressionCount,
    interactionType,
    matchInteractionType,
    profile,
  );

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PromptModelImplCopyWith<_$PromptModelImpl> get copyWith =>
      __$$PromptModelImplCopyWithImpl<_$PromptModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromptModelImplToJson(this);
  }
}

abstract class _PromptModel implements PromptModel {
  const factory _PromptModel({
    @JsonKey(name: 'feed_id') final int? feedID,
    @JsonKey(name: 'prompt_id') required final String promptID,
    required final String label,
    final PromptStatus? status,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'impression_count') final int? impressionCount,
    @JsonKey(name: 'interaction_type') final InteractionType? interactionType,
    @JsonKey(name: 'match_interaction_type')
    final InteractionType? matchInteractionType,
    final ProfileModel? profile,
  }) = _$PromptModelImpl;

  factory _PromptModel.fromJson(Map<String, dynamic> json) =
      _$PromptModelImpl.fromJson;

  @override
  @JsonKey(name: 'feed_id')
  int? get feedID;
  @override
  @JsonKey(name: 'prompt_id')
  String get promptID;
  @override
  String get label;
  @override
  PromptStatus? get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'impression_count')
  int? get impressionCount;
  @override
  @JsonKey(name: 'interaction_type')
  InteractionType? get interactionType;
  @override
  @JsonKey(name: 'match_interaction_type')
  InteractionType? get matchInteractionType;
  @override
  ProfileModel? get profile;

  /// Create a copy of PromptModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PromptModelImplCopyWith<_$PromptModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
