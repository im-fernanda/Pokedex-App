import 'package:pokedex_app/data/database/dao/base_dao.dart';
import 'package:pokedex_app/data/database/entity/pokemon_database_entity.dart';
import 'package:sqflite/sqflite.dart';

class PokemonDao extends BaseDao {
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
}
