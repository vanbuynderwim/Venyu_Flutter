// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_name_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdateNameRequest _$UpdateNameRequestFromJson(Map<String, dynamic> json) {
  return _UpdateNameRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateNameRequest {
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'linkedin_url')
  String get linkedInURL => throw _privateConstructorUsedError;
  @JsonKey(name: 'linkedin_url_valid')
  bool get linkedInURLValid => throw _privateConstructorUsedError;

  /// Serializes this UpdateNameRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateNameRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateNameRequestCopyWith<UpdateNameRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateNameRequestCopyWith<$Res> {
  factory $UpdateNameRequestCopyWith(
    UpdateNameRequest value,
    $Res Function(UpdateNameRequest) then,
  ) = _$UpdateNameRequestCopyWithImpl<$Res, UpdateNameRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'first_name') String firstName,
    @JsonKey(name: 'last_name') String lastName,
    @JsonKey(name: 'linkedin_url') String linkedInURL,
    @JsonKey(name: 'linkedin_url_valid') bool linkedInURLValid,
  });
}

/// @nodoc
class _$UpdateNameRequestCopyWithImpl<$Res, $Val extends UpdateNameRequest>
    implements $UpdateNameRequestCopyWith<$Res> {
  _$UpdateNameRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateNameRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? linkedInURL = null,
    Object? linkedInURLValid = null,
  }) {
    return _then(
      _value.copyWith(
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            linkedInURL: null == linkedInURL
                ? _value.linkedInURL
                : linkedInURL // ignore: cast_nullable_to_non_nullable
                      as String,
            linkedInURLValid: null == linkedInURLValid
                ? _value.linkedInURLValid
                : linkedInURLValid // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateNameRequestImplCopyWith<$Res>
    implements $UpdateNameRequestCopyWith<$Res> {
  factory _$$UpdateNameRequestImplCopyWith(
    _$UpdateNameRequestImpl value,
    $Res Function(_$UpdateNameRequestImpl) then,
  ) = __$$UpdateNameRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'first_name') String firstName,
    @JsonKey(name: 'last_name') String lastName,
    @JsonKey(name: 'linkedin_url') String linkedInURL,
    @JsonKey(name: 'linkedin_url_valid') bool linkedInURLValid,
  });
}

/// @nodoc
class __$$UpdateNameRequestImplCopyWithImpl<$Res>
    extends _$UpdateNameRequestCopyWithImpl<$Res, _$UpdateNameRequestImpl>
    implements _$$UpdateNameRequestImplCopyWith<$Res> {
  __$$UpdateNameRequestImplCopyWithImpl(
    _$UpdateNameRequestImpl _value,
    $Res Function(_$UpdateNameRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateNameRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? linkedInURL = null,
    Object? linkedInURLValid = null,
  }) {
    return _then(
      _$UpdateNameRequestImpl(
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        linkedInURL: null == linkedInURL
            ? _value.linkedInURL
            : linkedInURL // ignore: cast_nullable_to_non_nullable
                  as String,
        linkedInURLValid: null == linkedInURLValid
            ? _value.linkedInURLValid
            : linkedInURLValid // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateNameRequestImpl implements _UpdateNameRequest {
  const _$UpdateNameRequestImpl({
    @JsonKey(name: 'first_name') required this.firstName,
    @JsonKey(name: 'last_name') required this.lastName,
    @JsonKey(name: 'linkedin_url') required this.linkedInURL,
    @JsonKey(name: 'linkedin_url_valid') required this.linkedInURLValid,
  });

  factory _$UpdateNameRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateNameRequestImplFromJson(json);

  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  @JsonKey(name: 'linkedin_url')
  final String linkedInURL;
  @override
  @JsonKey(name: 'linkedin_url_valid')
  final bool linkedInURLValid;

  @override
  String toString() {
    return 'UpdateNameRequest(firstName: $firstName, lastName: $lastName, linkedInURL: $linkedInURL, linkedInURLValid: $linkedInURLValid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateNameRequestImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.linkedInURL, linkedInURL) ||
                other.linkedInURL == linkedInURL) &&
            (identical(other.linkedInURLValid, linkedInURLValid) ||
                other.linkedInURLValid == linkedInURLValid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    firstName,
    lastName,
    linkedInURL,
    linkedInURLValid,
  );

  /// Create a copy of UpdateNameRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateNameRequestImplCopyWith<_$UpdateNameRequestImpl> get copyWith =>
      __$$UpdateNameRequestImplCopyWithImpl<_$UpdateNameRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateNameRequestImplToJson(this);
  }
}

abstract class _UpdateNameRequest implements UpdateNameRequest {
  const factory _UpdateNameRequest({
    @JsonKey(name: 'first_name') required final String firstName,
    @JsonKey(name: 'last_name') required final String lastName,
    @JsonKey(name: 'linkedin_url') required final String linkedInURL,
    @JsonKey(name: 'linkedin_url_valid') required final bool linkedInURLValid,
  }) = _$UpdateNameRequestImpl;

  factory _UpdateNameRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateNameRequestImpl.fromJson;

  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  @JsonKey(name: 'linkedin_url')
  String get linkedInURL;
  @override
  @JsonKey(name: 'linkedin_url_valid')
  bool get linkedInURLValid;

  /// Create a copy of UpdateNameRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateNameRequestImplCopyWith<_$UpdateNameRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
