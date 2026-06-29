// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'epg_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EpgProgram {

 String get title; DateTime get start; DateTime get end;
/// Create a copy of EpgProgram
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpgProgramCopyWith<EpgProgram> get copyWith => _$EpgProgramCopyWithImpl<EpgProgram>(this as EpgProgram, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpgProgram&&(identical(other.title, title) || other.title == title)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}


@override
int get hashCode => Object.hash(runtimeType,title,start,end);

@override
String toString() {
  return 'EpgProgram(title: $title, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $EpgProgramCopyWith<$Res>  {
  factory $EpgProgramCopyWith(EpgProgram value, $Res Function(EpgProgram) _then) = _$EpgProgramCopyWithImpl;
@useResult
$Res call({
 String title, DateTime start, DateTime end
});




}
/// @nodoc
class _$EpgProgramCopyWithImpl<$Res>
    implements $EpgProgramCopyWith<$Res> {
  _$EpgProgramCopyWithImpl(this._self, this._then);

  final EpgProgram _self;
  final $Res Function(EpgProgram) _then;

/// Create a copy of EpgProgram
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? start = null,Object? end = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EpgProgram].
extension EpgProgramPatterns on EpgProgram {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpgProgram value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpgProgram() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpgProgram value)  $default,){
final _that = this;
switch (_that) {
case _EpgProgram():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpgProgram value)?  $default,){
final _that = this;
switch (_that) {
case _EpgProgram() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  DateTime start,  DateTime end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpgProgram() when $default != null:
return $default(_that.title,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  DateTime start,  DateTime end)  $default,) {final _that = this;
switch (_that) {
case _EpgProgram():
return $default(_that.title,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  DateTime start,  DateTime end)?  $default,) {final _that = this;
switch (_that) {
case _EpgProgram() when $default != null:
return $default(_that.title,_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc


class _EpgProgram implements EpgProgram {
  const _EpgProgram({required this.title, required this.start, required this.end});
  

@override final  String title;
@override final  DateTime start;
@override final  DateTime end;

/// Create a copy of EpgProgram
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpgProgramCopyWith<_EpgProgram> get copyWith => __$EpgProgramCopyWithImpl<_EpgProgram>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpgProgram&&(identical(other.title, title) || other.title == title)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}


@override
int get hashCode => Object.hash(runtimeType,title,start,end);

@override
String toString() {
  return 'EpgProgram(title: $title, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$EpgProgramCopyWith<$Res> implements $EpgProgramCopyWith<$Res> {
  factory _$EpgProgramCopyWith(_EpgProgram value, $Res Function(_EpgProgram) _then) = __$EpgProgramCopyWithImpl;
@override @useResult
$Res call({
 String title, DateTime start, DateTime end
});




}
/// @nodoc
class __$EpgProgramCopyWithImpl<$Res>
    implements _$EpgProgramCopyWith<$Res> {
  __$EpgProgramCopyWithImpl(this._self, this._then);

  final _EpgProgram _self;
  final $Res Function(_EpgProgram) _then;

/// Create a copy of EpgProgram
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? start = null,Object? end = null,}) {
  return _then(_EpgProgram(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$ChannelEpg {

 EpgProgram? get now; EpgProgram? get next;
/// Create a copy of ChannelEpg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelEpgCopyWith<ChannelEpg> get copyWith => _$ChannelEpgCopyWithImpl<ChannelEpg>(this as ChannelEpg, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelEpg&&(identical(other.now, now) || other.now == now)&&(identical(other.next, next) || other.next == next));
}


@override
int get hashCode => Object.hash(runtimeType,now,next);

@override
String toString() {
  return 'ChannelEpg(now: $now, next: $next)';
}


}

/// @nodoc
abstract mixin class $ChannelEpgCopyWith<$Res>  {
  factory $ChannelEpgCopyWith(ChannelEpg value, $Res Function(ChannelEpg) _then) = _$ChannelEpgCopyWithImpl;
@useResult
$Res call({
 EpgProgram? now, EpgProgram? next
});


$EpgProgramCopyWith<$Res>? get now;$EpgProgramCopyWith<$Res>? get next;

}
/// @nodoc
class _$ChannelEpgCopyWithImpl<$Res>
    implements $ChannelEpgCopyWith<$Res> {
  _$ChannelEpgCopyWithImpl(this._self, this._then);

  final ChannelEpg _self;
  final $Res Function(ChannelEpg) _then;

/// Create a copy of ChannelEpg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? now = freezed,Object? next = freezed,}) {
  return _then(_self.copyWith(
now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as EpgProgram?,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as EpgProgram?,
  ));
}
/// Create a copy of ChannelEpg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpgProgramCopyWith<$Res>? get now {
    if (_self.now == null) {
    return null;
  }

  return $EpgProgramCopyWith<$Res>(_self.now!, (value) {
    return _then(_self.copyWith(now: value));
  });
}/// Create a copy of ChannelEpg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpgProgramCopyWith<$Res>? get next {
    if (_self.next == null) {
    return null;
  }

  return $EpgProgramCopyWith<$Res>(_self.next!, (value) {
    return _then(_self.copyWith(next: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChannelEpg].
extension ChannelEpgPatterns on ChannelEpg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelEpg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelEpg() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelEpg value)  $default,){
final _that = this;
switch (_that) {
case _ChannelEpg():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelEpg value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelEpg() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EpgProgram? now,  EpgProgram? next)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelEpg() when $default != null:
return $default(_that.now,_that.next);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EpgProgram? now,  EpgProgram? next)  $default,) {final _that = this;
switch (_that) {
case _ChannelEpg():
return $default(_that.now,_that.next);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EpgProgram? now,  EpgProgram? next)?  $default,) {final _that = this;
switch (_that) {
case _ChannelEpg() when $default != null:
return $default(_that.now,_that.next);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelEpg extends ChannelEpg {
  const _ChannelEpg({this.now, this.next}): super._();
  

@override final  EpgProgram? now;
@override final  EpgProgram? next;

/// Create a copy of ChannelEpg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelEpgCopyWith<_ChannelEpg> get copyWith => __$ChannelEpgCopyWithImpl<_ChannelEpg>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelEpg&&(identical(other.now, now) || other.now == now)&&(identical(other.next, next) || other.next == next));
}


@override
int get hashCode => Object.hash(runtimeType,now,next);

@override
String toString() {
  return 'ChannelEpg(now: $now, next: $next)';
}


}

/// @nodoc
abstract mixin class _$ChannelEpgCopyWith<$Res> implements $ChannelEpgCopyWith<$Res> {
  factory _$ChannelEpgCopyWith(_ChannelEpg value, $Res Function(_ChannelEpg) _then) = __$ChannelEpgCopyWithImpl;
@override @useResult
$Res call({
 EpgProgram? now, EpgProgram? next
});


@override $EpgProgramCopyWith<$Res>? get now;@override $EpgProgramCopyWith<$Res>? get next;

}
/// @nodoc
class __$ChannelEpgCopyWithImpl<$Res>
    implements _$ChannelEpgCopyWith<$Res> {
  __$ChannelEpgCopyWithImpl(this._self, this._then);

  final _ChannelEpg _self;
  final $Res Function(_ChannelEpg) _then;

/// Create a copy of ChannelEpg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? now = freezed,Object? next = freezed,}) {
  return _then(_ChannelEpg(
now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as EpgProgram?,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as EpgProgram?,
  ));
}

/// Create a copy of ChannelEpg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpgProgramCopyWith<$Res>? get now {
    if (_self.now == null) {
    return null;
  }

  return $EpgProgramCopyWith<$Res>(_self.now!, (value) {
    return _then(_self.copyWith(now: value));
  });
}/// Create a copy of ChannelEpg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpgProgramCopyWith<$Res>? get next {
    if (_self.next == null) {
    return null;
  }

  return $EpgProgramCopyWith<$Res>(_self.next!, (value) {
    return _then(_self.copyWith(next: value));
  });
}
}

// dart format on
