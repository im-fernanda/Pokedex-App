import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../data/network/network_mapper.dart';
import 'pokemon_details_page.dart';
import '../../domain/pokemon.dart';
import '../../data/database/dao/pokemon_dao.dart'; // Ajuste o caminho conforme sua estrutura
import '../../data/database/dao/captured_pokemon_dao.dart'; // Supondo que você tenha um DAO para capturar Pokémon
import 'package:pokedex_app/data/repository/pokemon_repository_impl.dart';
import '../../data/database/database_mapper.dart'; // Certifique-se de importar o DatabaseMapper
import '../../data/network/client/api_client.dart'; // Importando o ApiClient

class EncontroDiarioPage extends StatefulWidget {
  @override
  _EncontroDiarioPageState createState() => _EncontroDiarioPageState();
}

class _EncontroDiarioPageState extends State<EncontroDiarioPage> {
  late Pokemon pokemon;

  @override
  void initState() {
    super.initState();
    _fetchPokemonOfTheDay();
  }

  Future<void> _fetchPokemonOfTheDay() async {
    // Inicializando as dependências
    final pokemonDao =
        PokemonDao(/* Passar o banco de dados ou instância correta */);
    final capturedPokemonDao =
        CapturedPokemonDao(/* Passar o banco de dados */);
    final apiClient =
        ApiClient(baseUrl: ''); // Ou use um mock se não precisar da API
    final databaseMapper = DatabaseMapper();
    final network_mapper = NetworkMapper();

    // Instanciando o repositório
    final pokemonRepository = PokemonRepositoryImpl(
      pokemonDao: pokemonDao,
      capturedPokemonDao: capturedPokemonDao,
      databaseMapper: databaseMapper,
      apiClient: apiClient,
      networkMapper: network_mapper,
    );

    // Obtendo o Pokémon do dia
    pokemon = await pokemonRepository.pokemonOfTheDay();
    setState(() {}); // Atualiza o estado para re-renderizar a página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encontro Diário'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Verifica se o Pokémon está carregado
          pokemon != null
              ? Expanded(
                  child: PokemonDetailsPage(pokemon: pokemon),
                )
              : const Center(
                  child:
                      CircularProgressIndicator()), // Mostra um loading enquanto busca o Pokémon
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
                    desc: 'Você realmente deseja pegar ${pokemon.name}?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      // Aqui você pode adicionar a lógica para pegar o Pokémon
                      await _capturePokemon(pokemon);

                      final snackBar = SnackBar(
                        content: Text('${pokemon.name} foi pego!'),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                            bottom: 500, left: 20, right: 20),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ).show();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Capturar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _capturePokemon(Pokemon pokemon) async {
    // Lógica para capturar o Pokémon
    final capturedPokemonDao =
        CapturedPokemonDao(/* Passar o banco de dados */);
    await capturedPokemonDao.capturePokemon(pokemon.id);
  }
}
