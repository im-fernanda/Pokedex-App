import 'package:pokedex_app/data/database/dao/base_dao.dart';
import 'package:pokedex_app/data/database/entity/pokemon_database_entity.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/pokemon.dart';
import '../database_mapper.dart';
import 'captured_pokemon_dao.dart';

class PokemonDao extends BaseDao {
  final databaseMapper = DatabaseMapper();
  // Seleciona todos os Pokémons para listagem com paginação
  Future<List<PokemonDatabaseEntity>> selectAll({
    int? limit, // Número máximo de resultados
    int? offset, // Deslocamento para a consulta
  }) async {
    final Database db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      PokemonDatabaseContract.pokemonTable,
      limit: limit,
      offset: offset,
      orderBy:
          '${PokemonDatabaseContract.idColumn} ASC', // Ordena pelo ID em ordem crescente
    );
    // Converte cada linha do resultado em uma instância de PokemonDatabaseEntity
    return List.generate(maps.length, (i) {
      // Transformar o mapa em um objeto da classe PokemonDatabaseEntity com os valores correspondentes
      return PokemonDatabaseEntity.fromJson(maps[i]);
    });
  }

  // Insere um Pokémon no banco de dados
  Future<void> insert(PokemonDatabaseEntity entity) async {
    final Database db = await getDb();
    await db.insert(PokemonDatabaseContract.pokemonTable, entity.toJson());
  }

  // Método para inserir múltiplos Pokémons em uma transação
  Future<void> insertAll(List<PokemonDatabaseEntity> entities) async {
    final Database db = await getDb();
    await db.transaction((transaction) async {
      // Inicia uma transação para inserir múltiplos registros
      for (final entity in entities) {
        transaction.insert(
            PokemonDatabaseContract.pokemonTable, entity.toJson());
      }
    });
  }

  // Deleta todos os Pokémons da tabela
  Future<void> deleteAll() async {
    final Database db = await getDb();
    await db.delete(PokemonDatabaseContract.pokemonTable);
  }

  // Método para obter todos os Pokémon capturados
  Future<List<Pokemon>> getAllCapturedPokemons() async {
    final Database db = await getDb();

    try {
      // Executa uma consulta SQL direta para buscar todos os dados da tabela
      final List<Map<String, dynamic>> pokemonsDb = await db.rawQuery(
          'SELECT * FROM ${CapturedPokemonDbContract.capturedPokemonTable}');

      // Mapeia os resultados da consulta para a lista de PokemonDatabaseEntity
      final List<PokemonDatabaseEntity> pokemonEntities = pokemonsDb.map((row) {
        return PokemonDatabaseEntity(
          id: row['pokemon_id'],
          name: row['name'],
          type1: row['type1'],
          type2: row['type2'],
          hp: row['hp'],
          attack: row['attack'],
          defense: row['defense'],
          spAttack: row['sp_attack'],
          spDefense: row['sp_defense'],
          speed: row['speed'],
        );
      }).toList();

      // Converte as entidades para objetos Pokemon
      final pokemons = databaseMapper.toPokemons(pokemonEntities);

      // Retorna uma lista de nomes dos Pokémon capturados
      return pokemons;
    } catch (e) {
      print('Erro ao buscar todos os Pokémon capturados: $e');
      throw Exception('Falha ao buscar Pokémon capturados');
    }
  }
}
