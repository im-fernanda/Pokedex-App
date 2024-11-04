import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    // Formata o ID do Pokémon para três dígitos
    String formattedId = pokemon.id.toString().padLeft(3, '0');
    // URL da imagem do Pokémon usando o ID formatado
    String imageUrl =
        'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$formattedId.png';

    return Card(
      elevation: 5,
      child: Row(
        children: [
          // Exibe a imagem do Pokémon
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: 100,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name, // Nome do Pokémon
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Types: ${pokemon.type.join(', ')}", // Tipos do Pokémon
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Barra de progresso para cada estatística base
                  _buildStatProgressBar("HP", pokemon.base.hp, 600),
                  _buildStatProgressBar("Attack", pokemon.base.attack, 190),
                  _buildStatProgressBar("Defense", pokemon.base.defense, 230),
                  _buildStatProgressBar(
                      "Sp. Attack", pokemon.base.spAttack, 194),
                  _buildStatProgressBar(
                      "Sp. Defense", pokemon.base.spDefense, 230),
                  _buildStatProgressBar("Speed", pokemon.base.speed, 180),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir uma barra de progresso para uma estatística
  Widget _buildStatProgressBar(String label, int value, int maxValue) {
    // Define a cor com base no valor
    Color barColor;
    if (value < maxValue * 0.3) {
      barColor = Colors.red; // Menos de 30% do máximo
    } else if (value <= maxValue * 0.5) {
      barColor = Colors.orange; // Entre 30% e 60% do máximo
    } else if (value <= maxValue * 0.7) {
      barColor = Colors.yellow; // Entre 60% e 90% do máximo
    } else {
      barColor = Colors.green; // 90% ou mais do máximo
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: $value / $maxValue", // Mostra o rótulo, o valor atual e o máximo
          style: const TextStyle(fontSize: 14),
        ),
        Container(
          width: double.infinity, // Ocupa toda a largura disponível
          height: 8, // Altura da barra de progresso
          child: LinearProgressIndicator(
            value: value / maxValue, // Proporção do valor em relação ao máximo
            backgroundColor: Colors.grey.shade300, // Cor de fundo
            valueColor: AlwaysStoppedAnimation<Color>(
                barColor), // Cor da barra de progresso
          ),
        ),
        const SizedBox(height: 8), // Espaçamento entre as barras
      ],
    );
  }
}
