import 'package:freezed_annotation/freezed_annotation.dart';

part 'stream_entity.freezed.dart';

@freezed
abstract class StreamEntity with _$StreamEntity {
  const factory StreamEntity({
    required int id,
    required String name,
    required String logo,
    required String categoryId,
    required String extension,
  }) = _StreamEntity;
}
