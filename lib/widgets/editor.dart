import 'package:fractal_flutter/fractal_flutter.dart';
import 'package:fractal_flutter/provider.dart';
import 'package:fractals2d/models/canvas.dart';
import 'package:fractals2d/models/state.dart';
import 'package:flutter/material.dart';
import '../apps/diagram.dart';
import 'canvas.dart';

class DiagramEditor extends StatelessWidget {
  @override
  Widget build(context) {
    final app = context.read<DiagramAppFractal>();
    return FMultiProvider(
      providers: [
        FChangeNotifierProvider<CanvasModel>.value(
          value: app.policy.model,
        ),
        FChangeNotifierProvider<CanvasState>.value(
          value: app.policy.state,
        ),
        FChangeNotifierProvider.value(
          value: app,
        ),
      ],
      builder: (context, child) => const DiagramEditorCanvas(),
    );
  }
}
