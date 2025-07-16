// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TagGroupModel _$TagGroupModelFromJson(Map<String, dynamic> json) {
  return _TagGroupModel.fromJson(json);
}

/// @nodoc
mixin _$TagGroupModel {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  CategoryType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_order')
  int get displayOrder => throw _privateConstructorUsedError;
  List<TagModel>? get tags => throw _privateConstructorUsedError;

  /// Serializes this TagGroupModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TagGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TagGroupModelCopyWith<TagGroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagGroupModelCopyWith<$Res> {
  factory $TagGroupModelCopyWith(
    TagGroupModel value,
    $Res Function(TagGroupModel) then,
  ) = _$TagGroupModelCopyWithImpl<$Res, TagGroupModel>;
  @useResult
  $Res call({
    String id,
    String code,
    String title,
    String? description,
    CategoryType type,
    @JsonKey(name: 'display_order') int displayOrder,
    List<TagModel>? tags,
  });
}

/// @nodoc
class _$TagGroupModelCopyWithImpl<$Res, $Val extends TagGroupModel>
    implements $TagGroupModelCopyWith<$Res> {
  _$TagGroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TagGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? displayOrder = null,
    Object? tags = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as CategoryType,
            displayOrder: null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            tags: freezed == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<TagModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TagGroupModelImplCopyWith<$Res>
    implements $TagGroupModelCopyWith<$Res> {
  factory _$$TagGroupModelImplCopyWith(
    _$TagGroupModelImpl value,
    $Res Function(_$TagGroupModelImpl) then,
  ) = __$$TagGroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    String title,
    String? description,
    CategoryType type,
    @JsonKey(name: 'display_order') int displayOrder,
    List<TagModel>? tags,
  });
}

/// @nodoc
class __$$TagGroupModelImplCopyWithImpl<$Res>
    extends _$TagGroupModelCopyWithImpl<$Res, _$TagGroupModelImpl>
    implements _$$TagGroupModelImplCopyWith<$Res> {
  __$$TagGroupModelImplCopyWithImpl(
    _$TagGroupModelImpl _value,
    $Res Function(_$TagGroupModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TagGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? displayOrder = null,
    Object? tags = freezed,
  }) {
    return _then(
      _$TagGroupModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as CategoryType,
        displayOrder: null == displayOrder
            ? _value.displayOrder
            : displayOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        tags: freezed == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<TagModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TagGroupModelImpl implements _TagGroupModel {
  const _$TagGroupModelImpl({
    required this.id,
    required this.code,
    required this.title,
    this.description,
    required this.type,
    @JsonKey(name: 'display_order') required this.displayOrder,
    final List<TagModel>? tags,
  }) : _tags = tags;

  factory _$TagGroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagGroupModelImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String title;
  @override
  final String? description;
  @override
  final CategoryType type;
  @override
  @JsonKey(name: 'display_order')
  final int displayOrder;
  final List<TagModel>? _tags;
  @override
  List<TagModel>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TagGroupModel(id: $id, code: $code, title: $title, description: $description, type: $type, displayOrder: $displayOrder, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagGroupModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    title,
    description,
    type,
    displayOrder,
    const DeepCollectionEquality().hash(_tags),
  );

  /// Create a copy of TagGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TagGroupModelImplCopyWith<_$TagGroupModelImpl> get copyWith =>
      __$$TagGroupModelImplCopyWithImpl<_$TagGroupModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagGroupModelImplToJson(this);
  }
}

abstract class _TagGroupModel implements TagGroupModel {
  const factory _TagGroupModel({
    required final String id,
    required final String code,
    required final String title,
    final String? description,
    required final CategoryType type,
    @JsonKey(name: 'display_order') required final int displayOrder,
    final List<TagModel>? tags,
  }) = _$TagGroupModelImpl;

  factory _TagGroupModel.fromJson(Map<String, dynamic> json) =
      _$TagGroupModelImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get title;
  @override
  String? get description;
  @override
  CategoryType get type;
  @override
  @JsonKey(name: 'display_order')
  int get displayOrder;
  @override
  List<TagModel>? get tags;

  /// Create a copy of TagGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TagGroupModelImplCopyWith<_$TagGroupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
