import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fractal2d/simple_diagram_editor/data/custom_component_data.dart';

import '/diagram_editor.dart';
import '/simple_diagram_editor/policy/custom_policy.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  @override
  onCanvasTap() {
    multipleSelected = [];

    if (isReadyToConnect && selectedComponentId != null) {
      isReadyToConnect = false;
      canvasWriter.model.updateComponent(selectedComponentId!);
    } else {
      selectedComponentId = null;
      hideAllHighlights();
    }
  }
}
