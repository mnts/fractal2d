import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fractal/fractal.dart';
import 'package:fractal2d/policy/base/canvas_policy.dart';
import 'package:fractal_flutter/image.dart';
import 'package:position_fractal/fractals/offset.dart';
import 'package:signed_fractal/models/index.dart';
import '../../lib.dart';
import 'constrains.dart';

mixin MyCanvasPolicy implements CanvasPolicy, CustomStatePolicy {
  @override
  onCanvasTap() {
    multipleSelected = [];

    if (isReadyToConnect && selectedComponent != null) {
      isReadyToConnect = false;
      notifyListeners();
      model.notifyListeners();
      //selectedComponent!.notifyListeners();
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
    await file.publish();

    final descriptor = await decodeImageFromList(file.bytes);
    final ratio = descriptor.width / descriptor.height;

    final size = SizeF(
      192,
      192 / ratio,
    );

    final event = EventFractal(
      content: file.name,
      kind: FKind.file,
    );

    await event.synch();

    putComponent(
      position: position,
      data: event,
      size: size,
    );
  }

  putComponent({
    required Offset position,
    SizeF size = const SizeF(192, 192),
    EventFractal? data,
  }) async {
    var pos = OffsetF(
      position.dx - size.width / 2,
      position.dy - size.height / 2,
    );

    final component = ComponentFractal(
      size: size,
      data: data,
      to: model,
      position: state.fromCanvasCoordinates(
        pos,
      ),
    );

    await component.synch();

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
