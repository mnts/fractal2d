import 'package:flutter/material.dart';
import 'package:fractal2d/diagram_editor.dart';
import 'package:fractal_flutter/fractal_flutter.dart';

void main() async {
  await FractalFlutter.init();
  await DiagramAppFractal.prepare();

  runApp(
    const FractalDiagram(),
  );
}
