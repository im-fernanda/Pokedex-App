import 'package:flutter/material.dart';
import 'package:pokedex_app/pages/home/home_page.dart';
import 'package:pokedex_app/pages/pokemons_list.dart';
import 'package:provider/provider.dart';

import 'core/di/configure_providers.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final data = await ConfigureProviders.createDependencyTree();

  runApp(AppRoot(data: data));
}


class AppRoot extends StatelessWidget {
  final ConfigureProviders data;

  const AppRoot({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: data.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fernandas Pokedex',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
        ),
        home: const PokemonsListPage(),
      ),
    );
  }
}


