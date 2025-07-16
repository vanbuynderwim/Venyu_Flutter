// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_country_language_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateCountryLanguageRequestImpl _$$UpdateCountryLanguageRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateCountryLanguageRequestImpl(
  countryCode: json['country_code'] as String,
  languageCode: json['language_code'] as String,
  appVersion: json['app_version'] as String,
);

Map<String, dynamic> _$$UpdateCountryLanguageRequestImplToJson(
  _$UpdateCountryLanguageRequestImpl instance,
) => <String, dynamic>{
  'country_code': instance.countryCode,
  'language_code': instance.languageCode,
  'app_version': instance.appVersion,
};
