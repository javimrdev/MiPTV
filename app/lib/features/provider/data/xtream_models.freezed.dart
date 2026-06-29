// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'xtream_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$XtreamAuthResponse {

@JsonKey(name: 'user_info') XtreamUserInfo get userInfo;@JsonKey(name: 'server_info') XtreamServerInfo get serverInfo;
/// Create a copy of XtreamAuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XtreamAuthResponseCopyWith<XtreamAuthResponse> get copyWith => _$XtreamAuthResponseCopyWithImpl<XtreamAuthResponse>(this as XtreamAuthResponse, _$identity);

  /// Serializes this XtreamAuthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XtreamAuthResponse&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.serverInfo, serverInfo) || other.serverInfo == serverInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userInfo,serverInfo);

@override
String toString() {
  return 'XtreamAuthResponse(userInfo: $userInfo, serverInfo: $serverInfo)';
}


}

/// @nodoc
abstract mixin class $XtreamAuthResponseCopyWith<$Res>  {
  factory $XtreamAuthResponseCopyWith(XtreamAuthResponse value, $Res Function(XtreamAuthResponse) _then) = _$XtreamAuthResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_info') XtreamUserInfo userInfo,@JsonKey(name: 'server_info') XtreamServerInfo serverInfo
});


$XtreamUserInfoCopyWith<$Res> get userInfo;$XtreamServerInfoCopyWith<$Res> get serverInfo;

}
/// @nodoc
class _$XtreamAuthResponseCopyWithImpl<$Res>
    implements $XtreamAuthResponseCopyWith<$Res> {
  _$XtreamAuthResponseCopyWithImpl(this._self, this._then);

  final XtreamAuthResponse _self;
  final $Res Function(XtreamAuthResponse) _then;

/// Create a copy of XtreamAuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userInfo = null,Object? serverInfo = null,}) {
  return _then(_self.copyWith(
userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as XtreamUserInfo,serverInfo: null == serverInfo ? _self.serverInfo : serverInfo // ignore: cast_nullable_to_non_nullable
as XtreamServerInfo,
  ));
}
/// Create a copy of XtreamAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$XtreamUserInfoCopyWith<$Res> get userInfo {
  
  return $XtreamUserInfoCopyWith<$Res>(_self.userInfo, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}/// Create a copy of XtreamAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$XtreamServerInfoCopyWith<$Res> get serverInfo {
  
  return $XtreamServerInfoCopyWith<$Res>(_self.serverInfo, (value) {
    return _then(_self.copyWith(serverInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [XtreamAuthResponse].
extension XtreamAuthResponsePatterns on XtreamAuthResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XtreamAuthResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XtreamAuthResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XtreamAuthResponse value)  $default,){
final _that = this;
switch (_that) {
case _XtreamAuthResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XtreamAuthResponse value)?  $default,){
final _that = this;
switch (_that) {
case _XtreamAuthResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_info')  XtreamUserInfo userInfo, @JsonKey(name: 'server_info')  XtreamServerInfo serverInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XtreamAuthResponse() when $default != null:
return $default(_that.userInfo,_that.serverInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_info')  XtreamUserInfo userInfo, @JsonKey(name: 'server_info')  XtreamServerInfo serverInfo)  $default,) {final _that = this;
switch (_that) {
case _XtreamAuthResponse():
return $default(_that.userInfo,_that.serverInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_info')  XtreamUserInfo userInfo, @JsonKey(name: 'server_info')  XtreamServerInfo serverInfo)?  $default,) {final _that = this;
switch (_that) {
case _XtreamAuthResponse() when $default != null:
return $default(_that.userInfo,_that.serverInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XtreamAuthResponse implements XtreamAuthResponse {
  const _XtreamAuthResponse({@JsonKey(name: 'user_info') required this.userInfo, @JsonKey(name: 'server_info') required this.serverInfo});
  factory _XtreamAuthResponse.fromJson(Map<String, dynamic> json) => _$XtreamAuthResponseFromJson(json);

@override@JsonKey(name: 'user_info') final  XtreamUserInfo userInfo;
@override@JsonKey(name: 'server_info') final  XtreamServerInfo serverInfo;

/// Create a copy of XtreamAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XtreamAuthResponseCopyWith<_XtreamAuthResponse> get copyWith => __$XtreamAuthResponseCopyWithImpl<_XtreamAuthResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XtreamAuthResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XtreamAuthResponse&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.serverInfo, serverInfo) || other.serverInfo == serverInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userInfo,serverInfo);

@override
String toString() {
  return 'XtreamAuthResponse(userInfo: $userInfo, serverInfo: $serverInfo)';
}


}

/// @nodoc
abstract mixin class _$XtreamAuthResponseCopyWith<$Res> implements $XtreamAuthResponseCopyWith<$Res> {
  factory _$XtreamAuthResponseCopyWith(_XtreamAuthResponse value, $Res Function(_XtreamAuthResponse) _then) = __$XtreamAuthResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_info') XtreamUserInfo userInfo,@JsonKey(name: 'server_info') XtreamServerInfo serverInfo
});


@override $XtreamUserInfoCopyWith<$Res> get userInfo;@override $XtreamServerInfoCopyWith<$Res> get serverInfo;

}
/// @nodoc
class __$XtreamAuthResponseCopyWithImpl<$Res>
    implements _$XtreamAuthResponseCopyWith<$Res> {
  __$XtreamAuthResponseCopyWithImpl(this._self, this._then);

  final _XtreamAuthResponse _self;
  final $Res Function(_XtreamAuthResponse) _then;

/// Create a copy of XtreamAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userInfo = null,Object? serverInfo = null,}) {
  return _then(_XtreamAuthResponse(
userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as XtreamUserInfo,serverInfo: null == serverInfo ? _self.serverInfo : serverInfo // ignore: cast_nullable_to_non_nullable
as XtreamServerInfo,
  ));
}

/// Create a copy of XtreamAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$XtreamUserInfoCopyWith<$Res> get userInfo {
  
  return $XtreamUserInfoCopyWith<$Res>(_self.userInfo, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}/// Create a copy of XtreamAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$XtreamServerInfoCopyWith<$Res> get serverInfo {
  
  return $XtreamServerInfoCopyWith<$Res>(_self.serverInfo, (value) {
    return _then(_self.copyWith(serverInfo: value));
  });
}
}


/// @nodoc
mixin _$XtreamUserInfo {

 String get username; String get password; String get status;
/// Create a copy of XtreamUserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XtreamUserInfoCopyWith<XtreamUserInfo> get copyWith => _$XtreamUserInfoCopyWithImpl<XtreamUserInfo>(this as XtreamUserInfo, _$identity);

  /// Serializes this XtreamUserInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XtreamUserInfo&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password,status);

@override
String toString() {
  return 'XtreamUserInfo(username: $username, password: $password, status: $status)';
}


}

/// @nodoc
abstract mixin class $XtreamUserInfoCopyWith<$Res>  {
  factory $XtreamUserInfoCopyWith(XtreamUserInfo value, $Res Function(XtreamUserInfo) _then) = _$XtreamUserInfoCopyWithImpl;
@useResult
$Res call({
 String username, String password, String status
});




}
/// @nodoc
class _$XtreamUserInfoCopyWithImpl<$Res>
    implements $XtreamUserInfoCopyWith<$Res> {
  _$XtreamUserInfoCopyWithImpl(this._self, this._then);

  final XtreamUserInfo _self;
  final $Res Function(XtreamUserInfo) _then;

/// Create a copy of XtreamUserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? password = null,Object? status = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [XtreamUserInfo].
extension XtreamUserInfoPatterns on XtreamUserInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XtreamUserInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XtreamUserInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XtreamUserInfo value)  $default,){
final _that = this;
switch (_that) {
case _XtreamUserInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XtreamUserInfo value)?  $default,){
final _that = this;
switch (_that) {
case _XtreamUserInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String password,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XtreamUserInfo() when $default != null:
return $default(_that.username,_that.password,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String password,  String status)  $default,) {final _that = this;
switch (_that) {
case _XtreamUserInfo():
return $default(_that.username,_that.password,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String password,  String status)?  $default,) {final _that = this;
switch (_that) {
case _XtreamUserInfo() when $default != null:
return $default(_that.username,_that.password,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XtreamUserInfo implements XtreamUserInfo {
  const _XtreamUserInfo({required this.username, required this.password, required this.status});
  factory _XtreamUserInfo.fromJson(Map<String, dynamic> json) => _$XtreamUserInfoFromJson(json);

@override final  String username;
@override final  String password;
@override final  String status;

/// Create a copy of XtreamUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XtreamUserInfoCopyWith<_XtreamUserInfo> get copyWith => __$XtreamUserInfoCopyWithImpl<_XtreamUserInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XtreamUserInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XtreamUserInfo&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password,status);

@override
String toString() {
  return 'XtreamUserInfo(username: $username, password: $password, status: $status)';
}


}

/// @nodoc
abstract mixin class _$XtreamUserInfoCopyWith<$Res> implements $XtreamUserInfoCopyWith<$Res> {
  factory _$XtreamUserInfoCopyWith(_XtreamUserInfo value, $Res Function(_XtreamUserInfo) _then) = __$XtreamUserInfoCopyWithImpl;
@override @useResult
$Res call({
 String username, String password, String status
});




}
/// @nodoc
class __$XtreamUserInfoCopyWithImpl<$Res>
    implements _$XtreamUserInfoCopyWith<$Res> {
  __$XtreamUserInfoCopyWithImpl(this._self, this._then);

  final _XtreamUserInfo _self;
  final $Res Function(_XtreamUserInfo) _then;

/// Create a copy of XtreamUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,Object? status = null,}) {
  return _then(_XtreamUserInfo(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$XtreamServerInfo {

@JsonKey(name: 'url')@XtreamString() String get url;@JsonKey(name: 'port')@XtreamString() String get port;
/// Create a copy of XtreamServerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XtreamServerInfoCopyWith<XtreamServerInfo> get copyWith => _$XtreamServerInfoCopyWithImpl<XtreamServerInfo>(this as XtreamServerInfo, _$identity);

  /// Serializes this XtreamServerInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XtreamServerInfo&&(identical(other.url, url) || other.url == url)&&(identical(other.port, port) || other.port == port));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,port);

@override
String toString() {
  return 'XtreamServerInfo(url: $url, port: $port)';
}


}

/// @nodoc
abstract mixin class $XtreamServerInfoCopyWith<$Res>  {
  factory $XtreamServerInfoCopyWith(XtreamServerInfo value, $Res Function(XtreamServerInfo) _then) = _$XtreamServerInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'url')@XtreamString() String url,@JsonKey(name: 'port')@XtreamString() String port
});




}
/// @nodoc
class _$XtreamServerInfoCopyWithImpl<$Res>
    implements $XtreamServerInfoCopyWith<$Res> {
  _$XtreamServerInfoCopyWithImpl(this._self, this._then);

  final XtreamServerInfo _self;
  final $Res Function(XtreamServerInfo) _then;

/// Create a copy of XtreamServerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? port = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [XtreamServerInfo].
extension XtreamServerInfoPatterns on XtreamServerInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XtreamServerInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XtreamServerInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XtreamServerInfo value)  $default,){
final _that = this;
switch (_that) {
case _XtreamServerInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XtreamServerInfo value)?  $default,){
final _that = this;
switch (_that) {
case _XtreamServerInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')@XtreamString()  String url, @JsonKey(name: 'port')@XtreamString()  String port)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XtreamServerInfo() when $default != null:
return $default(_that.url,_that.port);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')@XtreamString()  String url, @JsonKey(name: 'port')@XtreamString()  String port)  $default,) {final _that = this;
switch (_that) {
case _XtreamServerInfo():
return $default(_that.url,_that.port);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'url')@XtreamString()  String url, @JsonKey(name: 'port')@XtreamString()  String port)?  $default,) {final _that = this;
switch (_that) {
case _XtreamServerInfo() when $default != null:
return $default(_that.url,_that.port);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XtreamServerInfo implements XtreamServerInfo {
  const _XtreamServerInfo({@JsonKey(name: 'url')@XtreamString() required this.url, @JsonKey(name: 'port')@XtreamString() required this.port});
  factory _XtreamServerInfo.fromJson(Map<String, dynamic> json) => _$XtreamServerInfoFromJson(json);

@override@JsonKey(name: 'url')@XtreamString() final  String url;
@override@JsonKey(name: 'port')@XtreamString() final  String port;

/// Create a copy of XtreamServerInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XtreamServerInfoCopyWith<_XtreamServerInfo> get copyWith => __$XtreamServerInfoCopyWithImpl<_XtreamServerInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XtreamServerInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XtreamServerInfo&&(identical(other.url, url) || other.url == url)&&(identical(other.port, port) || other.port == port));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,port);

@override
String toString() {
  return 'XtreamServerInfo(url: $url, port: $port)';
}


}

/// @nodoc
abstract mixin class _$XtreamServerInfoCopyWith<$Res> implements $XtreamServerInfoCopyWith<$Res> {
  factory _$XtreamServerInfoCopyWith(_XtreamServerInfo value, $Res Function(_XtreamServerInfo) _then) = __$XtreamServerInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'url')@XtreamString() String url,@JsonKey(name: 'port')@XtreamString() String port
});




}
/// @nodoc
class __$XtreamServerInfoCopyWithImpl<$Res>
    implements _$XtreamServerInfoCopyWith<$Res> {
  __$XtreamServerInfoCopyWithImpl(this._self, this._then);

  final _XtreamServerInfo _self;
  final $Res Function(_XtreamServerInfo) _then;

/// Create a copy of XtreamServerInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? port = null,}) {
  return _then(_XtreamServerInfo(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$XtreamCategory {

@JsonKey(name: 'category_id')@XtreamString() String get categoryId;@JsonKey(name: 'category_name')@XtreamString() String get categoryName;
/// Create a copy of XtreamCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XtreamCategoryCopyWith<XtreamCategory> get copyWith => _$XtreamCategoryCopyWithImpl<XtreamCategory>(this as XtreamCategory, _$identity);

  /// Serializes this XtreamCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XtreamCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName);

@override
String toString() {
  return 'XtreamCategory(categoryId: $categoryId, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class $XtreamCategoryCopyWith<$Res>  {
  factory $XtreamCategoryCopyWith(XtreamCategory value, $Res Function(XtreamCategory) _then) = _$XtreamCategoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'category_id')@XtreamString() String categoryId,@JsonKey(name: 'category_name')@XtreamString() String categoryName
});




}
/// @nodoc
class _$XtreamCategoryCopyWithImpl<$Res>
    implements $XtreamCategoryCopyWith<$Res> {
  _$XtreamCategoryCopyWithImpl(this._self, this._then);

  final XtreamCategory _self;
  final $Res Function(XtreamCategory) _then;

/// Create a copy of XtreamCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryName = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [XtreamCategory].
extension XtreamCategoryPatterns on XtreamCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XtreamCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XtreamCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XtreamCategory value)  $default,){
final _that = this;
switch (_that) {
case _XtreamCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XtreamCategory value)?  $default,){
final _that = this;
switch (_that) {
case _XtreamCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')@XtreamString()  String categoryId, @JsonKey(name: 'category_name')@XtreamString()  String categoryName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XtreamCategory() when $default != null:
return $default(_that.categoryId,_that.categoryName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'category_id')@XtreamString()  String categoryId, @JsonKey(name: 'category_name')@XtreamString()  String categoryName)  $default,) {final _that = this;
switch (_that) {
case _XtreamCategory():
return $default(_that.categoryId,_that.categoryName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'category_id')@XtreamString()  String categoryId, @JsonKey(name: 'category_name')@XtreamString()  String categoryName)?  $default,) {final _that = this;
switch (_that) {
case _XtreamCategory() when $default != null:
return $default(_that.categoryId,_that.categoryName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XtreamCategory implements XtreamCategory {
  const _XtreamCategory({@JsonKey(name: 'category_id')@XtreamString() required this.categoryId, @JsonKey(name: 'category_name')@XtreamString() required this.categoryName});
  factory _XtreamCategory.fromJson(Map<String, dynamic> json) => _$XtreamCategoryFromJson(json);

@override@JsonKey(name: 'category_id')@XtreamString() final  String categoryId;
@override@JsonKey(name: 'category_name')@XtreamString() final  String categoryName;

/// Create a copy of XtreamCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XtreamCategoryCopyWith<_XtreamCategory> get copyWith => __$XtreamCategoryCopyWithImpl<_XtreamCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XtreamCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XtreamCategory&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName);

@override
String toString() {
  return 'XtreamCategory(categoryId: $categoryId, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class _$XtreamCategoryCopyWith<$Res> implements $XtreamCategoryCopyWith<$Res> {
  factory _$XtreamCategoryCopyWith(_XtreamCategory value, $Res Function(_XtreamCategory) _then) = __$XtreamCategoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'category_id')@XtreamString() String categoryId,@JsonKey(name: 'category_name')@XtreamString() String categoryName
});




}
/// @nodoc
class __$XtreamCategoryCopyWithImpl<$Res>
    implements _$XtreamCategoryCopyWith<$Res> {
  __$XtreamCategoryCopyWithImpl(this._self, this._then);

  final _XtreamCategory _self;
  final $Res Function(_XtreamCategory) _then;

/// Create a copy of XtreamCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryName = null,}) {
  return _then(_XtreamCategory(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$XtreamStream {

@JsonKey(name: 'stream_id') int get streamId;@JsonKey(name: 'name') String get name;@JsonKey(name: 'stream_icon') String get logo;@JsonKey(name: 'category_id')@XtreamString() String get categoryId;@JsonKey(name: 'container_extension') String get extension;
/// Create a copy of XtreamStream
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XtreamStreamCopyWith<XtreamStream> get copyWith => _$XtreamStreamCopyWithImpl<XtreamStream>(this as XtreamStream, _$identity);

  /// Serializes this XtreamStream to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XtreamStream&&(identical(other.streamId, streamId) || other.streamId == streamId)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.extension, extension) || other.extension == extension));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streamId,name,logo,categoryId,extension);

@override
String toString() {
  return 'XtreamStream(streamId: $streamId, name: $name, logo: $logo, categoryId: $categoryId, extension: $extension)';
}


}

/// @nodoc
abstract mixin class $XtreamStreamCopyWith<$Res>  {
  factory $XtreamStreamCopyWith(XtreamStream value, $Res Function(XtreamStream) _then) = _$XtreamStreamCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'stream_id') int streamId,@JsonKey(name: 'name') String name,@JsonKey(name: 'stream_icon') String logo,@JsonKey(name: 'category_id')@XtreamString() String categoryId,@JsonKey(name: 'container_extension') String extension
});




}
/// @nodoc
class _$XtreamStreamCopyWithImpl<$Res>
    implements $XtreamStreamCopyWith<$Res> {
  _$XtreamStreamCopyWithImpl(this._self, this._then);

  final XtreamStream _self;
  final $Res Function(XtreamStream) _then;

/// Create a copy of XtreamStream
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? streamId = null,Object? name = null,Object? logo = null,Object? categoryId = null,Object? extension = null,}) {
  return _then(_self.copyWith(
streamId: null == streamId ? _self.streamId : streamId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logo: null == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [XtreamStream].
extension XtreamStreamPatterns on XtreamStream {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XtreamStream value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XtreamStream() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XtreamStream value)  $default,){
final _that = this;
switch (_that) {
case _XtreamStream():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XtreamStream value)?  $default,){
final _that = this;
switch (_that) {
case _XtreamStream() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'stream_id')  int streamId, @JsonKey(name: 'name')  String name, @JsonKey(name: 'stream_icon')  String logo, @JsonKey(name: 'category_id')@XtreamString()  String categoryId, @JsonKey(name: 'container_extension')  String extension)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XtreamStream() when $default != null:
return $default(_that.streamId,_that.name,_that.logo,_that.categoryId,_that.extension);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'stream_id')  int streamId, @JsonKey(name: 'name')  String name, @JsonKey(name: 'stream_icon')  String logo, @JsonKey(name: 'category_id')@XtreamString()  String categoryId, @JsonKey(name: 'container_extension')  String extension)  $default,) {final _that = this;
switch (_that) {
case _XtreamStream():
return $default(_that.streamId,_that.name,_that.logo,_that.categoryId,_that.extension);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'stream_id')  int streamId, @JsonKey(name: 'name')  String name, @JsonKey(name: 'stream_icon')  String logo, @JsonKey(name: 'category_id')@XtreamString()  String categoryId, @JsonKey(name: 'container_extension')  String extension)?  $default,) {final _that = this;
switch (_that) {
case _XtreamStream() when $default != null:
return $default(_that.streamId,_that.name,_that.logo,_that.categoryId,_that.extension);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XtreamStream implements XtreamStream {
  const _XtreamStream({@JsonKey(name: 'stream_id') required this.streamId, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'stream_icon') this.logo = '', @JsonKey(name: 'category_id')@XtreamString() required this.categoryId, @JsonKey(name: 'container_extension') this.extension = 'ts'});
  factory _XtreamStream.fromJson(Map<String, dynamic> json) => _$XtreamStreamFromJson(json);

@override@JsonKey(name: 'stream_id') final  int streamId;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'stream_icon') final  String logo;
@override@JsonKey(name: 'category_id')@XtreamString() final  String categoryId;
@override@JsonKey(name: 'container_extension') final  String extension;

/// Create a copy of XtreamStream
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XtreamStreamCopyWith<_XtreamStream> get copyWith => __$XtreamStreamCopyWithImpl<_XtreamStream>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XtreamStreamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XtreamStream&&(identical(other.streamId, streamId) || other.streamId == streamId)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.extension, extension) || other.extension == extension));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streamId,name,logo,categoryId,extension);

@override
String toString() {
  return 'XtreamStream(streamId: $streamId, name: $name, logo: $logo, categoryId: $categoryId, extension: $extension)';
}


}

/// @nodoc
abstract mixin class _$XtreamStreamCopyWith<$Res> implements $XtreamStreamCopyWith<$Res> {
  factory _$XtreamStreamCopyWith(_XtreamStream value, $Res Function(_XtreamStream) _then) = __$XtreamStreamCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'stream_id') int streamId,@JsonKey(name: 'name') String name,@JsonKey(name: 'stream_icon') String logo,@JsonKey(name: 'category_id')@XtreamString() String categoryId,@JsonKey(name: 'container_extension') String extension
});




}
/// @nodoc
class __$XtreamStreamCopyWithImpl<$Res>
    implements _$XtreamStreamCopyWith<$Res> {
  __$XtreamStreamCopyWithImpl(this._self, this._then);

  final _XtreamStream _self;
  final $Res Function(_XtreamStream) _then;

/// Create a copy of XtreamStream
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streamId = null,Object? name = null,Object? logo = null,Object? categoryId = null,Object? extension = null,}) {
  return _then(_XtreamStream(
streamId: null == streamId ? _self.streamId : streamId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logo: null == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$XtreamEpgListing {

@JsonKey(name: 'title')@XtreamString() String get title;@JsonKey(name: 'start_timestamp')@XtreamInt() int get startTimestamp;@JsonKey(name: 'stop_timestamp')@XtreamInt() int get stopTimestamp;
/// Create a copy of XtreamEpgListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XtreamEpgListingCopyWith<XtreamEpgListing> get copyWith => _$XtreamEpgListingCopyWithImpl<XtreamEpgListing>(this as XtreamEpgListing, _$identity);

  /// Serializes this XtreamEpgListing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XtreamEpgListing&&(identical(other.title, title) || other.title == title)&&(identical(other.startTimestamp, startTimestamp) || other.startTimestamp == startTimestamp)&&(identical(other.stopTimestamp, stopTimestamp) || other.stopTimestamp == stopTimestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,startTimestamp,stopTimestamp);

@override
String toString() {
  return 'XtreamEpgListing(title: $title, startTimestamp: $startTimestamp, stopTimestamp: $stopTimestamp)';
}


}

/// @nodoc
abstract mixin class $XtreamEpgListingCopyWith<$Res>  {
  factory $XtreamEpgListingCopyWith(XtreamEpgListing value, $Res Function(XtreamEpgListing) _then) = _$XtreamEpgListingCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title')@XtreamString() String title,@JsonKey(name: 'start_timestamp')@XtreamInt() int startTimestamp,@JsonKey(name: 'stop_timestamp')@XtreamInt() int stopTimestamp
});




}
/// @nodoc
class _$XtreamEpgListingCopyWithImpl<$Res>
    implements $XtreamEpgListingCopyWith<$Res> {
  _$XtreamEpgListingCopyWithImpl(this._self, this._then);

  final XtreamEpgListing _self;
  final $Res Function(XtreamEpgListing) _then;

/// Create a copy of XtreamEpgListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? startTimestamp = null,Object? stopTimestamp = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startTimestamp: null == startTimestamp ? _self.startTimestamp : startTimestamp // ignore: cast_nullable_to_non_nullable
as int,stopTimestamp: null == stopTimestamp ? _self.stopTimestamp : stopTimestamp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [XtreamEpgListing].
extension XtreamEpgListingPatterns on XtreamEpgListing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _XtreamEpgListing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _XtreamEpgListing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _XtreamEpgListing value)  $default,){
final _that = this;
switch (_that) {
case _XtreamEpgListing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _XtreamEpgListing value)?  $default,){
final _that = this;
switch (_that) {
case _XtreamEpgListing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')@XtreamString()  String title, @JsonKey(name: 'start_timestamp')@XtreamInt()  int startTimestamp, @JsonKey(name: 'stop_timestamp')@XtreamInt()  int stopTimestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _XtreamEpgListing() when $default != null:
return $default(_that.title,_that.startTimestamp,_that.stopTimestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')@XtreamString()  String title, @JsonKey(name: 'start_timestamp')@XtreamInt()  int startTimestamp, @JsonKey(name: 'stop_timestamp')@XtreamInt()  int stopTimestamp)  $default,) {final _that = this;
switch (_that) {
case _XtreamEpgListing():
return $default(_that.title,_that.startTimestamp,_that.stopTimestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'title')@XtreamString()  String title, @JsonKey(name: 'start_timestamp')@XtreamInt()  int startTimestamp, @JsonKey(name: 'stop_timestamp')@XtreamInt()  int stopTimestamp)?  $default,) {final _that = this;
switch (_that) {
case _XtreamEpgListing() when $default != null:
return $default(_that.title,_that.startTimestamp,_that.stopTimestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _XtreamEpgListing implements XtreamEpgListing {
  const _XtreamEpgListing({@JsonKey(name: 'title')@XtreamString() required this.title, @JsonKey(name: 'start_timestamp')@XtreamInt() required this.startTimestamp, @JsonKey(name: 'stop_timestamp')@XtreamInt() required this.stopTimestamp});
  factory _XtreamEpgListing.fromJson(Map<String, dynamic> json) => _$XtreamEpgListingFromJson(json);

@override@JsonKey(name: 'title')@XtreamString() final  String title;
@override@JsonKey(name: 'start_timestamp')@XtreamInt() final  int startTimestamp;
@override@JsonKey(name: 'stop_timestamp')@XtreamInt() final  int stopTimestamp;

/// Create a copy of XtreamEpgListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$XtreamEpgListingCopyWith<_XtreamEpgListing> get copyWith => __$XtreamEpgListingCopyWithImpl<_XtreamEpgListing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$XtreamEpgListingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _XtreamEpgListing&&(identical(other.title, title) || other.title == title)&&(identical(other.startTimestamp, startTimestamp) || other.startTimestamp == startTimestamp)&&(identical(other.stopTimestamp, stopTimestamp) || other.stopTimestamp == stopTimestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,startTimestamp,stopTimestamp);

@override
String toString() {
  return 'XtreamEpgListing(title: $title, startTimestamp: $startTimestamp, stopTimestamp: $stopTimestamp)';
}


}

/// @nodoc
abstract mixin class _$XtreamEpgListingCopyWith<$Res> implements $XtreamEpgListingCopyWith<$Res> {
  factory _$XtreamEpgListingCopyWith(_XtreamEpgListing value, $Res Function(_XtreamEpgListing) _then) = __$XtreamEpgListingCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title')@XtreamString() String title,@JsonKey(name: 'start_timestamp')@XtreamInt() int startTimestamp,@JsonKey(name: 'stop_timestamp')@XtreamInt() int stopTimestamp
});




}
/// @nodoc
class __$XtreamEpgListingCopyWithImpl<$Res>
    implements _$XtreamEpgListingCopyWith<$Res> {
  __$XtreamEpgListingCopyWithImpl(this._self, this._then);

  final _XtreamEpgListing _self;
  final $Res Function(_XtreamEpgListing) _then;

/// Create a copy of XtreamEpgListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? startTimestamp = null,Object? stopTimestamp = null,}) {
  return _then(_XtreamEpgListing(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startTimestamp: null == startTimestamp ? _self.startTimestamp : startTimestamp // ignore: cast_nullable_to_non_nullable
as int,stopTimestamp: null == stopTimestamp ? _self.stopTimestamp : stopTimestamp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
