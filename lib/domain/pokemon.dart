import 'package:flutter/material.dart';
import 'base_stats.dart';

class Pokemon {
  final int id;
  final String name;
  final List<String> type;
  final BaseStats base;

  Pokemon({
    required this.id,
    required this.name,
    required this.type,
    required this.base,
  });

// Propriedade para obter a URL da imagem
  String get imgUrl {
    // Formata o ID com três dígitos
    final formattedId = id.toString().padLeft(3, '0');
    return 'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$formattedId.png';
  }

  // Método para obter a cor base de acordo com o tipo
  Color? get baseColor => colorFromType(type: type[0]);

  // Método para determinar a cor com base no tipo
  static Color? colorFromType({required String type}) {
    switch (type) {
      case 'Normal':
        return Colors.brown[400];
      case 'Fire':
        return const Color(0xFFFFA756);
      case 'Water':
        return const Color(0xFF58ABF6);
      case 'Grass':
        return const Color(0xFF8BBE8A);
      case 'Electric':
        return const Color(0xFFF2CB55);
      case 'Ice':
        return const Color(0xFF83D0F7);
      case 'Fighting':
        return const Color(0xFFEB4971);
      case 'Poison':
        return const Color(0xFFA553CC);
      case 'Ground':
        return const Color(0xFFF78551);
      case 'Flying':
        return const Color(0xFFCC6D2E);
      case 'Psychic':
        return const Color(0xFFF95587);
      case 'Bug':
        return const Color(0xFF8BD674);
      case 'Rock':
        return const Color(0xFF8A898F);
      case 'Ghost':
        return const Color(0xFF705898);
      case 'Dark':
        return const Color(0xFF674E4D);
      case 'Dragon':
        return const Color(0xFF6F35FC);
      case 'Steel':
        return const Color(0xFFB7B7CE);
      case 'Fairy':
        return const Color(0xFFD685AD);
      default:
        return Colors.grey;
    }
  }
}
