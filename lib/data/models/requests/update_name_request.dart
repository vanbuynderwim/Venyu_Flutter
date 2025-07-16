// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_name_request.freezed.dart';
part 'update_name_request.g.dart';

@freezed
class UpdateNameRequest with _$UpdateNameRequest {
  const factory UpdateNameRequest({
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'linkedin_url') required String linkedInURL,
    @JsonKey(name: 'linkedin_url_valid') required bool linkedInURLValid,
  }) = _UpdateNameRequest;

  factory UpdateNameRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNameRequestFromJson(json);
}