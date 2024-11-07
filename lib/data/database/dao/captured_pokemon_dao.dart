import 'package:pokedex_app/data/database/dao/base_dao.dart';
import 'package:sqflite/sqflite.dart';

class CapturedPokemonDao extends BaseDao {
  // Método para verificar a partir do id se o Pokémon foi capturado
  Future<bool> isPokemonCaptured(int pokemonId) async {
    final Database db = await getDb();
    final List<Map<String, dynamic>> result = await db.query(
      'captured_pokemon_table',
      where: 'pokemon_id = ?',
      whereArgs: [pokemonId],
    );
    return result.isNotEmpty;
  }

  // Verificar se a Pokédex está cheia
  Future<bool> isPokedexFull() async {
    final capturedPokemons = await getCapturedPokemonIds();
    return capturedPokemons.length == 6;
  }

  // Método para captura
  Future<void> capturePokemon(int pokemonId) async {
    final isCaptured = await isPokemonCaptured(pokemonId);
    if (!isCaptured) {
      final Database db = await getDb();
      await db.insert(
        'captured_pokemon_table',
        {'pokemon_id': pokemonId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Seta o pokemon do dia
  Future<void> setDailyPokemon(int pokemonId, String date) async {
    final Database db = await getDb();

    // Insere o Pokémon do dia com a data formatada
    await db.insert(
      'daily_pokemon_table',
      {
        'pokemon_id': pokemonId,
        'data': date,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Libera pokémon da pokedex
  Future<void> releasePokemon(int pokemonId) async {
    final Database db = await getDb();
    await db.delete(
      'captured_pokemon_table',
      where: 'pokemon_id = ?',
      whereArgs: [pokemonId],
    );
  }

  // Obtém todos os IDs dos pokémons capturados
  // Mapeia os resultados para uma lista de IDs.
  Future<List<int>> getCapturedPokemonIds() async {
    final Database db = await getDb();
    final List<Map<String, dynamic>> maps =
        await db.query('captured_pokemon_table');

    List<int> capturedPokemonIds =
        List.generate(maps.length, (i) => maps[i]['pokemon_id'] as int);
    print('IDs capturados: $capturedPokemonIds');
    return capturedPokemonIds;
  }

  // Método para obter o Pokémon do dia com a data
  Future<Map<String, dynamic>?> getDailyPokemon() async {
    final Database db = await getDb();
    final result = await db.query(
      'daily_pokemon_table',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }
}

abstract class CapturedPokemonDbContract {
  static const String captured_pokemon_table = "captured_pokemon_table";
  static const String idColumn = 'id';
  static const String pokemonIdColumn = 'pokemon_id';
}
