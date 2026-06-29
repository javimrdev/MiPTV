import 'package:freezed_annotation/freezed_annotation.dart';

part 'epg_entity.freezed.dart';

/// Un programa del EPG con su título (ya decodificado) y franja horaria.
/// [start]/[end] son `DateTime` en hora **local** del dispositivo.
@freezed
abstract class EpgProgram with _$EpgProgram {
  const factory EpgProgram({
    required String title,
    required DateTime start,
    required DateTime end,
  }) = _EpgProgram;
}

/// Programación *ahora/siguiente* de un canal. Cualquiera de los dos puede ser
/// `null` cuando el panel no sirve guía para ese canal.
@freezed
abstract class ChannelEpg with _$ChannelEpg {
  const factory ChannelEpg({
    EpgProgram? now,
    EpgProgram? next,
  }) = _ChannelEpg;

  const ChannelEpg._();

  /// `true` cuando no hay ninguna emisión que mostrar.
  bool get isEmpty => now == null && next == null;
}
