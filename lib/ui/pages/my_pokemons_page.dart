import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedex_app/ui/pages/widgets/pokemon_card.dart';
import '../../data/repository/pokemon_repository_impl.dart';
import '../../domain/pokemon.dart';
import 'pokemon_details_page.dart';

class MyPokemonsPage extends StatefulWidget {
  @override
  _MyPokemonsPageState createState() => _MyPokemonsPageState();
}

class _MyPokemonsPageState extends State<MyPokemonsPage> {
  List<Pokemon> _capturedPokemons = [];

  @override
  void initState() {
    super.initState();
    _fetchCapturedPokemons();
  }

  // Método para buscar os Pokémon capturados
  Future<void> _fetchCapturedPokemons() async {
    final pokemonRepository = context.read<PokemonRepositoryImpl>();

    try {
      // Obtém os Pokémons capturados
      final capturedPokemons = await pokemonRepository.getCapturedPokemons();

      // Atualiza o estado com a lista de Pokémon capturados
      setState(() {
        _capturedPokemons = capturedPokemons;
      });
    } catch (e) {
      print('Erro ao buscar Pokémon capturados: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pokémon'),
      ),
      body: _capturedPokemons.isEmpty
          ? const Center(child: Text('Nenhum Pokémon capturado ainda.'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: _capturedPokemons.map((pokemon) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PokemonCard(
                            pokemon: pokemon,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PokemonDetailsPage(
                                    pokemon: pokemon,
                                    onPokemonReleased: _fetchCapturedPokemons,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
