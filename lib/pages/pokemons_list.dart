import 'package:flutter/material.dart';
import 'package:pokedex_app/data/repository/pokemon_repository.dart';
import 'package:pokedex_app/pages/home/home_loading.dart';
import 'package:pokedex_app/domain/pokemon.dart';

import 'home/home_page.dart';

class PokemonsList extends StatelessWidget {
  const PokemonsList({required this.repository, super.key});
  final IPokemonRepository repository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>>(
        future: repository.getPokemons(page: 1, limit: 10),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return HomeLoading();
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return HomePage(list: snapshot.data!);
          }

          return Container();
        });
  }
}
