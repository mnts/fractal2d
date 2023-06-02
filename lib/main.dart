import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal2d/apps/fractal.dart';
import 'package:flutter/material.dart';
import 'providers/app.dart';
import 'services/logger.dart';
import 'simple_diagram_editor/widget/editor.dart';

void main() {
  AppFractal.provider = editorContextProvider;
  runApp(
    ProviderScope(
      observers: [Logger()],
      child: SimpleDemoEditor(),
    ),
  );
}
