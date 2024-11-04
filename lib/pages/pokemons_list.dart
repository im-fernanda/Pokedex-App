import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../data/repository/pokemon_repository_impl.dart';
import '../../domain/pokemon.dart';
import 'widgets/pokemon_card.dart';

class PokemonsListPage extends StatefulWidget {
  const PokemonsListPage({super.key});

  @override
  State<PokemonsListPage> createState() => _PokemonsListPageState();
}

class _PokemonsListPageState extends State<PokemonsListPage> {
  late final PokemonRepositoryImpl pokemonsRepo;
  late final PagingController<int, Pokemon> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    pokemonsRepo = Provider.of<PokemonRepositoryImpl>(context, listen: false);
    _pagingController.addPageRequestListener(
      (pageKey) async {
        try {
          final pokemons =
              await pokemonsRepo.getPokemons(page: pageKey, limit: 10);
          _pagingController.appendPage(pokemons, pageKey + 1);
        } catch (e) {
          _pagingController.error = e;
          print(e);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokémons"),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: PagedListView<int, Pokemon>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Pokemon>(
          itemBuilder: (context, pokemon, index) =>
              PokemonCard(pokemon: pokemon),
        ),
      ),
    );
  }
}
