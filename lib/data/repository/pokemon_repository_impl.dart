import 'dart:math';

import 'package:pokedex_app/data/database/dao/pokemon_dao.dart';
import 'package:pokedex_app/data/database/database_mapper.dart';
import 'package:pokedex_app/data/network/client/api_client.dart';
import 'package:pokedex_app/data/network/entity/http_paged_result.dart';
import 'package:pokedex_app/data/network/network_mapper.dart';
import 'package:pokedex_app/data/repository/pokemon_repository.dart';
import '../../domain/exception/mapper_exception.dart';
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

  // Método para capturar Pokémon
  Future<void> capturePokemon(int pokemonId) async {
    await capturedPokemonDao.capturePokemon(pokemonId);
  }

  // Método para liberar Pokémon
  Future<void> releasePokemon(int pokemonId) async {
    await capturedPokemonDao.releasePokemon(pokemonId);
  }

  Future<List<Pokemon>> getCapturedPokemons() async {
    final capturedIds = await capturedPokemonDao.getCapturedPokemonIds();
    final pokemonEntities =
        await pokemonDao.selectAll(); // Seleciona todos os Pokémons do banco

    // Cria uma instância do mapper para converter as entidades
    final databaseMapper = DatabaseMapper();

    // Filtra os Pokémons capturados e mapeia para a classe Pokemon
    final capturedPokemons = pokemonEntities
        .where((entity) => capturedIds.contains(entity.id))
        .map((entity) => databaseMapper.toPokemon(entity))
        .toList();

    return capturedPokemons;
  }

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
    // Caso contrário, busca pela API remota
    final networkEntities =
        await apiClient.getPokemons(page: page, limit: limit);

    final pokemons = networkMapper.toPokemons(networkEntities);
    // E salva os dados no banco local para cache
    pokemonDao.insertAll(databaseMapper.toPokemonDatabaseEntities(pokemons));

    return pokemons;
  }

  Future<Pokemon> pokemonOfTheDay() async {
    try {
      // Sorteia um número entre 1 e 809 (considerando que há 809 Pokémon disponíveis)
      final random = Random();
      final int randomId =
          random.nextInt(809) + 1; // Ajuste para o range de IDs

      print("ID sorteado: $randomId");

      // Busca o Pokémon com o ID sorteado na API
      final pokemonFromApi = await apiClient.getPokemonById(randomId);

      return pokemonFromApi; // Retorna o Pokémon sorteado
    } catch (e) {
      throw Exception("Erro ao buscar Pokémon do dia: ${e.toString()}");
    }
  }
}
