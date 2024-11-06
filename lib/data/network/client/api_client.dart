import 'package:dio/dio.dart';

import '../../../domain/exception/network_exception.dart';
import '../../../domain/pokemon.dart';
import '../entity/http_paged_result.dart';
import '../network_mapper.dart';

class ApiClient {
  late final Dio _dio;
  final NetworkMapper _networkMapper = NetworkMapper();

  ApiClient({required String baseUrl}) {
    _dio = Dio()
      ..options.baseUrl = baseUrl
      //..options.headers
      ..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
  }

  Future<List<PokemonEntity>> getPokemons({int? page, int? limit}) async {
    final response = await _dio.get(
      "/pokemons",
      queryParameters: {
        '_page': page,
        '_per_page': limit,
      },
    );

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw NetworkException(
        statusCode: response.statusCode!,
        message: response.statusMessage,
      );
    } else if (response.statusCode != null) {
      final receivedData =
          HttpPagedResult.fromJson(response.data as Map<String, dynamic>);

      return receivedData.data; // Retorna diretamente a lista de PokemonEntity
    } else {
      throw Exception('Unknown error');
    }
  }

  Future<Pokemon> getPokemonById(int id) async {
    final response = await _dio.get(
      "/pokemons/$id", // Usando o ID na URL
    );

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw NetworkException(
        statusCode: response.statusCode!,
        message: response.statusMessage,
      );
    } else if (response.statusCode != null) {
      //Mapeia a resposta como um único Pokémon
      final pokemonEntity =
          PokemonEntity.fromJson(response.data as Map<String, dynamic>);

      // Converte para a camada de domínio usando o NetworkMapper
      return _networkMapper.toPokemon(pokemonEntity);
    } else {
      throw Exception('Unknown error');
    }
  }
}
