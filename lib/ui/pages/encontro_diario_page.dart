import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:pokedex_app/ui/pages/pokemon_details_page.dart';

import '../../data/database/dao/captured_pokemon_dao.dart';
import '../../data/database/dao/pokemon_dao.dart';
import '../../data/database/database_mapper.dart';
import '../../data/network/client/api_client.dart';
import '../../data/repository/pokemon_repository_impl.dart';
import '../../domain/pokemon.dart';
import '../../data/network/network_mapper.dart';

class EncontroDiarioPage extends StatefulWidget {
  @override
  _EncontroDiarioPageState createState() => _EncontroDiarioPageState();
}

class _EncontroDiarioPageState extends State<EncontroDiarioPage> {
  late Future<Pokemon> _pokemonFuture;
  bool _isCaptured = false; // Flag para verificar se o Pokémon foi capturado
  late CapturedPokemonDao capturedPokemonDao;

  @override
  void initState() {
    super.initState();
    _isCaptured = false;
    capturedPokemonDao = CapturedPokemonDao();
    _pokemonFuture = _fetchPokemonOfTheDay();
  }

  // Método para buscar o Pokémon do dia
  Future<Pokemon> _fetchPokemonOfTheDay() async {
    final pokemonDao = PokemonDao();
    final apiClient = ApiClient(baseUrl: 'http://192.168.0.8:3000');
    final databaseMapper = DatabaseMapper();
    final networkMapper = NetworkMapper();

    final pokemonRepository = PokemonRepositoryImpl(
      pokemonDao: pokemonDao,
      capturedPokemonDao: capturedPokemonDao,
      databaseMapper: databaseMapper,
      apiClient: apiClient,
      networkMapper: networkMapper,
    );

    try {
      final pokemon = await pokemonRepository.pokemonOfTheDay();
      _isCaptured = await capturedPokemonDao.isPokemonCaptured(pokemon.id);
      return pokemon;
    } catch (e) {
      throw Exception("Não foi possível obter o Pokémon do dia.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encontro Diário'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<Pokemon>(
        future: _pokemonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar Pokémon do dia'));
          } else if (snapshot.hasData) {
            final pokemon = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: PokemonDetailsPage(
                    pokemon: pokemon,
                  ), // Exibe os detalhes do Pokémon
                ),
                // Botão de Captura apenas se o Pokémon não foi capturado
                if (!_isCaptured)
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: ElevatedButton(
                      onPressed: () => _capturePokemon(context, pokemon),
                      child: const Text('Capturar Pokémon'),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: Text('Nenhum Pokémon encontrado.'));
          }
        },
      ),
    );
  }

  void _capturePokemon(BuildContext context, Pokemon pokemon) async {
    bool isFull = await capturedPokemonDao.isPokedexFull();
    if (isFull) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Pokédex Cheia',
        desc: 'Não é possível capturar mais pokémon.',
        btnOkOnPress: () {},
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.scale,
        title: 'Capturar Pokémon',
        desc: 'Você realmente deseja capturar ${pokemon.name}?',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          await capturedPokemonDao.capturePokemon(pokemon.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${pokemon.name} foi capturado!'),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(bottom: 500, left: 20),
            ),
          );

          setState(() {
            _isCaptured =
                true; // Atualiza o estado para indicar que o Pokémon foi capturado
          });
        },
      ).show();
    }
  }
}
