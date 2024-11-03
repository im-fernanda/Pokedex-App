import 'package:pokedex_app/domain/exception/mapper_exception.dart';
import 'package:pokedex_app/domain/pokemon.dart';
import 'package:pokedex_app/domain/base_stats.dart';
import 'package:pokedex_app/data/network/entity/http_paged_result.dart';

class NetworkMapper {
  // Converte uma entidade da rede (obtida da API) em um objeto Pokemon
  Pokemon toPokemon(PokemonEntity entity) {
    try {
      // Usa o método fromJson de BaseStats para criar uma instância a partir do Map
      final baseStats = BaseStats.fromJson(entity.base as Map<String, dynamic>);

      // Retorna uma instância de Pokemon com base nos dados da entidade e em baseStats
      return Pokemon(
        id: entity.id,
        name: entity.name['english'] ??
            'Unknown', // Usa o nome em inglês, ou "Unknown" se não disponível
        type: entity.type,
        base: baseStats,
      );
    } catch (e) {
      throw MapperException<PokemonEntity, Pokemon>(e.toString());
    }
  }

  // Converte uma lista de entidades da rede (obtidas da API) em uma lista de Pokemon
  List<Pokemon> toPokemons(List<PokemonEntity> entities) {
    return entities.map(toPokemon).toList();
  }
}
