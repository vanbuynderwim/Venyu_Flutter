// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_country_language_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdateCountryLanguageRequest _$UpdateCountryLanguageRequestFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateCountryLanguageRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateCountryLanguageRequest {
  @JsonKey(name: 'country_code')
  String get countryCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'language_code')
  String get languageCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_version')
  String get appVersion => throw _privateConstructorUsedError;

  /// Serializes this UpdateCountryLanguageRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateCountryLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateCountryLanguageRequestCopyWith<UpdateCountryLanguageRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCountryLanguageRequestCopyWith<$Res> {
  factory $UpdateCountryLanguageRequestCopyWith(
    UpdateCountryLanguageRequest value,
    $Res Function(UpdateCountryLanguageRequest) then,
  ) =
      _$UpdateCountryLanguageRequestCopyWithImpl<
        $Res,
        UpdateCountryLanguageRequest
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'country_code') String countryCode,
    @JsonKey(name: 'language_code') String languageCode,
    @JsonKey(name: 'app_version') String appVersion,
  });
}

/// @nodoc
class _$UpdateCountryLanguageRequestCopyWithImpl<
  $Res,
  $Val extends UpdateCountryLanguageRequest
>
    implements $UpdateCountryLanguageRequestCopyWith<$Res> {
  _$UpdateCountryLanguageRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCountryLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryCode = null,
    Object? languageCode = null,
    Object? appVersion = null,
  }) {
    return _then(
      _value.copyWith(
            countryCode: null == countryCode
                ? _value.countryCode
                : countryCode // ignore: cast_nullable_to_non_nullable
                      as String,
            languageCode: null == languageCode
                ? _value.languageCode
                : languageCode // ignore: cast_nullable_to_non_nullable
                      as String,
            appVersion: null == appVersion
                ? _value.appVersion
                : appVersion // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateCountryLanguageRequestImplCopyWith<$Res>
    implements $UpdateCountryLanguageRequestCopyWith<$Res> {
  factory _$$UpdateCountryLanguageRequestImplCopyWith(
    _$UpdateCountryLanguageRequestImpl value,
    $Res Function(_$UpdateCountryLanguageRequestImpl) then,
  ) = __$$UpdateCountryLanguageRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'country_code') String countryCode,
    @JsonKey(name: 'language_code') String languageCode,
    @JsonKey(name: 'app_version') String appVersion,
  });
}

/// @nodoc
class __$$UpdateCountryLanguageRequestImplCopyWithImpl<$Res>
    extends
        _$UpdateCountryLanguageRequestCopyWithImpl<
          $Res,
          _$UpdateCountryLanguageRequestImpl
        >
    implements _$$UpdateCountryLanguageRequestImplCopyWith<$Res> {
  __$$UpdateCountryLanguageRequestImplCopyWithImpl(
    _$UpdateCountryLanguageRequestImpl _value,
    $Res Function(_$UpdateCountryLanguageRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateCountryLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryCode = null,
    Object? languageCode = null,
    Object? appVersion = null,
  }) {
    return _then(
      _$UpdateCountryLanguageRequestImpl(
        countryCode: null == countryCode
            ? _value.countryCode
            : countryCode // ignore: cast_nullable_to_non_nullable
                  as String,
        languageCode: null == languageCode
            ? _value.languageCode
            : languageCode // ignore: cast_nullable_to_non_nullable
                  as String,
        appVersion: null == appVersion
            ? _value.appVersion
            : appVersion // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateCountryLanguageRequestImpl
    implements _UpdateCountryLanguageRequest {
  const _$UpdateCountryLanguageRequestImpl({
    @JsonKey(name: 'country_code') required this.countryCode,
    @JsonKey(name: 'language_code') required this.languageCode,
    @JsonKey(name: 'app_version') required this.appVersion,
  });

  factory _$UpdateCountryLanguageRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$UpdateCountryLanguageRequestImplFromJson(json);

  @override
  @JsonKey(name: 'country_code')
  final String countryCode;
  @override
  @JsonKey(name: 'language_code')
  final String languageCode;
  @override
  @JsonKey(name: 'app_version')
  final String appVersion;

  @override
  String toString() {
    return 'UpdateCountryLanguageRequest(countryCode: $countryCode, languageCode: $languageCode, appVersion: $appVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCountryLanguageRequestImpl &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, countryCode, languageCode, appVersion);

  /// Create a copy of UpdateCountryLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCountryLanguageRequestImplCopyWith<
    _$UpdateCountryLanguageRequestImpl
  >
  get copyWith =>
      __$$UpdateCountryLanguageRequestImplCopyWithImpl<
        _$UpdateCountryLanguageRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateCountryLanguageRequestImplToJson(this);
  }
}

abstract class _UpdateCountryLanguageRequest
    implements UpdateCountryLanguageRequest {
  const factory _UpdateCountryLanguageRequest({
    @JsonKey(name: 'country_code') required final String countryCode,
    @JsonKey(name: 'language_code') required final String languageCode,
    @JsonKey(name: 'app_version') required final String appVersion,
  }) = _$UpdateCountryLanguageRequestImpl;

  factory _UpdateCountryLanguageRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateCountryLanguageRequestImpl.fromJson;

  @override
  @JsonKey(name: 'country_code')
  String get countryCode;
  @override
  @JsonKey(name: 'language_code')
  String get languageCode;
  @override
  @JsonKey(name: 'app_version')
  String get appVersion;

  /// Create a copy of UpdateCountryLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCountryLanguageRequestImplCopyWith<
    _$UpdateCountryLanguageRequestImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
