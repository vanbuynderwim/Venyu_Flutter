// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) {
  return _MatchModel.fromJson(json);
}

/// @nodoc
mixin _$MatchModel {
  String get id => throw _privateConstructorUsedError;
  ProfileModel get profile => throw _privateConstructorUsedError;
  MatchStatus get status => throw _privateConstructorUsedError;
  double? get score => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  MatchResponse? get response => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<PromptModel>? get prompts => throw _privateConstructorUsedError;
  List<MatchModel>? get connections => throw _privateConstructorUsedError;
  @JsonKey(name: 'unread_count')
  int? get unreadCount => throw _privateConstructorUsedError;

  /// Serializes this MatchModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchModelCopyWith<MatchModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchModelCopyWith<$Res> {
  factory $MatchModelCopyWith(
    MatchModel value,
    $Res Function(MatchModel) then,
  ) = _$MatchModelCopyWithImpl<$Res, MatchModel>;
  @useResult
  $Res call({
    String id,
    ProfileModel profile,
    MatchStatus status,
    double? score,
    String? reason,
    MatchResponse? response,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    List<PromptModel>? prompts,
    List<MatchModel>? connections,
    @JsonKey(name: 'unread_count') int? unreadCount,
  });

  $ProfileModelCopyWith<$Res> get profile;
}

/// @nodoc
class _$MatchModelCopyWithImpl<$Res, $Val extends MatchModel>
    implements $MatchModelCopyWith<$Res> {
  _$MatchModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profile = null,
    Object? status = null,
    Object? score = freezed,
    Object? reason = freezed,
    Object? response = freezed,
    Object? updatedAt = freezed,
    Object? prompts = freezed,
    Object? connections = freezed,
    Object? unreadCount = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            profile: null == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as ProfileModel,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MatchStatus,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double?,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
            response: freezed == response
                ? _value.response
                : response // ignore: cast_nullable_to_non_nullable
                      as MatchResponse?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            prompts: freezed == prompts
                ? _value.prompts
                : prompts // ignore: cast_nullable_to_non_nullable
                      as List<PromptModel>?,
            connections: freezed == connections
                ? _value.connections
                : connections // ignore: cast_nullable_to_non_nullable
                      as List<MatchModel>?,
            unreadCount: freezed == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileModelCopyWith<$Res> get profile {
    return $ProfileModelCopyWith<$Res>(_value.profile, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MatchModelImplCopyWith<$Res>
    implements $MatchModelCopyWith<$Res> {
  factory _$$MatchModelImplCopyWith(
    _$MatchModelImpl value,
    $Res Function(_$MatchModelImpl) then,
  ) = __$$MatchModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    ProfileModel profile,
    MatchStatus status,
    double? score,
    String? reason,
    MatchResponse? response,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    List<PromptModel>? prompts,
    List<MatchModel>? connections,
    @JsonKey(name: 'unread_count') int? unreadCount,
  });

  @override
  $ProfileModelCopyWith<$Res> get profile;
}

/// @nodoc
class __$$MatchModelImplCopyWithImpl<$Res>
    extends _$MatchModelCopyWithImpl<$Res, _$MatchModelImpl>
    implements _$$MatchModelImplCopyWith<$Res> {
  __$$MatchModelImplCopyWithImpl(
    _$MatchModelImpl _value,
    $Res Function(_$MatchModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profile = null,
    Object? status = null,
    Object? score = freezed,
    Object? reason = freezed,
    Object? response = freezed,
    Object? updatedAt = freezed,
    Object? prompts = freezed,
    Object? connections = freezed,
    Object? unreadCount = freezed,
  }) {
    return _then(
      _$MatchModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        profile: null == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as ProfileModel,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MatchStatus,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double?,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        response: freezed == response
            ? _value.response
            : response // ignore: cast_nullable_to_non_nullable
                  as MatchResponse?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        prompts: freezed == prompts
            ? _value._prompts
            : prompts // ignore: cast_nullable_to_non_nullable
                  as List<PromptModel>?,
        connections: freezed == connections
            ? _value._connections
            : connections // ignore: cast_nullable_to_non_nullable
                  as List<MatchModel>?,
        unreadCount: freezed == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchModelImpl implements _MatchModel {
  const _$MatchModelImpl({
    required this.id,
    required this.profile,
    required this.status,
    this.score,
    this.reason,
    this.response,
    @JsonKey(name: 'updated_at') this.updatedAt,
    final List<PromptModel>? prompts,
    final List<MatchModel>? connections,
    @JsonKey(name: 'unread_count') this.unreadCount,
  }) : _prompts = prompts,
       _connections = connections;

  factory _$MatchModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchModelImplFromJson(json);

  @override
  final String id;
  @override
  final ProfileModel profile;
  @override
  final MatchStatus status;
  @override
  final double? score;
  @override
  final String? reason;
  @override
  final MatchResponse? response;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<PromptModel>? _prompts;
  @override
  List<PromptModel>? get prompts {
    final value = _prompts;
    if (value == null) return null;
    if (_prompts is EqualUnmodifiableListView) return _prompts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<MatchModel>? _connections;
  @override
  List<MatchModel>? get connections {
    final value = _connections;
    if (value == null) return null;
    if (_connections is EqualUnmodifiableListView) return _connections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'unread_count')
  final int? unreadCount;

  @override
  String toString() {
    return 'MatchModel(id: $id, profile: $profile, status: $status, score: $score, reason: $reason, response: $response, updatedAt: $updatedAt, prompts: $prompts, connections: $connections, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._prompts, _prompts) &&
            const DeepCollectionEquality().equals(
              other._connections,
              _connections,
            ) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    profile,
    status,
    score,
    reason,
    response,
    updatedAt,
    const DeepCollectionEquality().hash(_prompts),
    const DeepCollectionEquality().hash(_connections),
    unreadCount,
  );

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchModelImplCopyWith<_$MatchModelImpl> get copyWith =>
      __$$MatchModelImplCopyWithImpl<_$MatchModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchModelImplToJson(this);
  }
}

abstract class _MatchModel implements MatchModel {
  const factory _MatchModel({
    required final String id,
    required final ProfileModel profile,
    required final MatchStatus status,
    final double? score,
    final String? reason,
    final MatchResponse? response,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    final List<PromptModel>? prompts,
    final List<MatchModel>? connections,
    @JsonKey(name: 'unread_count') final int? unreadCount,
  }) = _$MatchModelImpl;

  factory _MatchModel.fromJson(Map<String, dynamic> json) =
      _$MatchModelImpl.fromJson;

  @override
  String get id;
  @override
  ProfileModel get profile;
  @override
  MatchStatus get status;
  @override
  double? get score;
  @override
  String? get reason;
  @override
  MatchResponse? get response;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  List<PromptModel>? get prompts;
  @override
  List<MatchModel>? get connections;
  @override
  @JsonKey(name: 'unread_count')
  int? get unreadCount;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchModelImplCopyWith<_$MatchModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
