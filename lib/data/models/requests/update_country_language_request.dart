// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_country_language_request.freezed.dart';
part 'update_country_language_request.g.dart';

@freezed
class UpdateCountryLanguageRequest with _$UpdateCountryLanguageRequest {
  const factory UpdateCountryLanguageRequest({
    @JsonKey(name: 'country_code') required String countryCode,
    @JsonKey(name: 'language_code') required String languageCode,
    @JsonKey(name: 'app_version') required String appVersion,
  }) = _UpdateCountryLanguageRequest;

  factory UpdateCountryLanguageRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCountryLanguageRequestFromJson(json);
}