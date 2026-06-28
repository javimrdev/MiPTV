import 'package:freezed_annotation/freezed_annotation.dart';

part 'xtream_models.freezed.dart';
part 'xtream_models.g.dart';

/// Normaliza los campos de la API Xtream que llegan como `string` **o** `number`
/// (o ausentes) según el panel, al `String` canónico que usa la app.
///
/// La API Xtream no tiene tipos estables: el cliente de referencia
/// `@iptv/xtream-api` los tipa como `string | number` y los normaliza con
/// serializers. Aplicamos aquí la misma convención para que un `category_id`
/// numérico o un `category_name` nulo no rompan el parseo tras un `200`.
class XtreamString implements JsonConverter<String, Object?> {
  const XtreamString();

  @override
  String fromJson(Object? json) => json?.toString() ?? '';

  @override
  Object? toJson(String value) => value;
}

@freezed
abstract class XtreamAuthResponse with _$XtreamAuthResponse {
  const factory XtreamAuthResponse({
    @JsonKey(name: 'user_info') required XtreamUserInfo userInfo,
    @JsonKey(name: 'server_info') required XtreamServerInfo serverInfo,
  }) = _XtreamAuthResponse;

  factory XtreamAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$XtreamAuthResponseFromJson(json);
}

@freezed
abstract class XtreamUserInfo with _$XtreamUserInfo {
  const factory XtreamUserInfo({
    required String username,
    required String password,
    required String status,
  }) = _XtreamUserInfo;

  factory XtreamUserInfo.fromJson(Map<String, dynamic> json) =>
      _$XtreamUserInfoFromJson(json);
}

@freezed
abstract class XtreamServerInfo with _$XtreamServerInfo {
  const factory XtreamServerInfo({
    @JsonKey(name: 'url') @XtreamString() required String url,
    @JsonKey(name: 'port') @XtreamString() required String port,
  }) = _XtreamServerInfo;

  factory XtreamServerInfo.fromJson(Map<String, dynamic> json) =>
      _$XtreamServerInfoFromJson(json);
}

@freezed
abstract class XtreamCategory with _$XtreamCategory {
  const factory XtreamCategory({
    @JsonKey(name: 'category_id') @XtreamString() required String categoryId,
    @JsonKey(name: 'category_name') @XtreamString() required String categoryName,
  }) = _XtreamCategory;

  factory XtreamCategory.fromJson(Map<String, dynamic> json) =>
      _$XtreamCategoryFromJson(json);
}

@freezed
abstract class XtreamStream with _$XtreamStream {
  const factory XtreamStream({
    @JsonKey(name: 'stream_id') required int streamId,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'stream_icon') @Default('') String logo,
    @JsonKey(name: 'category_id') @XtreamString() required String categoryId,
    @JsonKey(name: 'container_extension') @Default('ts') String extension,
  }) = _XtreamStream;

  factory XtreamStream.fromJson(Map<String, dynamic> json) =>
      _$XtreamStreamFromJson(json);
}
