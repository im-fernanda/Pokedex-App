import 'package:flutter/material.dart';
import 'base_stats.dart';

class Pokemon {
  final int id; // ID do Pokémon
  final String name; // Nome do Pokémon
  final List<String> type; // Tipos do Pokémon
  final BaseStats base; // Estatísticas base

  // Construtor da classe
  Pokemon({
    required this.id,
    required this.name,
    required this.type,
    required this.base,
  });

  // Método para obter a cor base de acordo com o tipo
  Color? get baseColor => _color(type: type[0]);

  // Método estático para determinar a cor com base no tipo
  static Color? _color({required String type}) {
    switch (type) {
      case 'Normal':
        return Colors.brown[400];
      case 'Fire':
        return Colors.red;
      case 'Water':
        return Colors.blue;
      case 'Grass':
        return Colors.green;
      case 'Electric':
        return Colors.amber;
      case 'Ice':
        return Colors.cyanAccent[400];
      case 'Fighting':
        return Colors.orange;
      case 'Poison':
        return Colors.purple;
      case 'Ground':
        return Colors.orange[300];
      case 'Flying':
        return Colors.indigo[200];
      case 'Psychic':
        return Colors.pink;
      case 'Bug':
        return Colors.lightGreen[500];
      case 'Rock':
        return Colors.grey;
      case 'Ghost':
        return Colors.indigo[400];
      case 'Dark':
        return Colors.brown;
      case 'Dragon':
        return Colors.indigo[800];
      case 'Steel':
        return Colors.blueGrey;
      case 'Fairy':
        return Colors.pinkAccent[100];
      default:
        return Colors.grey; // Cor padrão
    }
  }
}
