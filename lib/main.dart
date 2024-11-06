import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/pages/encontro_diario_page.dart';
import 'package:pokedex_app/ui/pages/home/home_page.dart';
import 'package:pokedex_app/ui/pages/my_pokemons_page.dart';
import 'package:pokedex_app/ui/pages/pokemons_list.dart';
import 'package:provider/provider.dart';

import 'core/di/configure_providers.dart';

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
        '/pokedex': (context) => const PokemonListPage(),
        '/encontroDiario': (context) => EncontroDiarioPage(),
        '/myPokemons': (context) => MyPokemonsPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 4,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF355DAA),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
      ),
    );
  }
}
