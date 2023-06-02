import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider;
import 'package:fractal_flutter/fractal_flutter.dart';

import '../providers/app.dart';
import '/canvas_context/canvas_model.dart';
import '/canvas_context/canvas_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'canvas.dart';

class DiagramEditor extends ConsumerWidget {
  @override
  Widget build(context, ref) {
    final ctx = ref.watch(editorContextProvider);
    return FMultiProvider(
      providers: [
        FChangeNotifierProvider<CanvasModel>.value(
          value: ctx.canvasModel,
        ),
        FChangeNotifierProvider<CanvasState>.value(
          value: ctx.canvasState,
        ),
      ],
      builder: (context, child) {
        return const DiagramEditorCanvas();
      },
    );
  }
}
