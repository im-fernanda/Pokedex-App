import 'package:pokedex_app/domain/pokemon.dart';

abstract class IPokemonRepository {
  Future<List<Pokemon>> getPokemons({required int page, required int limit});

  // Método para buscar o Pokémon do dia
  Future<Pokemon> pokemonOfTheDay();

  // Método para capturar Pokémon
  Future<void> capturePokemonRepository(Pokemon pokemon);

  // Método para liberar Pokémon
  Future<void> releasePokemon(int pokemonId);

  // Método para pegar todos os Pokémon capturados
  Future<List<Pokemon>> getCapturedPokemons();
}
