// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'tag_group_model.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'company_name') String? companyName,
    String? bio,
    @JsonKey(name: 'linkedin_url') String? linkedInURL,
    @JsonKey(name: 'website_url') String? websiteURL,
    @JsonKey(name: 'contact_email') String? contactEmail,
    @JsonKey(name: 'show_email') bool? showEmail,
    @JsonKey(name: 'avatar_id') String? avatarID,
    DateTime? timestamp,
    @JsonKey(name: 'registered_at') DateTime? registeredAt,
    double? distance,
    @Default(false) @JsonKey(name: 'is_super_admin') bool isSuperAdmin,
    @JsonKey(name: 'newsletter_subscribed') bool? newsletterSubscribed,
    @JsonKey(name: 'public_key') String? publicKey,
    List<TagGroupModel>? taggroups,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}