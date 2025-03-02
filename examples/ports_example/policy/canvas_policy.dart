import '/diagram_editor.dart';
import '/ports_example/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  @override
  onCanvasTapUp(TapUpDetails details) {
    model.hideAllLinkJoints();

    if (selectedPortId == null) {
      addComponentFractalWithPorts(
          state.fromCanvasCoordinates(details.localPosition));
    }
    deselectAllPorts();
  }
}
