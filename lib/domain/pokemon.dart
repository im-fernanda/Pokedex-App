import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/network/entity/http_paged_result.dart';
import 'base_stats.dart';

part 'pokemon.freezed.dart';
part 'pokemon.g.dart';

@freezed
class Pokemon with _$Pokemon {
  const factory Pokemon({
    required int id,
    required String name,
    required List<String> type,
    required BaseStats base,
    //required String imgUrl,
  }) = _Pokemon;

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);
}
