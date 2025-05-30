import 'package:position_fractal/fractals/offset.dart';

import '../../lib.dart';
import '../base/link_attachment_policy.dart';
import 'package:flutter/material.dart';

/// Attaches a link endpoint to border of a rectangle.
mixin LinkAttachmentRectPolicy implements LinkAttachmentPolicy {
  @override
  Alignment getLinkEndpointAlignment(
    ComponentFractal componentData,
    OffsetF targetPoint,
  ) {
    Offset pointPosition = targetPoint.offset -
        (componentData.position.value.offset +
            componentData.size.value.size.center(Offset.zero));
    pointPosition = Offset(
      pointPosition.dx / componentData.size.width,
      pointPosition.dy / componentData.size.height,
    );

    Offset pointAlignment;
    if (pointPosition.dx.abs() >= pointPosition.dy.abs()) {
      pointAlignment = Offset(pointPosition.dx / pointPosition.dx.abs(),
          pointPosition.dy / pointPosition.dx.abs());
    } else {
      pointAlignment = Offset(pointPosition.dx / pointPosition.dy.abs(),
          pointPosition.dy / pointPosition.dy.abs());
    }
    return Alignment(pointAlignment.dx, pointAlignment.dy);
  }
}
