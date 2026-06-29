// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_category_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoriteCategoryEntity {

 String get categoryId; String get name; DateTime get createdAt;
/// Create a copy of FavoriteCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteCategoryEntityCopyWith<FavoriteCategoryEntity> get copyWith => _$FavoriteCategoryEntityCopyWithImpl<FavoriteCategoryEntity>(this as FavoriteCategoryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteCategoryEntity&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,name,createdAt);

@override
String toString() {
  return 'FavoriteCategoryEntity(categoryId: $categoryId, name: $name, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FavoriteCategoryEntityCopyWith<$Res>  {
  factory $FavoriteCategoryEntityCopyWith(FavoriteCategoryEntity value, $Res Function(FavoriteCategoryEntity) _then) = _$FavoriteCategoryEntityCopyWithImpl;
@useResult
$Res call({
 String categoryId, String name, DateTime createdAt
});




}
/// @nodoc
class _$FavoriteCategoryEntityCopyWithImpl<$Res>
    implements $FavoriteCategoryEntityCopyWith<$Res> {
  _$FavoriteCategoryEntityCopyWithImpl(this._self, this._then);

  final FavoriteCategoryEntity _self;
  final $Res Function(FavoriteCategoryEntity) _then;

/// Create a copy of FavoriteCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? name = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteCategoryEntity].
extension FavoriteCategoryEntityPatterns on FavoriteCategoryEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteCategoryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteCategoryEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteCategoryEntity value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteCategoryEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteCategoryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteCategoryEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId,  String name,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteCategoryEntity() when $default != null:
return $default(_that.categoryId,_that.name,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId,  String name,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FavoriteCategoryEntity():
return $default(_that.categoryId,_that.name,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId,  String name,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteCategoryEntity() when $default != null:
return $default(_that.categoryId,_that.name,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _FavoriteCategoryEntity implements FavoriteCategoryEntity {
  const _FavoriteCategoryEntity({required this.categoryId, required this.name, required this.createdAt});
  

@override final  String categoryId;
@override final  String name;
@override final  DateTime createdAt;

/// Create a copy of FavoriteCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteCategoryEntityCopyWith<_FavoriteCategoryEntity> get copyWith => __$FavoriteCategoryEntityCopyWithImpl<_FavoriteCategoryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteCategoryEntity&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,name,createdAt);

@override
String toString() {
  return 'FavoriteCategoryEntity(categoryId: $categoryId, name: $name, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FavoriteCategoryEntityCopyWith<$Res> implements $FavoriteCategoryEntityCopyWith<$Res> {
  factory _$FavoriteCategoryEntityCopyWith(_FavoriteCategoryEntity value, $Res Function(_FavoriteCategoryEntity) _then) = __$FavoriteCategoryEntityCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String name, DateTime createdAt
});




}
/// @nodoc
class __$FavoriteCategoryEntityCopyWithImpl<$Res>
    implements _$FavoriteCategoryEntityCopyWith<$Res> {
  __$FavoriteCategoryEntityCopyWithImpl(this._self, this._then);

  final _FavoriteCategoryEntity _self;
  final $Res Function(_FavoriteCategoryEntity) _then;

/// Create a copy of FavoriteCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? name = null,Object? createdAt = null,}) {
  return _then(_FavoriteCategoryEntity(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
