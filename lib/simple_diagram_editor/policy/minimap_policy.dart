import '/diagram_editor.dart';
import '/simple_diagram_editor/policy/component_design_policy.dart';
import 'package:flutter/material.dart';

class MiniMapPolicySet extends PolicySet
    with MiniMapInitPolicy, CanvasControlPolicy, MyComponentDesignPolicy {}

mixin MiniMapInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    canvasWriter.state.setMinScale(0.025);
    canvasWriter.state.setMaxScale(0.25);
    canvasWriter.state.setScale(0.1);
    canvasWriter.state.setCanvasColor(Colors.grey.shade300.withOpacity(0.9));
    canvasWriter.state.setPosition(Offset(80, 60));
  }
}
