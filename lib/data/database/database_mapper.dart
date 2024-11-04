import 'package:pokedex_app/data/database/entity/pokemon_database_entity.dart';
import 'package:pokedex_app/domain/exception/mapper_exception.dart';
import 'package:pokedex_app/domain/pokemon.dart';
import 'package:pokedex_app/domain/base_stats.dart';

class DatabaseMapper {
  // Converte uma PokemonDatabaseEntity em um objeto Pokemon
  Pokemon toPokemon(PokemonDatabaseEntity entity) {
    try {
      final baseStats = BaseStats(
        hp: entity.hp ?? 0,
        attack: entity.attack ?? 0,
        defense: entity.defense ?? 0,
        spAttack: entity.spAttack ?? 0,
        spDefense: entity.spDefense ?? 0,
        speed: entity.speed ?? 0,
      );

      return Pokemon(
        id: entity.id ?? 0,
        name: entity.name,
        type: entity.type,
        base: baseStats,
      );
    } catch (e) {
      throw MapperException<PokemonDatabaseEntity, Pokemon>(e.toString());
    }
  }

  // Converte uma lista de PokemonDatabaseEntity em uma lista de Pokemon
  List<Pokemon> toPokemons(List<PokemonDatabaseEntity> entities) {
    return entities.map(toPokemon).toList();
  }

  // Converte um objeto Pokemon em uma PokemonDatabaseEntity
  PokemonDatabaseEntity toPokemonDatabaseEntity(Pokemon pokemon) {
    try {
      return PokemonDatabaseEntity(
        id: null, // Se você não estiver gerando o ID aqui, mantenha como null
        name: pokemon.name,
        type: pokemon
            .type, // Certifique-se de que type esteja no formato correto (List<String>)
        hp: pokemon.base.hp, // Acessa os atributos de BaseStats diretamente
        attack: pokemon.base.attack,
        defense: pokemon.base.defense,
        spAttack: pokemon.base.spAttack,
        spDefense: pokemon.base.spDefense,
        speed: pokemon.base.speed,
      );
    } catch (e) {
      throw MapperException<Pokemon, PokemonDatabaseEntity>(e.toString());
    }
  }

  // Converte uma lista de Pokemon em uma lista de PokemonDatabaseEntity
  List<PokemonDatabaseEntity> toPokemonDatabaseEntities(
      List<Pokemon> pokemons) {
    return pokemons.map(toPokemonDatabaseEntity).toList();
  }
}
