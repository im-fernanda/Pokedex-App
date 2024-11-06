import 'package:flutter/material.dart';
import 'package:pokedex_app/data/network/client/api_client.dart';
import '../../data/database/dao/captured_pokemon_dao.dart';
import '../../data/database/dao/pokemon_dao.dart';
import '../../data/database/database_mapper.dart';
import '../../domain/pokemon.dart';
import 'pokemon_details_page.dart';

class MyPokemonsPage extends StatefulWidget {
  @override
  _MyPokemonsPageState createState() => _MyPokemonsPageState();
}

class _MyPokemonsPageState extends State<MyPokemonsPage> {
  List<Pokemon> _capturedPokemons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCapturedPokemons();
  }

  // Método para buscar os Pokémon capturados
  Future<void> _fetchCapturedPokemons() async {
    // Instancia os DAOs necessários
    final capturedPokemonDao = CapturedPokemonDao();
    final apiClient = ApiClient(baseUrl: 'http://192.168.0.8:3000');
    final databaseMapper = DatabaseMapper();

    try {
      // Obtém os IDs dos Pokémon capturados
      final capturedPokemonIds =
          await capturedPokemonDao.getCapturedPokemonIds();

      List<Pokemon> capturedPokemons = [];

      // Para cada ID capturado, obtém os detalhes do Pokémon
      for (var id in capturedPokemonIds) {
        //Retorna DBEntity
        final pokemon = await apiClient.getPokemonById(id);
        if (pokemon != null) {
          capturedPokemons.add(pokemon);
        }
      }

      // Atualiza o estado com a lista de Pokémon capturados
      setState(() {
        _capturedPokemons = capturedPokemons;
        _isLoading = false;
      });
    } catch (e) {
      // Em caso de erro, desativa o carregamento e exibe o erro no console
      print('Erro ao buscar Pokémon capturados: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pokémon'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _capturedPokemons.isEmpty
              ? const Center(child: Text('Nenhum Pokémon capturado ainda.'))
              : ListView.builder(
                  itemCount: _capturedPokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = _capturedPokemons[index];
                    return Card(
                      child: ListTile(
                        leading:
                            Image.network(pokemon.imgUrl), // Imagem do Pokémon
                        title: Text(pokemon.name), // Nome do Pokémon
                        subtitle: Text("ID: ${pokemon.id}"),
                        onTap: () {
                          // Navega para a página de detalhes ao tocar no card
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PokemonDetailsPage(pokemon: pokemon),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
