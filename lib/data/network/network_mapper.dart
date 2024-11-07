import 'package:pokedex_app/domain/exception/mapper_exception.dart';
import 'package:pokedex_app/domain/pokemon.dart';
import 'package:pokedex_app/domain/base_stats.dart';
import 'package:pokedex_app/data/network/entity/http_paged_result.dart';

class NetworkMapper {
  // Converte uma entidade da rede em um objeto Pokemon
  Pokemon toPokemon(PokemonEntity entity) {
    try {
      final baseStats = BaseStats(
          hp: entity.base.hp,
          attack: entity.base.attack,
          defense: entity.base.defense,
          spAttack: entity.base.spAttack,
          spDefense: entity.base.spDefense,
          speed: entity.base.speed);

      return Pokemon(
        id: int.parse(entity.id),
        name: entity.name.english,
        type: entity.type ?? [],
        base: baseStats,
      );
    } catch (e) {
      throw MapperException<PokemonEntity, Pokemon>(e.toString());
    }
  }

  // Converte uma lista de entidades da API em uma lista de Pokemon
  List<Pokemon> toPokemons(List<PokemonEntity> entities) {
    return entities.map(toPokemon).toList();
  }
}
