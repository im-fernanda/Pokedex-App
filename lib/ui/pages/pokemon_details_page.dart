import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/pages/widgets/stat_row_widget.dart';
import 'package:pokedex_app/ui/utils/stat_color.dart';
import 'package:pokedex_app/ui/utils/pokemon_type_icon.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../domain/pokemon.dart';
import '../../data/database/dao/captured_pokemon_dao.dart';

class PokemonDetailsPage extends StatefulWidget {
  final Pokemon pokemon;
  final Function()? onPokemonReleased;

  const PokemonDetailsPage(
      {super.key, required this.pokemon, this.onPokemonReleased});

  @override
  _PokemonDetailsPageState createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  late bool _isCaptured = false;

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
      await capturedPokemonDao.capturePokemon(widget.pokemon);
      setState(() {
        _isCaptured = true;
      });
    }
  }

  void _showReleaseConfirmationDialog(CapturedPokemonDao capturedPokemonDao) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Soltar Pokémon',
      desc: 'Você realmente deseja soltar ${widget.pokemon.name}?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await capturedPokemonDao.releasePokemon(widget.pokemon.id);

        // Exibe um SnackBar notificando o sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.pokemon.name} foi solto!'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 50, left: 20),
          ),
        );

        // Atualiza o estado para refletir que o Pokémon foi solto
        setState(() {
          _isCaptured = false;
        });
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
                    child: CachedNetworkImage(
                      imageUrl: widget.pokemon.imgUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      width: 200,
                      height: 200,
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
