// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return _ProfileModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'linkedin_url')
  String? get linkedInURL => throw _privateConstructorUsedError;
  @JsonKey(name: 'website_url')
  String? get websiteURL => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_email')
  String? get contactEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_email')
  bool? get showEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_id')
  String? get avatarID => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'registered_at')
  DateTime? get registeredAt => throw _privateConstructorUsedError;
  double? get distance => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_super_admin')
  bool get isSuperAdmin => throw _privateConstructorUsedError;
  @JsonKey(name: 'newsletter_subscribed')
  bool? get newsletterSubscribed => throw _privateConstructorUsedError;
  @JsonKey(name: 'public_key')
  String? get publicKey => throw _privateConstructorUsedError;
  List<TagGroupModel>? get taggroups => throw _privateConstructorUsedError;

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileModelCopyWith<ProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileModelCopyWith<$Res> {
  factory $ProfileModelCopyWith(
    ProfileModel value,
    $Res Function(ProfileModel) then,
  ) = _$ProfileModelCopyWithImpl<$Res, ProfileModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'first_name') String firstName,
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
    @JsonKey(name: 'is_super_admin') bool isSuperAdmin,
    @JsonKey(name: 'newsletter_subscribed') bool? newsletterSubscribed,
    @JsonKey(name: 'public_key') String? publicKey,
    List<TagGroupModel>? taggroups,
  });
}

/// @nodoc
class _$ProfileModelCopyWithImpl<$Res, $Val extends ProfileModel>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = freezed,
    Object? companyName = freezed,
    Object? bio = freezed,
    Object? linkedInURL = freezed,
    Object? websiteURL = freezed,
    Object? contactEmail = freezed,
    Object? showEmail = freezed,
    Object? avatarID = freezed,
    Object? timestamp = freezed,
    Object? registeredAt = freezed,
    Object? distance = freezed,
    Object? isSuperAdmin = null,
    Object? newsletterSubscribed = freezed,
    Object? publicKey = freezed,
    Object? taggroups = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyName: freezed == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            linkedInURL: freezed == linkedInURL
                ? _value.linkedInURL
                : linkedInURL // ignore: cast_nullable_to_non_nullable
                      as String?,
            websiteURL: freezed == websiteURL
                ? _value.websiteURL
                : websiteURL // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactEmail: freezed == contactEmail
                ? _value.contactEmail
                : contactEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            showEmail: freezed == showEmail
                ? _value.showEmail
                : showEmail // ignore: cast_nullable_to_non_nullable
                      as bool?,
            avatarID: freezed == avatarID
                ? _value.avatarID
                : avatarID // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: freezed == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            registeredAt: freezed == registeredAt
                ? _value.registeredAt
                : registeredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            distance: freezed == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double?,
            isSuperAdmin: null == isSuperAdmin
                ? _value.isSuperAdmin
                : isSuperAdmin // ignore: cast_nullable_to_non_nullable
                      as bool,
            newsletterSubscribed: freezed == newsletterSubscribed
                ? _value.newsletterSubscribed
                : newsletterSubscribed // ignore: cast_nullable_to_non_nullable
                      as bool?,
            publicKey: freezed == publicKey
                ? _value.publicKey
                : publicKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            taggroups: freezed == taggroups
                ? _value.taggroups
                : taggroups // ignore: cast_nullable_to_non_nullable
                      as List<TagGroupModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfileModelImplCopyWith<$Res>
    implements $ProfileModelCopyWith<$Res> {
  factory _$$ProfileModelImplCopyWith(
    _$ProfileModelImpl value,
    $Res Function(_$ProfileModelImpl) then,
  ) = __$$ProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'first_name') String firstName,
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
    @JsonKey(name: 'is_super_admin') bool isSuperAdmin,
    @JsonKey(name: 'newsletter_subscribed') bool? newsletterSubscribed,
    @JsonKey(name: 'public_key') String? publicKey,
    List<TagGroupModel>? taggroups,
  });
}

/// @nodoc
class __$$ProfileModelImplCopyWithImpl<$Res>
    extends _$ProfileModelCopyWithImpl<$Res, _$ProfileModelImpl>
    implements _$$ProfileModelImplCopyWith<$Res> {
  __$$ProfileModelImplCopyWithImpl(
    _$ProfileModelImpl _value,
    $Res Function(_$ProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = freezed,
    Object? companyName = freezed,
    Object? bio = freezed,
    Object? linkedInURL = freezed,
    Object? websiteURL = freezed,
    Object? contactEmail = freezed,
    Object? showEmail = freezed,
    Object? avatarID = freezed,
    Object? timestamp = freezed,
    Object? registeredAt = freezed,
    Object? distance = freezed,
    Object? isSuperAdmin = null,
    Object? newsletterSubscribed = freezed,
    Object? publicKey = freezed,
    Object? taggroups = freezed,
  }) {
    return _then(
      _$ProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyName: freezed == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        linkedInURL: freezed == linkedInURL
            ? _value.linkedInURL
            : linkedInURL // ignore: cast_nullable_to_non_nullable
                  as String?,
        websiteURL: freezed == websiteURL
            ? _value.websiteURL
            : websiteURL // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactEmail: freezed == contactEmail
            ? _value.contactEmail
            : contactEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        showEmail: freezed == showEmail
            ? _value.showEmail
            : showEmail // ignore: cast_nullable_to_non_nullable
                  as bool?,
        avatarID: freezed == avatarID
            ? _value.avatarID
            : avatarID // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: freezed == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        registeredAt: freezed == registeredAt
            ? _value.registeredAt
            : registeredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        distance: freezed == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double?,
        isSuperAdmin: null == isSuperAdmin
            ? _value.isSuperAdmin
            : isSuperAdmin // ignore: cast_nullable_to_non_nullable
                  as bool,
        newsletterSubscribed: freezed == newsletterSubscribed
            ? _value.newsletterSubscribed
            : newsletterSubscribed // ignore: cast_nullable_to_non_nullable
                  as bool?,
        publicKey: freezed == publicKey
            ? _value.publicKey
            : publicKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        taggroups: freezed == taggroups
            ? _value._taggroups
            : taggroups // ignore: cast_nullable_to_non_nullable
                  as List<TagGroupModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileModelImpl implements _ProfileModel {
  const _$ProfileModelImpl({
    required this.id,
    @JsonKey(name: 'first_name') required this.firstName,
    @JsonKey(name: 'last_name') this.lastName,
    @JsonKey(name: 'company_name') this.companyName,
    this.bio,
    @JsonKey(name: 'linkedin_url') this.linkedInURL,
    @JsonKey(name: 'website_url') this.websiteURL,
    @JsonKey(name: 'contact_email') this.contactEmail,
    @JsonKey(name: 'show_email') this.showEmail,
    @JsonKey(name: 'avatar_id') this.avatarID,
    this.timestamp,
    @JsonKey(name: 'registered_at') this.registeredAt,
    this.distance,
    @JsonKey(name: 'is_super_admin') this.isSuperAdmin = false,
    @JsonKey(name: 'newsletter_subscribed') this.newsletterSubscribed,
    @JsonKey(name: 'public_key') this.publicKey,
    final List<TagGroupModel>? taggroups,
  }) : _taggroups = taggroups;

  factory _$ProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  final String? bio;
  @override
  @JsonKey(name: 'linkedin_url')
  final String? linkedInURL;
  @override
  @JsonKey(name: 'website_url')
  final String? websiteURL;
  @override
  @JsonKey(name: 'contact_email')
  final String? contactEmail;
  @override
  @JsonKey(name: 'show_email')
  final bool? showEmail;
  @override
  @JsonKey(name: 'avatar_id')
  final String? avatarID;
  @override
  final DateTime? timestamp;
  @override
  @JsonKey(name: 'registered_at')
  final DateTime? registeredAt;
  @override
  final double? distance;
  @override
  @JsonKey(name: 'is_super_admin')
  final bool isSuperAdmin;
  @override
  @JsonKey(name: 'newsletter_subscribed')
  final bool? newsletterSubscribed;
  @override
  @JsonKey(name: 'public_key')
  final String? publicKey;
  final List<TagGroupModel>? _taggroups;
  @override
  List<TagGroupModel>? get taggroups {
    final value = _taggroups;
    if (value == null) return null;
    if (_taggroups is EqualUnmodifiableListView) return _taggroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProfileModel(id: $id, firstName: $firstName, lastName: $lastName, companyName: $companyName, bio: $bio, linkedInURL: $linkedInURL, websiteURL: $websiteURL, contactEmail: $contactEmail, showEmail: $showEmail, avatarID: $avatarID, timestamp: $timestamp, registeredAt: $registeredAt, distance: $distance, isSuperAdmin: $isSuperAdmin, newsletterSubscribed: $newsletterSubscribed, publicKey: $publicKey, taggroups: $taggroups)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.linkedInURL, linkedInURL) ||
                other.linkedInURL == linkedInURL) &&
            (identical(other.websiteURL, websiteURL) ||
                other.websiteURL == websiteURL) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.showEmail, showEmail) ||
                other.showEmail == showEmail) &&
            (identical(other.avatarID, avatarID) ||
                other.avatarID == avatarID) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.registeredAt, registeredAt) ||
                other.registeredAt == registeredAt) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.isSuperAdmin, isSuperAdmin) ||
                other.isSuperAdmin == isSuperAdmin) &&
            (identical(other.newsletterSubscribed, newsletterSubscribed) ||
                other.newsletterSubscribed == newsletterSubscribed) &&
            (identical(other.publicKey, publicKey) ||
                other.publicKey == publicKey) &&
            const DeepCollectionEquality().equals(
              other._taggroups,
              _taggroups,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    companyName,
    bio,
    linkedInURL,
    websiteURL,
    contactEmail,
    showEmail,
    avatarID,
    timestamp,
    registeredAt,
    distance,
    isSuperAdmin,
    newsletterSubscribed,
    publicKey,
    const DeepCollectionEquality().hash(_taggroups),
  );

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      __$$ProfileModelImplCopyWithImpl<_$ProfileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileModelImplToJson(this);
  }
}

abstract class _ProfileModel implements ProfileModel {
  const factory _ProfileModel({
    required final String id,
    @JsonKey(name: 'first_name') required final String firstName,
    @JsonKey(name: 'last_name') final String? lastName,
    @JsonKey(name: 'company_name') final String? companyName,
    final String? bio,
    @JsonKey(name: 'linkedin_url') final String? linkedInURL,
    @JsonKey(name: 'website_url') final String? websiteURL,
    @JsonKey(name: 'contact_email') final String? contactEmail,
    @JsonKey(name: 'show_email') final bool? showEmail,
    @JsonKey(name: 'avatar_id') final String? avatarID,
    final DateTime? timestamp,
    @JsonKey(name: 'registered_at') final DateTime? registeredAt,
    final double? distance,
    @JsonKey(name: 'is_super_admin') final bool isSuperAdmin,
    @JsonKey(name: 'newsletter_subscribed') final bool? newsletterSubscribed,
    @JsonKey(name: 'public_key') final String? publicKey,
    final List<TagGroupModel>? taggroups,
  }) = _$ProfileModelImpl;

  factory _ProfileModel.fromJson(Map<String, dynamic> json) =
      _$ProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'linkedin_url')
  String? get linkedInURL;
  @override
  @JsonKey(name: 'website_url')
  String? get websiteURL;
  @override
  @JsonKey(name: 'contact_email')
  String? get contactEmail;
  @override
  @JsonKey(name: 'show_email')
  bool? get showEmail;
  @override
  @JsonKey(name: 'avatar_id')
  String? get avatarID;
  @override
  DateTime? get timestamp;
  @override
  @JsonKey(name: 'registered_at')
  DateTime? get registeredAt;
  @override
  double? get distance;
  @override
  @JsonKey(name: 'is_super_admin')
  bool get isSuperAdmin;
  @override
  @JsonKey(name: 'newsletter_subscribed')
  bool? get newsletterSubscribed;
  @override
  @JsonKey(name: 'public_key')
  String? get publicKey;
  @override
  List<TagGroupModel>? get taggroups;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
