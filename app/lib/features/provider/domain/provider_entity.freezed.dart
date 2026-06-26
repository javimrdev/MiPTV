// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProviderEntity {

 int get id; String get server; String get username;
/// Create a copy of ProviderEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderEntityCopyWith<ProviderEntity> get copyWith => _$ProviderEntityCopyWithImpl<ProviderEntity>(this as ProviderEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.server, server) || other.server == server)&&(identical(other.username, username) || other.username == username));
}


@override
int get hashCode => Object.hash(runtimeType,id,server,username);

@override
String toString() {
  return 'ProviderEntity(id: $id, server: $server, username: $username)';
}


}

/// @nodoc
abstract mixin class $ProviderEntityCopyWith<$Res>  {
  factory $ProviderEntityCopyWith(ProviderEntity value, $Res Function(ProviderEntity) _then) = _$ProviderEntityCopyWithImpl;
@useResult
$Res call({
 int id, String server, String username
});




}
/// @nodoc
class _$ProviderEntityCopyWithImpl<$Res>
    implements $ProviderEntityCopyWith<$Res> {
  _$ProviderEntityCopyWithImpl(this._self, this._then);

  final ProviderEntity _self;
  final $Res Function(ProviderEntity) _then;

/// Create a copy of ProviderEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? server = null,Object? username = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderEntity].
extension ProviderEntityPatterns on ProviderEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProviderEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String server,  String username)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderEntity() when $default != null:
return $default(_that.id,_that.server,_that.username);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String server,  String username)  $default,) {final _that = this;
switch (_that) {
case _ProviderEntity():
return $default(_that.id,_that.server,_that.username);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String server,  String username)?  $default,) {final _that = this;
switch (_that) {
case _ProviderEntity() when $default != null:
return $default(_that.id,_that.server,_that.username);case _:
  return null;

}
}

}

/// @nodoc


class _ProviderEntity implements ProviderEntity {
  const _ProviderEntity({required this.id, required this.server, required this.username});
  

@override final  int id;
@override final  String server;
@override final  String username;

/// Create a copy of ProviderEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderEntityCopyWith<_ProviderEntity> get copyWith => __$ProviderEntityCopyWithImpl<_ProviderEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.server, server) || other.server == server)&&(identical(other.username, username) || other.username == username));
}


@override
int get hashCode => Object.hash(runtimeType,id,server,username);

@override
String toString() {
  return 'ProviderEntity(id: $id, server: $server, username: $username)';
}


}

/// @nodoc
abstract mixin class _$ProviderEntityCopyWith<$Res> implements $ProviderEntityCopyWith<$Res> {
  factory _$ProviderEntityCopyWith(_ProviderEntity value, $Res Function(_ProviderEntity) _then) = __$ProviderEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String server, String username
});




}
/// @nodoc
class __$ProviderEntityCopyWithImpl<$Res>
    implements _$ProviderEntityCopyWith<$Res> {
  __$ProviderEntityCopyWithImpl(this._self, this._then);

  final _ProviderEntity _self;
  final $Res Function(_ProviderEntity) _then;

/// Create a copy of ProviderEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? server = null,Object? username = null,}) {
  return _then(_ProviderEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
