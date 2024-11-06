import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/pokemon.dart';
import 'type_widget.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    // Formata o ID do Pokémon para três dígitos
    String formattedId = pokemon.id.toString().padLeft(3, '0');

    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Center(
        child: SizedBox(
          width: 350,
          height: 130,
          child: Card(
            elevation: 5,
            color: pokemon.baseColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Detalhes do Pokémon (nomes e tipos) à esquerda
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 18),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                pokemon.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Wrap(
                              children: pokemon.type.map((type) {
                                return TypeWidget(
                                  name: type,
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          width: 16), // Espaçamento entre detalhes e imagem
                      // Imagem do Pokémon à direita
                      SizedBox(
                        width: 150,
                        height: 110,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: pokemon.imgUrl,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ID do Pokémon no canto superior direito
                Positioned(
                  top: 8,
                  right: 8,
                  child: Text(
                    '#$formattedId',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
