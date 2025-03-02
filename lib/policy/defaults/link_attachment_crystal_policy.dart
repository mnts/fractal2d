import 'package:fractal2d/lib.dart';
import 'package:position_fractal/fractals/offset.dart';

import '../base/link_attachment_policy.dart';
import 'package:flutter/material.dart';

/// Attaches a link endpoint to border of an crystal shape.
mixin LinkAttachmentCrystalPolicy implements LinkAttachmentPolicy {
  @override
  Alignment getLinkEndpointAlignment(
    ComponentFractal componentData,
    OffsetF targetPoint,
  ) {
    var pointPosition = (targetPoint.offset.f -
            (componentData.position.value +
                componentData.size.value.center(OffsetF.zero)))
        .offset;
    pointPosition = Offset(
      pointPosition.dx / componentData.size.width,
      pointPosition.dy / componentData.size.height,
    );

    Offset pointAlignment =
        pointPosition / (pointPosition.dx.abs() + pointPosition.dy.abs());

    return Alignment(pointAlignment.dx, pointAlignment.dy);
  }
}
