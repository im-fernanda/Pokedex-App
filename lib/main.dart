import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/pages/encontro_diario_page.dart';
import 'package:pokedex_app/ui/pages/home/home_page.dart';
import 'package:pokedex_app/ui/pages/pokemons_list.dart';
import 'package:pokedex_app/ui/pages/pokemon_details_page.dart';
import 'package:provider/provider.dart';

import 'core/di/configure_providers.dart';
import 'domain/base_stats.dart';
import 'domain/pokemon.dart'; // Importe a classe Pokemon se ainda não o fez

Future<void> main() async {
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
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fernanda's Pokedex",
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/pokedex': (context) => PokemonListPage(),
        // Aqui você cria o Pokemon com ID 1 e passa para EncontroDiarioPage
        '/encontroDiario': (context) => EncontroDiarioPage(
              pokemon: Pokemon(
                id: 1,
                name: 'Bulbasaur',
                base: BaseStats(
                    hp: 45,
                    attack: 49,
                    defense: 49,
                    speed: 45,
                    spAttack: 65,
                    spDefense: 65),
                type: ['Grass', 'Poison'],
                // Exemplo de cor base
              ),
            ),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          elevation: 4,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF355DAA),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
      ),
    );
  }
}
