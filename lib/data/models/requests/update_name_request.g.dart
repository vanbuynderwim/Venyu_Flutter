// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_name_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateNameRequestImpl _$$UpdateNameRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateNameRequestImpl(
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  linkedInURL: json['linkedin_url'] as String,
  linkedInURLValid: json['linkedin_url_valid'] as bool,
);

Map<String, dynamic> _$$UpdateNameRequestImplToJson(
  _$UpdateNameRequestImpl instance,
) => <String, dynamic>{
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'linkedin_url': instance.linkedInURL,
  'linkedin_url_valid': instance.linkedInURLValid,
};
