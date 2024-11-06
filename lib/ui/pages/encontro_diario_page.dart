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
  late Pokemon _pokemon; // Pokémon da camada de domínio
  bool _isLoading = true; // Flag para mostrar o carregamento
  bool _isCaptured = false; // Flag para verificar se o Pokémon foi capturado
  late CapturedPokemonDao capturedPokemonDao;

  @override
  void initState() {
    super.initState();
    capturedPokemonDao = CapturedPokemonDao();
    _fetchPokemonOfTheDay();
  }

  // Método para buscar o Pokémon do dia
  Future<void> _fetchPokemonOfTheDay() async {
    final pokemonDao =
        PokemonDao(/* Passar o banco de dados ou instância correta */);
    final apiClient = ApiClient(baseUrl: 'http://192.168.0.8:3000'); // API URL
    final databaseMapper = DatabaseMapper();
    final networkMapper = NetworkMapper();

    // Instanciando o repositório
    final pokemonRepository = PokemonRepositoryImpl(
      pokemonDao: pokemonDao,
      capturedPokemonDao: capturedPokemonDao,
      databaseMapper: databaseMapper,
      apiClient: apiClient,
      networkMapper: networkMapper,
    );

    try {
      // Obtendo o Pokémon do dia do repositório
      final pokemonEntity = await pokemonRepository.pokemonOfTheDay();
      print("Pokémon do dia: ${pokemonEntity.name}");
      _pokemon = pokemonEntity;

      // Verificar se o Pokémon foi capturado
      _isCaptured = await capturedPokemonDao.isPokemonCaptured(_pokemon.id);

      // Atualiza o estado após a captura ou soltura
      setState(() {
        _isLoading = false; // Desativa o carregamento
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Desativa o carregamento
      });
      print('Erro ao buscar Pokémon do dia: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encontro Diário'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Mostra um loading enquanto busca o Pokémon
          : Column(
              children: [
                Expanded(
                  child: PokemonDetailsPage(
                    pokemon: _pokemon,
                  ), // Exibe os detalhes do Pokémon
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: 200, // Defina a largura desejada
                    child: _isCaptured // Verifica se o Pokémon está capturado
                        ? ElevatedButton(
                            onPressed: () {
                              // Exibe a caixa de diálogo para soltar o Pokémon
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.scale,
                                title: 'Soltar Pokémon',
                                desc:
                                    'Você realmente deseja soltar ${_pokemon.name}?', // Utiliza o nome do Pokémon
                                btnCancelOnPress: () {},
                                btnOkOnPress: () async {
                                  await capturedPokemonDao
                                      .releasePokemon(_pokemon.id);

                                  final snackBar = SnackBar(
                                    content:
                                        Text('${_pokemon.name} foi solto!'),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.only(
                                        bottom: 500, left: 20),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  // Atualiza o estado de captura
                                  setState(() {
                                    _isCaptured =
                                        false; // Atualiza para não capturado
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
                                // Exibe mensagem de erro caso a Pokédex esteja cheia
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.scale,
                                  title: 'Pokédex Lotada',
                                  desc: 'Não é possível capturar mais Pokémon.',
                                  btnOkOnPress: () {},
                                ).show();
                              } else {
                                // Exibe a caixa de diálogo de captura
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.scale,
                                  title: 'Capturar Pokémon',
                                  desc:
                                      'Você realmente deseja pegar ${_pokemon.name}?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    // Lógica para pegar o Pokémon
                                    await capturedPokemonDao
                                        .capturePokemon(_pokemon.id);

                                    final snackBar = SnackBar(
                                      content:
                                          Text('${_pokemon.name} foi pego!'),
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.only(
                                          bottom: 500, left: 20),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);

                                    // Atualiza o estado de captura
                                    setState(() {
                                      _isCaptured =
                                          true; // Atualiza para capturado
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
            ),
    );
  }
}
