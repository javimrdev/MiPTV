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

/// Normaliza un entero Xtream que llega como `string`, `number` o ausente.
/// Los timestamps del EPG (`start_timestamp`/`stop_timestamp`) llegan como
/// string en unos paneles y number en otros; aquí los unificamos a `int`.
class XtreamInt implements JsonConverter<int, Object?> {
  const XtreamInt();

  @override
  int fromJson(Object? json) {
    if (json is int) return json;
    if (json is num) return json.toInt();
    return int.tryParse(json?.toString() ?? '') ?? 0;
  }

  @override
  Object? toJson(int value) => value;
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

/// Una entrada del EPG corto (`get_short_epg`) de un canal.
///
/// `title` llega codificado en **base64** (se decodifica en la capa de datos).
/// `startTimestamp`/`stopTimestamp` son timestamps **unix UTC en segundos**; se
/// usan estos —no los strings `start`/`end`, que vienen en la zona horaria del
/// servidor— para calcular ahora/siguiente y para mostrar la hora local.
@freezed
abstract class XtreamEpgListing with _$XtreamEpgListing {
  const factory XtreamEpgListing({
    @JsonKey(name: 'title') @XtreamString() required String title,
    @JsonKey(name: 'start_timestamp') @XtreamInt() required int startTimestamp,
    @JsonKey(name: 'stop_timestamp') @XtreamInt() required int stopTimestamp,
  }) = _XtreamEpgListing;

  factory XtreamEpgListing.fromJson(Map<String, dynamic> json) =>
      _$XtreamEpgListingFromJson(json);
}
