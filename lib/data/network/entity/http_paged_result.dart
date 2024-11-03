import 'package:json_annotation/json_annotation.dart';
import '../../../domain/pokemon.dart';
import '../../../domain/base_stats.dart';

part 'http_paged_result.g.dart';

@JsonSerializable()
class HttpPagedResult {
  final int first;
  final dynamic prev;
  final int next;
  final int last;
  final int pages;
  final int items;
  final List<PokemonEntity> data;

  HttpPagedResult({
    required this.first,
    required this.prev,
    required this.next,
    required this.last,
    required this.pages,
    required this.items,
    required this.data,
  });

  factory HttpPagedResult.fromJson(Map<String, dynamic> json) =>
      _$HttpPagedResultFromJson(json);
}

@JsonSerializable()
class PokemonEntity {
  final int id;
  final Map<String, String>
      name; // Alterado para Map<String, String> para suportar diferentes idiomas
  final List<String> type; // Tipos do Pokémon
  final BaseStats base; // Estatísticas base

  PokemonEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.base,
  });

  factory PokemonEntity.fromJson(Map<String, dynamic> json) =>
      _$PokemonEntityFromJson(json);
}
