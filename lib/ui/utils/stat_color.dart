import 'package:flutter/material.dart';

Color getStatColor(int statValue) {
  if (statValue >= 130) {
    return Colors.green[800]!;
  } else if (statValue >= 100) {
    return Colors.green[400]!;
  } else if (statValue >= 60) {
    return Colors.yellow;
  } else if (statValue >= 31) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}
