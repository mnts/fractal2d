import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../diagram_editor.dart';
import '../../providers/positioner.dart';
import '../data/custom_component_data.dart';

mixin RiverpodPolicy implements CanvasPolicy {
  late Ref ref;
  refer(Ref ref) {
    this.ref = ref;
  }

  @override
  onCanvasTapUp(TapUpDetails details) async {
    final positioner = ref.read(Positioner.provider.notifier);

    if (!positioner.isPlaced) positioner.moveTo(details.localPosition);
  }
}
