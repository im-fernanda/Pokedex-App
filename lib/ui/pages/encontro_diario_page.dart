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
  late Future<Pokemon>
      _pokemonFuture; // Define como Future para usar no FutureBuilder
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
    final pokemonDao = PokemonDao(/* Passe a instância correta do banco */);
    final apiClient =
        ApiClient(baseUrl: 'http://192.168.0.8:3000'); // URL da API
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
            return Center(child: Text('Erro ao carregar Pokémon do dia'));
          } else if (snapshot.hasData) {
            final pokemon = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: PokemonDetailsPage(
                    pokemon: pokemon,
                  ), // Exibe os detalhes do Pokémon
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: 200,
                    child: _isCaptured
                        ? ElevatedButton(
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.scale,
                                title: 'Soltar Pokémon',
                                desc:
                                    'Você realmente deseja soltar ${pokemon.name}?',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () async {
                                  await capturedPokemonDao
                                      .releasePokemon(pokemon.id);

                                  final snackBar = SnackBar(
                                    content: Text('${pokemon.name} foi solto!'),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.only(
                                        bottom: 500, left: 20),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  setState(() {
                                    _isCaptured = false;
                                  });
                                },
                              ).show();
                            },
                            child: const Text('Soltar Pokémon'),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              bool isFull =
                                  await capturedPokemonDao.isPokedexFull();
                              if (isFull) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.scale,
                                  title: 'Pokédex Lotada',
                                  desc: 'Não é possível capturar mais Pokémon.',
                                  btnOkOnPress: () {},
                                ).show();
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.scale,
                                  title: 'Capturar Pokémon',
                                  desc:
                                      'Você realmente deseja capturar ${pokemon.name}?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    await capturedPokemonDao
                                        .capturePokemon(pokemon.id);

                                    final snackBar = SnackBar(
                                      content: Text(
                                          '${pokemon.name} foi capturado!'),
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.only(
                                          bottom: 500, left: 20),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);

                                    setState(() {
                                      _isCaptured = true;
                                    });
                                  },
                                ).show();
                              }
                            },
                            child: const Text('Capturar Pokémon'),
                          ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Nenhum Pokémon encontrado.'));
          }
        },
      ),
    );
  }
}
