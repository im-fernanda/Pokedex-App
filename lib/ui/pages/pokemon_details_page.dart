import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/pages/widgets/stat_row_widget.dart';
import 'package:pokedex_app/ui/utils/stat_color.dart';
import 'package:pokedex_app/ui/pages/widgets/pokemon_type_icon.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Importando o pacote
import '../../domain/pokemon.dart';
import '../../data/database/dao/captured_pokemon_dao.dart';

class PokemonDetailsPage extends StatefulWidget {
  final Pokemon pokemon;
  final Function()? onPokemonReleased; // Adicionando o callback

  const PokemonDetailsPage(
      {Key? key, required this.pokemon, this.onPokemonReleased})
      : super(key: key);

  @override
  _PokemonDetailsPageState createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  late bool _isCaptured;

  @override
  void initState() {
    super.initState();
    _checkIfCaptured();
  }

  Future<void> _checkIfCaptured() async {
    final capturedPokemonDao = CapturedPokemonDao();
    final isCaptured =
        await capturedPokemonDao.isPokemonCaptured(widget.pokemon.id);

    setState(() {
      _isCaptured = isCaptured;
    });
  }

  Future<void> _toggleCaptureStatus() async {
    final capturedPokemonDao = CapturedPokemonDao();

    if (_isCaptured) {
      _showReleaseConfirmationDialog(capturedPokemonDao);
    } else {
      await capturedPokemonDao.capturePokemon(widget.pokemon.id);
      setState(() {
        _isCaptured = true;
      });
    }
  }

  void _showReleaseConfirmationDialog(CapturedPokemonDao capturedPokemonDao) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      title: 'Confirmar Ação',
      desc: 'Você tem certeza que deseja soltar ${widget.pokemon.name}?',
      btnCancelText: 'Cancelar',
      btnOkText: 'Confirmar',
      btnCancelOnPress: () {
        Navigator.of(context).pop();
      },
      btnOkOnPress: () async {
        await capturedPokemonDao.releasePokemon(widget.pokemon.id);
        setState(() {
          _isCaptured = false;
        });

        // Exibe o diálogo de sucesso
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: 'Pokémon Solto!',
          desc: '${widget.pokemon.name} foi solto.',
          btnOkText: 'Ok',
          btnOkOnPress: () {
            Navigator.of(context).pop(); // Fecha o diálogo de sucesso
            Navigator.of(context)
                .pop(); // Volta para a página anterior (MyPokemonsPage)
          },
        ).show();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    String formattedId = widget.pokemon.id.toString().padLeft(3, '0');

    int totalStats = widget.pokemon.base.hp +
        widget.pokemon.base.attack +
        widget.pokemon.base.defense +
        widget.pokemon.base.speed +
        widget.pokemon.base.spAttack +
        widget.pokemon.base.spDefense;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.28,
            color: widget.pokemon.baseColor,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Center(
                    child: Image.network(
                      widget.pokemon.imgUrl,
                      width: 200,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.pokemon.name} #$formattedId',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Wrap(
                      spacing: 8,
                      children: widget.pokemon.type.map((type) {
                        final color = widget.pokemon.baseColor;
                        return Chip(
                          avatar: Icon(
                            getTypeIcon(type),
                            color: Colors.white,
                          ),
                          label: Text(type),
                          backgroundColor: color?.withOpacity(0.7),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BASE STATS",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: widget.pokemon.baseColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            StatRowWidget(
                              statName: "HP",
                              statValue: widget.pokemon.base.hp,
                              getStatColor: getStatColor,
                            ),
                            StatRowWidget(
                              statName: "Attack",
                              statValue: widget.pokemon.base.attack,
                              getStatColor: getStatColor,
                            ),
                            StatRowWidget(
                              statName: "Defense",
                              statValue: widget.pokemon.base.defense,
                              getStatColor: getStatColor,
                            ),
                            StatRowWidget(
                              statName: "Speed",
                              statValue: widget.pokemon.base.speed,
                              getStatColor: getStatColor,
                            ),
                            StatRowWidget(
                              statName: "Special Atk",
                              statValue: widget.pokemon.base.spAttack,
                              getStatColor: getStatColor,
                            ),
                            StatRowWidget(
                              statName: "Special Def",
                              statValue: widget.pokemon.base.spDefense,
                              getStatColor: getStatColor,
                            ),
                            const SizedBox(height: 8),
                            TotalStatRowWidget(
                              statName: "TOTAL",
                              totalValue: totalStats,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_isCaptured)
                    ElevatedButton(
                      onPressed: _toggleCaptureStatus,
                      child: const Text('Soltar Pokémon'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
