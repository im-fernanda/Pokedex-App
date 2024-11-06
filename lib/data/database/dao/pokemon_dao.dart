import 'dart:math';

import 'package:pokedex_app/data/database/dao/base_dao.dart';
import 'package:pokedex_app/data/database/entity/pokemon_database_entity.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/pokemon.dart';

class PokemonDao extends BaseDao {
  Future<List<PokemonDatabaseEntity>> selectAll({
    int? limit,
    int? offset,
  }) async {
    final Database db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      PokemonDatabaseContract.pokemonTable,
      limit: limit,
      offset: offset,
      orderBy: '${PokemonDatabaseContract.idColumn} ASC',
    );
    return List.generate(maps.length, (i) {
      return PokemonDatabaseEntity.fromJson(maps[i]);
    });
  }

  Future<void> insert(PokemonDatabaseEntity entity) async {
    final Database db = await getDb();
    await db.insert(PokemonDatabaseContract.pokemonTable, entity.toJson());
  }

  Future<void> insertAll(List<PokemonDatabaseEntity> entities) async {
    final Database db = await getDb();
    await db.transaction((transaction) async {
      for (final entity in entities) {
        transaction.insert(
            PokemonDatabaseContract.pokemonTable, entity.toJson());
      }
    });
  }

  Future<void> deleteAll() async {
    final Database db = await getDb();
    await db.delete(PokemonDatabaseContract.pokemonTable);
  }

  Future<PokemonDatabaseEntity> getPokemonById(int id) async {
    final Database db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      PokemonDatabaseContract.pokemonTable,
      where: '${PokemonDatabaseContract.idColumn} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PokemonDatabaseEntity.fromJson(maps.first);
    } else {
      throw Exception('Pokémon não encontrado.');
    }
  }
}
