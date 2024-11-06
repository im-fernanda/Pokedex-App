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
    final capturedPokemonDao =
        CapturedPokemonDao(/* Passar o banco de dados */);
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
                      pokemon: _pokemon), // Exibe os detalhes do Pokémon
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: 200, // Defina a largura desejada
                    child: ElevatedButton(
                      onPressed: () {
                        // Exibe a caixa de diálogo de confirmação
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.scale,
                          title: 'Capturar Pokémon',
                          desc:
                              'Você realmente deseja pegar ${_pokemon.name}?', // Utiliza o nome do Pokémon
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async {
                            // Aqui você pode adicionar a lógica para pegar o Pokémon
                            await capturedPokemonDao
                                .capturePokemon(_pokemon.id);

                            final snackBar = SnackBar(
                              content: Text('${_pokemon.name} foi pego!'),
                              behavior: SnackBarBehavior.floating,
                              margin:
                                  const EdgeInsets.only(bottom: 500, left: 20),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                        ).show();
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
