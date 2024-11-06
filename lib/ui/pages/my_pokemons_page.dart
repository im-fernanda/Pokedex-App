import 'package:flutter/material.dart';
import 'package:pokedex_app/data/network/client/api_client.dart';
import 'package:pokedex_app/ui/pages/widgets/pokemon_card.dart';
import '../../data/database/dao/captured_pokemon_dao.dart';
import '../../domain/pokemon.dart';
import 'pokemon_details_page.dart';
import 'widgets/pokemon_card.dart'; // Importe o widget PokemonCard

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
    final capturedPokemonDao = CapturedPokemonDao();
    final apiClient = ApiClient(baseUrl: 'http://192.168.0.8:3000');

    try {
      // Obtém os IDs dos Pokémon capturados
      final capturedPokemonIds =
          await capturedPokemonDao.getCapturedPokemonIds();

      List<Pokemon> capturedPokemons = [];

      // Para cada ID capturado, obtém os detalhes do Pokémon
      for (var id in capturedPokemonIds) {
        final pokemon = await apiClient.getPokemonById(id);
        capturedPokemons.add(pokemon);
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
              : SingleChildScrollView(
                  // Use SingleChildScrollView para garantir que o conteúdo seja rolável
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: _capturedPokemons.map((pokemon) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: PokemonCard(
                            pokemon: pokemon,
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
                      }).toList(),
                    ),
                  ),
                ),
    );
  }
}
