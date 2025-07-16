// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginatedRequest _$PaginatedRequestFromJson(Map<String, dynamic> json) {
  return _PaginatedRequest.fromJson(json);
}

/// @nodoc
mixin _$PaginatedRequest {
  int get limit => throw _privateConstructorUsedError;
  String? get cursorId => throw _privateConstructorUsedError;
  DateTime? get cursorTime => throw _privateConstructorUsedError;
  MatchStatus? get cursorStatus => throw _privateConstructorUsedError;
  ServerListType get list => throw _privateConstructorUsedError;

  /// Serializes this PaginatedRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedRequestCopyWith<PaginatedRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedRequestCopyWith<$Res> {
  factory $PaginatedRequestCopyWith(
    PaginatedRequest value,
    $Res Function(PaginatedRequest) then,
  ) = _$PaginatedRequestCopyWithImpl<$Res, PaginatedRequest>;
  @useResult
  $Res call({
    int limit,
    String? cursorId,
    DateTime? cursorTime,
    MatchStatus? cursorStatus,
    ServerListType list,
  });
}

/// @nodoc
class _$PaginatedRequestCopyWithImpl<$Res, $Val extends PaginatedRequest>
    implements $PaginatedRequestCopyWith<$Res> {
  _$PaginatedRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? limit = null,
    Object? cursorId = freezed,
    Object? cursorTime = freezed,
    Object? cursorStatus = freezed,
    Object? list = null,
  }) {
    return _then(
      _value.copyWith(
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            cursorId: freezed == cursorId
                ? _value.cursorId
                : cursorId // ignore: cast_nullable_to_non_nullable
                      as String?,
            cursorTime: freezed == cursorTime
                ? _value.cursorTime
                : cursorTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cursorStatus: freezed == cursorStatus
                ? _value.cursorStatus
                : cursorStatus // ignore: cast_nullable_to_non_nullable
                      as MatchStatus?,
            list: null == list
                ? _value.list
                : list // ignore: cast_nullable_to_non_nullable
                      as ServerListType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedRequestImplCopyWith<$Res>
    implements $PaginatedRequestCopyWith<$Res> {
  factory _$$PaginatedRequestImplCopyWith(
    _$PaginatedRequestImpl value,
    $Res Function(_$PaginatedRequestImpl) then,
  ) = __$$PaginatedRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int limit,
    String? cursorId,
    DateTime? cursorTime,
    MatchStatus? cursorStatus,
    ServerListType list,
  });
}

/// @nodoc
class __$$PaginatedRequestImplCopyWithImpl<$Res>
    extends _$PaginatedRequestCopyWithImpl<$Res, _$PaginatedRequestImpl>
    implements _$$PaginatedRequestImplCopyWith<$Res> {
  __$$PaginatedRequestImplCopyWithImpl(
    _$PaginatedRequestImpl _value,
    $Res Function(_$PaginatedRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? limit = null,
    Object? cursorId = freezed,
    Object? cursorTime = freezed,
    Object? cursorStatus = freezed,
    Object? list = null,
  }) {
    return _then(
      _$PaginatedRequestImpl(
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        cursorId: freezed == cursorId
            ? _value.cursorId
            : cursorId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cursorTime: freezed == cursorTime
            ? _value.cursorTime
            : cursorTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cursorStatus: freezed == cursorStatus
            ? _value.cursorStatus
            : cursorStatus // ignore: cast_nullable_to_non_nullable
                  as MatchStatus?,
        list: null == list
            ? _value.list
            : list // ignore: cast_nullable_to_non_nullable
                  as ServerListType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedRequestImpl implements _PaginatedRequest {
  const _$PaginatedRequestImpl({
    required this.limit,
    this.cursorId,
    this.cursorTime,
    this.cursorStatus,
    required this.list,
  });

  factory _$PaginatedRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedRequestImplFromJson(json);

  @override
  final int limit;
  @override
  final String? cursorId;
  @override
  final DateTime? cursorTime;
  @override
  final MatchStatus? cursorStatus;
  @override
  final ServerListType list;

  @override
  String toString() {
    return 'PaginatedRequest(limit: $limit, cursorId: $cursorId, cursorTime: $cursorTime, cursorStatus: $cursorStatus, list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedRequestImpl &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.cursorId, cursorId) ||
                other.cursorId == cursorId) &&
            (identical(other.cursorTime, cursorTime) ||
                other.cursorTime == cursorTime) &&
            (identical(other.cursorStatus, cursorStatus) ||
                other.cursorStatus == cursorStatus) &&
            (identical(other.list, list) || other.list == list));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, limit, cursorId, cursorTime, cursorStatus, list);

  /// Create a copy of PaginatedRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedRequestImplCopyWith<_$PaginatedRequestImpl> get copyWith =>
      __$$PaginatedRequestImplCopyWithImpl<_$PaginatedRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedRequestImplToJson(this);
  }
}

abstract class _PaginatedRequest implements PaginatedRequest {
  const factory _PaginatedRequest({
    required final int limit,
    final String? cursorId,
    final DateTime? cursorTime,
    final MatchStatus? cursorStatus,
    required final ServerListType list,
  }) = _$PaginatedRequestImpl;

  factory _PaginatedRequest.fromJson(Map<String, dynamic> json) =
      _$PaginatedRequestImpl.fromJson;

  @override
  int get limit;
  @override
  String? get cursorId;
  @override
  DateTime? get cursorTime;
  @override
  MatchStatus? get cursorStatus;
  @override
  ServerListType get list;

  /// Create a copy of PaginatedRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedRequestImplCopyWith<_$PaginatedRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
