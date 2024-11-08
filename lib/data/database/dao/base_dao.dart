import 'package:flutter/material.dart';
import 'package:pokedex_app/data/database/entity/pokemon_database_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'captured_pokemon_dao.dart';

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
    batch.execute('''
    CREATE TABLE ${CapturedPokemonDbContract.capturedPokemonTable} (
      ${CapturedPokemonDbContract.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${CapturedPokemonDbContract.pokemonIdColumn} INTEGER NOT NULL,
      ${CapturedPokemonDbContract.nameColumn} TEXT NOT NULL,
      ${CapturedPokemonDbContract.hpColumn} INTEGER,
      ${CapturedPokemonDbContract.attackColumn} INTEGER,
      ${CapturedPokemonDbContract.defenseColumn} INTEGER,
      ${CapturedPokemonDbContract.spAttackColumn} INTEGER,
      ${CapturedPokemonDbContract.spDefenseColumn} INTEGER,
      ${CapturedPokemonDbContract.speedColumn} INTEGER,
      ${CapturedPokemonDbContract.type1Column} TEXT,
      ${CapturedPokemonDbContract.type2Column} TEXT,
      FOREIGN KEY(${CapturedPokemonDbContract.pokemonIdColumn}) REFERENCES ${PokemonDatabaseContract.pokemonTable}(${PokemonDatabaseContract.idColumn})
    );
    ''');
  }

  void _createDailyPokemonTable(Batch batch) {
    batch.execute('''
    CREATE TABLE ${DailyPokemonDbContract.tableName} (
      ${DailyPokemonDbContract.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DailyPokemonDbContract.pokemonIdColumn} INTEGER NOT NULL,
      ${DailyPokemonDbContract.nameColumn} TEXT NOT NULL,
      ${DailyPokemonDbContract.hpColumn} INTEGER,
      ${DailyPokemonDbContract.attackColumn} INTEGER,
      ${DailyPokemonDbContract.defenseColumn} INTEGER,
      ${DailyPokemonDbContract.spAttackColumn} INTEGER,
      ${DailyPokemonDbContract.spDefenseColumn} INTEGER,
      ${DailyPokemonDbContract.speedColumn} INTEGER,
      ${DailyPokemonDbContract.type1Column} TEXT,
      ${DailyPokemonDbContract.type2Column} TEXT,
      ${DailyPokemonDbContract.dateColumn} TEXT NOT NULL
    );
    ''');
  }
}
