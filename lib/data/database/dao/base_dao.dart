import 'package:flutter/material.dart';
import 'package:pokedex_app/data/database/entity/pokemon_database_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDao {
  static const databaseVersion = 1;
  static const _databaseName = 'pokemon_database.db';

  Database? _database;

  @protected
  Future<Database> getDb() async {
    _database ??= await _getDatabase();
    return _database!;
  }

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) async {
        final batch = db.batch();
        _createPokemonsTableV1(batch); // Cria a tabela de pokémons
        _createCapturedPokemonsTableV1(
            batch); // Cria a tabela de pokémons capturados
        _createDailyPokemonTable(batch); // Cria a tabela de pokémons sorteados
        await batch.commit();
        await db.execute(
            'PRAGMA foreign_keys = ON;'); // Ativa as chaves estrangeiras
      },
      version: databaseVersion,
    );
  }

  void _createPokemonsTableV1(Batch batch) {
    batch.execute(
      '''
      CREATE TABLE ${PokemonDatabaseContract.pokemonTable} (
        ${PokemonDatabaseContract.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${PokemonDatabaseContract.nameColumn} TEXT NOT NULL,
        ${PokemonDatabaseContract.hpColumn} INTEGER,
        ${PokemonDatabaseContract.attackColumn} INTEGER,
        ${PokemonDatabaseContract.defenseColumn} INTEGER,
        ${PokemonDatabaseContract.spAttackColumn} INTEGER,
        ${PokemonDatabaseContract.spDefenseColumn} INTEGER,
        ${PokemonDatabaseContract.speedColumn} INTEGER,
        ${PokemonDatabaseContract.type1Column} TEXT,
        ${PokemonDatabaseContract.type2Column} TEXT
      );
      ''',
    );
  }

  void _createCapturedPokemonsTableV1(Batch batch) {
    batch.execute(
      '''
    CREATE TABLE captured_pokemon_table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pokemon_id INTEGER NOT NULL,
      FOREIGN KEY(pokemon_id) REFERENCES pokemon_table(id)
    );
    ''',
    );
  }

  void _createDailyPokemonTable(Batch batch) {
    batch.execute('''
    CREATE TABLE daily_pokemon_table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pokemon_id INTEGER NOT NULL,
      data TEXT
    )
  ''');
  }
}
