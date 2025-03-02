import '/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    state.setCanvasColor(Colors.grey[300]);
  }
}
