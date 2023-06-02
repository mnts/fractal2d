import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal2d/diagram_editor.dart';

import '../areas/positioner.dart';
import '../models/position.dart';
import '../simple_diagram_editor/data/custom_component_data.dart';
import '../simple_diagram_editor/policy/my_policy_set.dart';

class DiagramAppFractal extends DiagramEditorContext {
  DiagramAppFractal({required super.policySet});

  Widget Function() positionerBuilder = () => const PositionerArea();

  putImage(Position position) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    final bytes = result?.files.first.bytes;

    if (bytes == null) return;

    final image = Image.memory(bytes);

    final size = Size(
      image.width?.toDouble() ?? 100,
      image.height?.toDouble() ?? 100,
    );

    final pos = Offset(
      position.x - size.width / 2,
      position.y - size.height / 2,
    );

    policySet.canvasWriter.model.addComponent(
      ComponentData(
        size: size,
        data: MyComponentData(
          color: Colors.white,
          borderWidth: 3,
          image: MemoryImage(bytes),
        ),
        type: 'image',
        position: policySet.canvasReader.state.fromCanvasCoordinates(
          pos,
        ),
      ),
    );
  }

  init() {
    if (!canvasState.isInitialized) {
      policySet.initializeDiagramEditor();
      canvasState.isInitialized = true;
    }
  }

  static var provider = Provider<DiagramAppFractal>(
    (ref) => DiagramAppFractal(
      policySet: MyPolicySet()..refer(ref),
    ),
  );
}
