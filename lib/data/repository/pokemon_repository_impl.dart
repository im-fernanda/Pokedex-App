import 'dart:math';
import 'package:intl/intl.dart';
import 'package:pokedex_app/data/database/dao/pokemon_dao.dart';
import 'package:pokedex_app/data/database/database_mapper.dart';
import 'package:pokedex_app/data/network/client/api_client.dart';
import 'package:pokedex_app/data/network/network_mapper.dart';
import 'package:pokedex_app/data/repository/interface_pokemon_repository.dart';
import '../../domain/pokemon.dart';
import '../database/dao/captured_pokemon_dao.dart';
import '../database/entity/pokemon_database_entity.dart';

class PokemonRepositoryImpl implements IPokemonRepository {
  final ApiClient apiClient;
  final NetworkMapper networkMapper;
  final PokemonDao pokemonDao;
  final CapturedPokemonDao capturedPokemonDao;
  final DatabaseMapper databaseMapper;

  PokemonRepositoryImpl({
    required this.pokemonDao,
    required this.capturedPokemonDao,
    required this.databaseMapper,
    required this.apiClient,
    required this.networkMapper,
  });

  @override
  Future<List<Pokemon>> getPokemons(
      {required int page, required int limit}) async {
    // Tenta carregar a partir do banco de dados
    final dbEntities = await pokemonDao.selectAll(
        limit: limit, offset: (page * limit) - limit);

    // Se os dados já existem, carrega esses dados
    if (dbEntities.isNotEmpty) {
      return databaseMapper.toPokemons(dbEntities);
    }
    // Se não existem, busca na API
    final networkEntities =
        await apiClient.getPokemons(page: page, limit: limit);

    // Converte as entidades obtidas da API em objetos de domínio
    final pokemons = networkMapper.toPokemons(networkEntities);
    // Salva os dados no banco local para cache
    pokemonDao.insertAll(databaseMapper.toPokemonDatabaseEntities(pokemons));

    return pokemons;
  }

  Future<Pokemon> pokemonOfTheDay() async {
    try {
      print("Entrou em pokemonoftheday");
      String dataAtual = DateFormat('dd-MM-yyyy').format(DateTime.now());

      // Verifica se já existe um Porkémon do dia para hoje
      final dailyPokemon = await capturedPokemonDao.getDailyPokemon();

      // Verifica se o retorno não é nulo e contém dados válidos
      if (dailyPokemon != null) {
        print("Daily Pokemon encontrado no banco");
        print("Dados: {$dailyPokemon}");
        // Verifica se a data corresponde à data atual
        if (dailyPokemon[DailyPokemonDbContract.dateColumn] == dataAtual) {
          print("Recuperando do banco...");
          // Mapeia o mapa retornado para o objeto Pokemon
          final pokemon = databaseMapper.mapToPokemon(dailyPokemon);
          print("Mapeado: ${pokemon}");

          return pokemon;
        } else {
          print(
              "Data no banco não corresponde a hoje. Sortear um novo Pokémon.");
        }
      } else {
        print("Nenhum Pokémon do dia encontrado no banco.");
      }

      // Caso contrário, sorteia um novo Pokémon e o salva
      final random = Random();
      final int randomId = random.nextInt(809) + 1;
      print("ID sorteado: $randomId");
      print("Data do sorteio: $dataAtual");

      print("Buscando na API...");
      final pokemonFromApi = await apiClient.getPokemonById(randomId);

      // Salva o novo Pokémon do dia no banco
      await capturedPokemonDao.setDailyPokemon(pokemonFromApi, dataAtual);

      // Retorna o Pokémon sorteado
      return pokemonFromApi;
    } catch (e) {
      print(
          "Erro ao buscar Pokémon do dia: ${e.toString()}"); // Log de erro detalhado
      throw Exception("Erro ao buscar Pokémon do dia: ${e.toString()}");
    }
  }

  // Método para capturar Pokémon
  Future<void> capturePokemon(int pokemonId) async {
    await capturedPokemonDao.capturePokemon(pokemonId);
  }

  // Método para liberar Pokémon
  Future<void> releasePokemon(int pokemonId) async {
    await capturedPokemonDao.releasePokemon(pokemonId);
  }

  // Método para obter todos os Pokémons capturados
  Future<List<Pokemon>> getCapturedPokemons() async {
    try {
      // Pega todos os ids dos capturados
      final capturedIds = await capturedPokemonDao.getCapturedPokemonIds();
      // Seleciona todos os Pokémons do banco
      final pokemonEntities = await pokemonDao.selectAll();
      // Cria uma instância do mapper para converter as entidades
      final databaseMapper = DatabaseMapper();

      // Filtra os Pokémons capturados no formato do banco e mapeia para objetos Pokemon
      final capturedPokemons = pokemonEntities
          .where((entity) => capturedIds.contains(entity.id))
          .map((entity) => databaseMapper.toPokemon(entity))
          .toList();

      return capturedPokemons;
    } catch (e) {
      print('Erro ao buscar Pokémon capturados: $e');
      throw Exception('Falha ao buscar Pokémon capturados');
    }
  }
}
