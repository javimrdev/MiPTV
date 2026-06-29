// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeFilters {

 String? get quality; String? get category; String? get country;
/// Create a copy of HomeFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeFiltersCopyWith<HomeFilters> get copyWith => _$HomeFiltersCopyWithImpl<HomeFilters>(this as HomeFilters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeFilters&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.category, category) || other.category == category)&&(identical(other.country, country) || other.country == country));
}


@override
int get hashCode => Object.hash(runtimeType,quality,category,country);

@override
String toString() {
  return 'HomeFilters(quality: $quality, category: $category, country: $country)';
}


}

/// @nodoc
abstract mixin class $HomeFiltersCopyWith<$Res>  {
  factory $HomeFiltersCopyWith(HomeFilters value, $Res Function(HomeFilters) _then) = _$HomeFiltersCopyWithImpl;
@useResult
$Res call({
 String? quality, String? category, String? country
});




}
/// @nodoc
class _$HomeFiltersCopyWithImpl<$Res>
    implements $HomeFiltersCopyWith<$Res> {
  _$HomeFiltersCopyWithImpl(this._self, this._then);

  final HomeFilters _self;
  final $Res Function(HomeFilters) _then;

/// Create a copy of HomeFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quality = freezed,Object? category = freezed,Object? country = freezed,}) {
  return _then(_self.copyWith(
quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeFilters].
extension HomeFiltersPatterns on HomeFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeFilters value)  $default,){
final _that = this;
switch (_that) {
case _HomeFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeFilters value)?  $default,){
final _that = this;
switch (_that) {
case _HomeFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? quality,  String? category,  String? country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeFilters() when $default != null:
return $default(_that.quality,_that.category,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? quality,  String? category,  String? country)  $default,) {final _that = this;
switch (_that) {
case _HomeFilters():
return $default(_that.quality,_that.category,_that.country);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? quality,  String? category,  String? country)?  $default,) {final _that = this;
switch (_that) {
case _HomeFilters() when $default != null:
return $default(_that.quality,_that.category,_that.country);case _:
  return null;

}
}

}

/// @nodoc


class _HomeFilters extends HomeFilters {
  const _HomeFilters({this.quality, this.category, this.country}): super._();
  

@override final  String? quality;
@override final  String? category;
@override final  String? country;

/// Create a copy of HomeFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeFiltersCopyWith<_HomeFilters> get copyWith => __$HomeFiltersCopyWithImpl<_HomeFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeFilters&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.category, category) || other.category == category)&&(identical(other.country, country) || other.country == country));
}


@override
int get hashCode => Object.hash(runtimeType,quality,category,country);

@override
String toString() {
  return 'HomeFilters(quality: $quality, category: $category, country: $country)';
}


}

/// @nodoc
abstract mixin class _$HomeFiltersCopyWith<$Res> implements $HomeFiltersCopyWith<$Res> {
  factory _$HomeFiltersCopyWith(_HomeFilters value, $Res Function(_HomeFilters) _then) = __$HomeFiltersCopyWithImpl;
@override @useResult
$Res call({
 String? quality, String? category, String? country
});




}
/// @nodoc
class __$HomeFiltersCopyWithImpl<$Res>
    implements _$HomeFiltersCopyWith<$Res> {
  __$HomeFiltersCopyWithImpl(this._self, this._then);

  final _HomeFilters _self;
  final $Res Function(_HomeFilters) _then;

/// Create a copy of HomeFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quality = freezed,Object? category = freezed,Object? country = freezed,}) {
  return _then(_HomeFilters(
quality: freezed == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
