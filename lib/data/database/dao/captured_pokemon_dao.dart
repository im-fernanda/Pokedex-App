import 'package:pokedex_app/data/database/dao/base_dao.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class CapturedPokemonDao extends BaseDao {
  Future<void> capturePokemon(int pokemonId) async {
    final Database db = await getDb();
    await db.insert(
      'captured_pokemon_table',
      {'pokemon_id': pokemonId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> setDailyPokemon(int pokemonId) async {
    final Database db = await getDb();

    // Obter a data atual no formato dd-MM-yyyy
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // Inserir o Pokémon do dia com a data formatada
    await db.insert(
      'daily_pokemon_table',
      {
        'pokemon_id': pokemonId,
        'data': formattedDate,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> releasePokemon(int pokemonId) async {
    final Database db = await getDb();
    await db.delete(
      'captured_pokemon_table',
      where: 'pokemon_id = ?',
      whereArgs: [pokemonId],
    );
  }

  Future<List<int>> getCapturedPokemonIds() async {
    final Database db = await getDb();
    final List<Map<String, dynamic>> maps =
        await db.query('captured_pokemon_table');

    List<int> capturedPokemonIds =
        List.generate(maps.length, (i) => maps[i]['pokemon_id'] as int);
    print('IDs capturados: $capturedPokemonIds');
    return capturedPokemonIds;
  }
}

abstract class CapturedPokemonDbContract {
  static const String captured_pokemon_table = "captured_pokemon_table";
  static const String idColumn = 'id';
  static const String pokemonIdColumn = 'pokemon_id';
}
