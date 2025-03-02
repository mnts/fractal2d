import 'package:fractal2d/policy/base/link_attachment_policy.dart';
import 'package:fractals2d/models/component.dart';
import 'package:position_fractal/fractals/offset.dart';

import '../../lib.dart';
import 'package:flutter/material.dart';

/// Attach to border, depends on shape
mixin MyLinkAttachmentPolicy implements LinkAttachmentPolicy {
  @override
  Alignment getLinkEndpointAlignment(
    ComponentFractal componentData,
    OffsetF targetPoint,
  ) {
    var pointPosition = targetPoint -
        (componentData.position.value +
            componentData.size.value.center(OffsetF.zero));
    pointPosition = OffsetF(
      pointPosition.dx / componentData.size.width,
      pointPosition.dy / componentData.size.height,
    );

    switch (componentData.type) {
      case 'oval':
        final pointAlignment = pointPosition / pointPosition.distance;
        return Alignment(pointAlignment.dx, pointAlignment.dy);
      case 'crystal':
        OffsetF pointAlignment =
            pointPosition / (pointPosition.dx.abs() + pointPosition.dy.abs());

        return Alignment(pointAlignment.dx, pointAlignment.dy);

      default:
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
}
