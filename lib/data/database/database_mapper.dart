import 'package:pokedex_app/data/database/entity/pokemon_database_entity.dart';
import 'package:pokedex_app/domain/exception/mapper_exception.dart';
import 'package:pokedex_app/domain/pokemon.dart';
import 'package:pokedex_app/domain/base_stats.dart';

class DatabaseMapper {
  // Converte uma PokemonDatabaseEntity em um objeto Pokemon
  Pokemon toPokemon(PokemonDatabaseEntity entity) {
    try {
      // Aqui, estamos criando um objeto BaseStats usando os campos diretos da entidade
      final baseStats = BaseStats(
        hp: entity.hp,
        attack: entity.attack,
        defense: entity.defense,
        spAttack: entity.spAttack,
        spDefense: entity.spDefense,
        speed: entity.speed,
      );

      return Pokemon(
        id: entity.id ??
            0, // Se o ID for null, defina como 0 ou trate conforme necessário
        name: entity.name,
        type: entity
            .type, // Certifique-se de que o tipo está no formato correto (List<String>)
        base: baseStats, // Passando o objeto BaseStats
      );
    } catch (e) {
      throw MapperException<PokemonDatabaseEntity, Pokemon>(e.toString());
    }
  }

  // Converte uma lista de PokemonDatabaseEntity em uma lista de Pokemon
  List<Pokemon> toPokemons(List<PokemonDatabaseEntity> entities) {
    final List<Pokemon> pokemons = [];
    for (var pokemonEntity in entities) {
      pokemons.add(toPokemon(pokemonEntity));
    }
    return pokemons;
  }

  // Converte um objeto Pokemon em uma PokemonDatabaseEntity
  PokemonDatabaseEntity toPokemonDatabaseEntity(Pokemon pokemon) {
    try {
      return PokemonDatabaseEntity(
        id: null, // Se você não estiver gerando o ID aqui, mantenha como null
        name: pokemon.name,
        type: pokemon
            .type, // Certifique-se de que o tipo está no formato correto (List<String>)
        hp: pokemon.base.hp, // Acessando os atributos de BaseStats diretamente
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
    final List<PokemonDatabaseEntity> pokemonDatabaseEntities = [];
    for (var p in pokemons) {
      pokemonDatabaseEntities.add(toPokemonDatabaseEntity(p));
    }
    return pokemonDatabaseEntities;
  }
}
