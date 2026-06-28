// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xtream_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_XtreamAuthResponse _$XtreamAuthResponseFromJson(Map<String, dynamic> json) =>
    _XtreamAuthResponse(
      userInfo: XtreamUserInfo.fromJson(
        json['user_info'] as Map<String, dynamic>,
      ),
      serverInfo: XtreamServerInfo.fromJson(
        json['server_info'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$XtreamAuthResponseToJson(_XtreamAuthResponse instance) =>
    <String, dynamic>{
      'user_info': instance.userInfo,
      'server_info': instance.serverInfo,
    };

_XtreamUserInfo _$XtreamUserInfoFromJson(Map<String, dynamic> json) =>
    _XtreamUserInfo(
      username: json['username'] as String,
      password: json['password'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$XtreamUserInfoToJson(_XtreamUserInfo instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'status': instance.status,
    };

_XtreamServerInfo _$XtreamServerInfoFromJson(Map<String, dynamic> json) =>
    _XtreamServerInfo(
      url: const XtreamString().fromJson(json['url']),
      port: const XtreamString().fromJson(json['port']),
    );

Map<String, dynamic> _$XtreamServerInfoToJson(_XtreamServerInfo instance) =>
    <String, dynamic>{
      'url': const XtreamString().toJson(instance.url),
      'port': const XtreamString().toJson(instance.port),
    };

_XtreamCategory _$XtreamCategoryFromJson(Map<String, dynamic> json) =>
    _XtreamCategory(
      categoryId: const XtreamString().fromJson(json['category_id']),
      categoryName: const XtreamString().fromJson(json['category_name']),
    );

Map<String, dynamic> _$XtreamCategoryToJson(_XtreamCategory instance) =>
    <String, dynamic>{
      'category_id': const XtreamString().toJson(instance.categoryId),
      'category_name': const XtreamString().toJson(instance.categoryName),
    };

_XtreamStream _$XtreamStreamFromJson(Map<String, dynamic> json) =>
    _XtreamStream(
      streamId: (json['stream_id'] as num).toInt(),
      name: json['name'] as String,
      logo: json['stream_icon'] as String? ?? '',
      categoryId: const XtreamString().fromJson(json['category_id']),
      extension: json['container_extension'] as String? ?? 'ts',
    );

Map<String, dynamic> _$XtreamStreamToJson(_XtreamStream instance) =>
    <String, dynamic>{
      'stream_id': instance.streamId,
      'name': instance.name,
      'stream_icon': instance.logo,
      'category_id': const XtreamString().toJson(instance.categoryId),
      'container_extension': instance.extension,
    };
