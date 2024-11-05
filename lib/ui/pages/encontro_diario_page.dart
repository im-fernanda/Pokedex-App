import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'pokemon_details_page.dart';
import '../../domain/pokemon.dart';

class EncontroDiarioPage extends StatelessWidget {
  final Pokemon pokemon;

  const EncontroDiarioPage({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encontro Diário'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Widget que exibe os detalhes do Pokémon
          Expanded(
            child: PokemonDetailsPage(pokemon: pokemon),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              width: 200, // Defina a largura desejada
              child: ElevatedButton(
                onPressed: () {
                  // Exibe a caixa de diálogo de confirmação
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.scale,
                    title: 'Capturar Pokémon',
                    desc: 'Você realmente deseja pegar ${pokemon.name}?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      // Aqui você pode adicionar a lógica para pegar o Pokémon
                      final snackBar = SnackBar(
                        content: Text('${pokemon.name} foi pego!'),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                            bottom: 500, left: 20, right: 20),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ).show();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16), // Ajuste o padding se necessário
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        16), // Use o mesmo borderRadius que na HomePage
                  ),
                ),
                child: const Text('Capturar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
