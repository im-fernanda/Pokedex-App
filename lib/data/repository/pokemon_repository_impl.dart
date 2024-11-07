import 'dart:math';
import 'package:intl/intl.dart';
import 'package:pokedex_app/data/database/dao/pokemon_dao.dart';
import 'package:pokedex_app/data/database/database_mapper.dart';
import 'package:pokedex_app/data/network/client/api_client.dart';
import 'package:pokedex_app/data/network/network_mapper.dart';
import 'package:pokedex_app/data/repository/interface_pokemon_repository.dart';
import '../../domain/pokemon.dart';
import '../database/dao/captured_pokemon_dao.dart';

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

  // Pega o Pokémon do dia
  @override
  Future<Pokemon> pokemonOfTheDay() async {
    try {
      print("Entrou em pokemonoftheday");
      String dataAtual = DateFormat('dd-MM-yyyy').format(DateTime.now());

      // Verifica se já existe um Pokémon do dia para hoje
      final dailyPokemon = await capturedPokemonDao.getDailyPokemon();

      //Se já tiver sido sorteado, retorna o mesmo
      if (dailyPokemon != null && dailyPokemon['data'] == dataAtual) {
        print("Data do sorteio: $dataAtual");
        return await apiClient.getPokemonById(dailyPokemon['pokemon_id']);
      }

      // Sorteia um novo Pokémon se a data for diferente
      final random = Random();
      final int randomId = random.nextInt(809) + 1;
      print("ID sorteado: $randomId");
      print("Data do sorteio: $dataAtual");

      // Busca o Pokémon com o ID sorteado na API
      final pokemonFromApi = await apiClient.getPokemonById(randomId);

      //Salvar no BD
      await capturedPokemonDao.setDailyPokemon(randomId, dataAtual);

      return pokemonFromApi;
    } catch (e) {
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
  }
}
