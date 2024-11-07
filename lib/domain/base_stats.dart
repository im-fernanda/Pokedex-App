import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_stats.freezed.dart';
part 'base_stats.g.dart';

@freezed
class BaseStats with _$BaseStats {
  const factory BaseStats({
    required int hp,
    required int attack,
    required int defense,
    required int spAttack,
    required int spDefense,
    required int speed,
  }) = _BaseStats;

  factory BaseStats.fromJson(Map<String, dynamic> json) =>
      _$BaseStatsFromJson(json);

  // Método fromMap para mapear um Map<String, dynamic> para um objeto BaseStats
  factory BaseStats.fromMap(Map<String, dynamic> map) {
    return BaseStats(
      hp: map['hp'] ?? 0,
      attack: map['attack'] ?? 0,
      defense: map['defense'] ?? 0,
      spAttack: map['spAttack'] ?? 0,
      spDefense: map['spDefense'] ?? 0,
      speed: map['speed'] ?? 0,
    );
  }
}
