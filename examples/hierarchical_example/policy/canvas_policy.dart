import 'dart:math' as math;

import '/diagram_editor.dart';
import '/hierarchical_example/component_data.dart';
import '/hierarchical_example/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  var sizes = [
    Size(80, 60),
    Size(200, 150),
  ];

  @override
  onCanvasTapUp(TapUpDetails details) {
    model.hideAllLinkJoints();

    if (isReadyToAddParent) {
      isReadyToAddParent = false;
      model.updateComponent(selectedComponentId);
    } else {
      if (selectedComponentId != null) {
        hideComponentHighlight(selectedComponentId);
        selectedComponentId = null;
      } else {
        model.addComponent(
          ComponentFractal(
            size: sizes[math.Random().nextInt(sizes.length)],
            minSize: Size(72, 48),
            position: state.fromCanvasCoordinates(details.localPosition),
            data: MyComponentFractal(),
          ),
        );
      }
    }
  }
}
