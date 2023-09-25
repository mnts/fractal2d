import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fractal/lib.dart';
import 'package:fractal2d/policy/base/canvas_policy.dart';
import 'package:fractal_flutter/image.dart';
import 'package:position_fractal/fractals/offset.dart';

import 'package:signed_fractal/models/event.dart';

import '/extensions/model.dart';
import '/diagram_editor.dart';
import 'constrains.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  @override
  onCanvasTap() {
    multipleSelected = [];

    if (isReadyToConnect && selectedComponent != null) {
      isReadyToConnect = false;
      selectedComponent!.notifyListeners();
    } else {
      selectedComponent = null;
      hideAllHighlights();
    }
  }

  @override
  onCanvasTapUp(details) async {
    putImage(details.localPosition);
  }

  putImage(Offset position) async {
    final file = await FractalImage.pick();
    if (file == null) return;
    file.publish();

    final descriptor = await decodeImageFromList(file.bytes);
    final ratio = descriptor.width / descriptor.height;

    final size = SizeF(
      192,
      192 / ratio,
    );

    var pos = OffsetF(
      position.dx - size.width / 2,
      position.dy - size.height / 2,
    );

    final event = EventFractal(
      content: '',
      file: file,
    );

    event.synch();

    final component = ComponentFractal(
      size: size,
      data: event,
      to: model,
      position: state.fromCanvasCoordinates(
        pos,
      ),
    )..synch();

    if (this is ConstrainsPolicy) {
      pos = (this as ConstrainsPolicy)
          .constrain(
            component,
            pos.offset,
          )
          .f;
      component.position.move(pos);
    }

    //model.moveComponentToTheFrontWithChildren(component.id);
    model.notifyListeners();
  }
}
