import 'dart:math' as math;
import 'package:flutter/material.dart';

class MyComponentFractal {
  bool isHighlightVisible;
  Color color =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  MyComponentFractal({this.isHighlightVisible = false});

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }
}
