import 'package:freezed_annotation/freezed_annotation.dart';

part 'xtream_models.freezed.dart';
part 'xtream_models.g.dart';

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
    @JsonKey(name: 'url') required String url,
    @JsonKey(name: 'port') required String port,
  }) = _XtreamServerInfo;

  factory XtreamServerInfo.fromJson(Map<String, dynamic> json) =>
      _$XtreamServerInfoFromJson(json);
}

@freezed
abstract class XtreamCategory with _$XtreamCategory {
  const factory XtreamCategory({
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'category_name') required String categoryName,
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
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'container_extension') @Default('ts') String extension,
  }) = _XtreamStream;

  factory XtreamStream.fromJson(Map<String, dynamic> json) =>
      _$XtreamStreamFromJson(json);
}
