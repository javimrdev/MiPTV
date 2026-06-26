import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_entity.freezed.dart';

@freezed
abstract class FavoriteEntity with _$FavoriteEntity {
  const factory FavoriteEntity({
    required int streamId,
    required DateTime createdAt,
  }) = _FavoriteEntity;
}
