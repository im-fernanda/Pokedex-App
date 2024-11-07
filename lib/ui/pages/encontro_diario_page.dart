import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import 'package:pokedex_app/ui/pages/pokemon_details_page.dart';

import '../../data/database/dao/captured_pokemon_dao.dart';
import '../../data/repository/pokemon_repository_impl.dart';
import '../../domain/pokemon.dart';

class EncontroDiarioPage extends StatefulWidget {
  @override
  _EncontroDiarioPageState createState() => _EncontroDiarioPageState();
}

class _EncontroDiarioPageState extends State<EncontroDiarioPage> {
  late Future<Pokemon> _pokemonFuture;
  bool _isCaptured = false;

  @override
  void initState() {
    super.initState();
    _isCaptured = false;
    _pokemonFuture = _fetchPokemonOfTheDay();
  }

  // Método para buscar o Pokémon do dia
  Future<Pokemon> _fetchPokemonOfTheDay() async {
    // Obtendo o PokemonRepository e o CapturedPokemonDao dos providers
    final pokemonRepository = context.read<PokemonRepositoryImpl>();
    final capturedPokemonDao = context.read<CapturedPokemonDao>();

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
                  ),
                ),
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
    final capturedPokemonDao = context.read<CapturedPokemonDao>();

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
            _isCaptured = true;
          });
        },
      ).show();
    }
  }
}
