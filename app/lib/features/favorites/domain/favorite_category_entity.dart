import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_category_entity.freezed.dart';

@freezed
abstract class FavoriteCategoryEntity with _$FavoriteCategoryEntity {
  const factory FavoriteCategoryEntity({
    required String categoryId,
    required String name,
    required DateTime createdAt,
  }) = _FavoriteCategoryEntity;
}
