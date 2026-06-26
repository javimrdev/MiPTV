// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoriteEntity {

 int get streamId; DateTime get createdAt;
/// Create a copy of FavoriteEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteEntityCopyWith<FavoriteEntity> get copyWith => _$FavoriteEntityCopyWithImpl<FavoriteEntity>(this as FavoriteEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteEntity&&(identical(other.streamId, streamId) || other.streamId == streamId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,streamId,createdAt);

@override
String toString() {
  return 'FavoriteEntity(streamId: $streamId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FavoriteEntityCopyWith<$Res>  {
  factory $FavoriteEntityCopyWith(FavoriteEntity value, $Res Function(FavoriteEntity) _then) = _$FavoriteEntityCopyWithImpl;
@useResult
$Res call({
 int streamId, DateTime createdAt
});




}
/// @nodoc
class _$FavoriteEntityCopyWithImpl<$Res>
    implements $FavoriteEntityCopyWith<$Res> {
  _$FavoriteEntityCopyWithImpl(this._self, this._then);

  final FavoriteEntity _self;
  final $Res Function(FavoriteEntity) _then;

/// Create a copy of FavoriteEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? streamId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
streamId: null == streamId ? _self.streamId : streamId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteEntity].
extension FavoriteEntityPatterns on FavoriteEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteEntity value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int streamId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteEntity() when $default != null:
return $default(_that.streamId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int streamId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FavoriteEntity():
return $default(_that.streamId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int streamId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteEntity() when $default != null:
return $default(_that.streamId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _FavoriteEntity implements FavoriteEntity {
  const _FavoriteEntity({required this.streamId, required this.createdAt});
  

@override final  int streamId;
@override final  DateTime createdAt;

/// Create a copy of FavoriteEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteEntityCopyWith<_FavoriteEntity> get copyWith => __$FavoriteEntityCopyWithImpl<_FavoriteEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteEntity&&(identical(other.streamId, streamId) || other.streamId == streamId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,streamId,createdAt);

@override
String toString() {
  return 'FavoriteEntity(streamId: $streamId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FavoriteEntityCopyWith<$Res> implements $FavoriteEntityCopyWith<$Res> {
  factory _$FavoriteEntityCopyWith(_FavoriteEntity value, $Res Function(_FavoriteEntity) _then) = __$FavoriteEntityCopyWithImpl;
@override @useResult
$Res call({
 int streamId, DateTime createdAt
});




}
/// @nodoc
class __$FavoriteEntityCopyWithImpl<$Res>
    implements _$FavoriteEntityCopyWith<$Res> {
  __$FavoriteEntityCopyWithImpl(this._self, this._then);

  final _FavoriteEntity _self;
  final $Res Function(_FavoriteEntity) _then;

/// Create a copy of FavoriteEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streamId = null,Object? createdAt = null,}) {
  return _then(_FavoriteEntity(
streamId: null == streamId ? _self.streamId : streamId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
