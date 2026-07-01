import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_entity.freezed.dart';

@freezed
abstract class ProviderEntity with _$ProviderEntity {
  const factory ProviderEntity({
    required int id,
    required String name,
    required String server,
    required String username,
  }) = _ProviderEntity;
}
