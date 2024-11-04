import 'package:flutter/material.dart';
import 'package:pokedex_app/pages/home/home_page.dart';
import 'package:pokedex_app/pages/pokemons_list.dart';
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fernandas Pokedex',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.amber, // Define a cor âmbar para a AppBar
            foregroundColor:
                Colors.black, // Define a cor do texto e ícones na AppBar
            elevation: 4, // Elevação para dar um leve sombreamento
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            bodyMedium: TextStyle(fontSize: 16, color: Colors.grey.shade200),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        home: const PokemonsListPage(),
      ),
    );
  }
}
