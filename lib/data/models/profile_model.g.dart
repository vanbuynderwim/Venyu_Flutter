// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      companyName: json['company_name'] as String?,
      bio: json['bio'] as String?,
      linkedInURL: json['linkedin_url'] as String?,
      websiteURL: json['website_url'] as String?,
      contactEmail: json['contact_email'] as String?,
      showEmail: json['show_email'] as bool?,
      avatarID: json['avatar_id'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      registeredAt: json['registered_at'] == null
          ? null
          : DateTime.parse(json['registered_at'] as String),
      distance: (json['distance'] as num?)?.toDouble(),
      isSuperAdmin: json['is_super_admin'] as bool? ?? false,
      newsletterSubscribed: json['newsletter_subscribed'] as bool?,
      publicKey: json['public_key'] as String?,
      taggroups: (json['taggroups'] as List<dynamic>?)
          ?.map((e) => TagGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'company_name': instance.companyName,
      'bio': instance.bio,
      'linkedin_url': instance.linkedInURL,
      'website_url': instance.websiteURL,
      'contact_email': instance.contactEmail,
      'show_email': instance.showEmail,
      'avatar_id': instance.avatarID,
      'timestamp': instance.timestamp?.toIso8601String(),
      'registered_at': instance.registeredAt?.toIso8601String(),
      'distance': instance.distance,
      'is_super_admin': instance.isSuperAdmin,
      'newsletter_subscribed': instance.newsletterSubscribed,
      'public_key': instance.publicKey,
      'taggroups': instance.taggroups,
    };
