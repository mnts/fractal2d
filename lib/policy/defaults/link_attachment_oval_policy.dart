import 'package:position_fractal/fractals/offset.dart';
import '../../lib.dart';
import '../base/link_attachment_policy.dart';
import 'package:flutter/material.dart';

/// Attaches a link endpoint to border of an oval.
mixin LinkAttachmentOvalPolicy implements LinkAttachmentPolicy {
  @override
  Alignment getLinkEndpointAlignment(
    ComponentFractal componentData,
    OffsetF targetPoint,
  ) {
    final center = componentData.size.value.center(OffsetF.zero).offset;
    Offset pointPosition =
        targetPoint.offset - componentData.position.value.offset + center;
    pointPosition = Offset(
      pointPosition.dx / componentData.size.width,
      pointPosition.dy / componentData.size.height,
    );
    SizeF;

    Offset pointAlignment = pointPosition / pointPosition.distance;

    return Alignment(pointAlignment.dx, pointAlignment.dy);
  }
}
