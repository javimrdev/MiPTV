// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stream_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StreamEntity {

 int get id; String get name; String get logo; String get categoryId; String get extension;
/// Create a copy of StreamEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreamEntityCopyWith<StreamEntity> get copyWith => _$StreamEntityCopyWithImpl<StreamEntity>(this as StreamEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreamEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.extension, extension) || other.extension == extension));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,logo,categoryId,extension);

@override
String toString() {
  return 'StreamEntity(id: $id, name: $name, logo: $logo, categoryId: $categoryId, extension: $extension)';
}


}

/// @nodoc
abstract mixin class $StreamEntityCopyWith<$Res>  {
  factory $StreamEntityCopyWith(StreamEntity value, $Res Function(StreamEntity) _then) = _$StreamEntityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String logo, String categoryId, String extension
});




}
/// @nodoc
class _$StreamEntityCopyWithImpl<$Res>
    implements $StreamEntityCopyWith<$Res> {
  _$StreamEntityCopyWithImpl(this._self, this._then);

  final StreamEntity _self;
  final $Res Function(StreamEntity) _then;

/// Create a copy of StreamEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? logo = null,Object? categoryId = null,Object? extension = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logo: null == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StreamEntity].
extension StreamEntityPatterns on StreamEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreamEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreamEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreamEntity value)  $default,){
final _that = this;
switch (_that) {
case _StreamEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreamEntity value)?  $default,){
final _that = this;
switch (_that) {
case _StreamEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String logo,  String categoryId,  String extension)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreamEntity() when $default != null:
return $default(_that.id,_that.name,_that.logo,_that.categoryId,_that.extension);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String logo,  String categoryId,  String extension)  $default,) {final _that = this;
switch (_that) {
case _StreamEntity():
return $default(_that.id,_that.name,_that.logo,_that.categoryId,_that.extension);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String logo,  String categoryId,  String extension)?  $default,) {final _that = this;
switch (_that) {
case _StreamEntity() when $default != null:
return $default(_that.id,_that.name,_that.logo,_that.categoryId,_that.extension);case _:
  return null;

}
}

}

/// @nodoc


class _StreamEntity implements StreamEntity {
  const _StreamEntity({required this.id, required this.name, required this.logo, required this.categoryId, required this.extension});
  

@override final  int id;
@override final  String name;
@override final  String logo;
@override final  String categoryId;
@override final  String extension;

/// Create a copy of StreamEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreamEntityCopyWith<_StreamEntity> get copyWith => __$StreamEntityCopyWithImpl<_StreamEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreamEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.extension, extension) || other.extension == extension));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,logo,categoryId,extension);

@override
String toString() {
  return 'StreamEntity(id: $id, name: $name, logo: $logo, categoryId: $categoryId, extension: $extension)';
}


}

/// @nodoc
abstract mixin class _$StreamEntityCopyWith<$Res> implements $StreamEntityCopyWith<$Res> {
  factory _$StreamEntityCopyWith(_StreamEntity value, $Res Function(_StreamEntity) _then) = __$StreamEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String logo, String categoryId, String extension
});




}
/// @nodoc
class __$StreamEntityCopyWithImpl<$Res>
    implements _$StreamEntityCopyWith<$Res> {
  __$StreamEntityCopyWithImpl(this._self, this._then);

  final _StreamEntity _self;
  final $Res Function(_StreamEntity) _then;

/// Create a copy of StreamEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? logo = null,Object? categoryId = null,Object? extension = null,}) {
  return _then(_StreamEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logo: null == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
