import 'package:pokedex_app/data/database/dao/base_dao.dart';
import 'package:pokedex_app/data/database/entity/pokemon_database_entity.dart';
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
    return List.generate(maps.length, (i) => maps[i]['pokemon_id'] as int);
  }
}
