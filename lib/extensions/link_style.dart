import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fractal2d/diagram_editor.dart';
import 'package:fractals2d/models/link_style.dart';
import 'package:position_fractal/fractals/offset.dart';

extension LinkStyleExt on LinkStyle {
  Path getArrowTipPath(
    ArrowType arrowType,
    double arrowSize,
    OffsetF point1,
    OffsetF point2,
    double scale,
  ) {
    switch (arrowType) {
      case ArrowType.none:
        return Path();
      case ArrowType.arrow:
        return getArrowPath(
          arrowSize,
          point1.offset,
          point2.offset,
          scale,
          1,
        );
      case ArrowType.pointedArrow:
        return getArrowPath(
          arrowSize,
          point1.offset,
          point2.offset,
          scale,
          2,
        );
      case ArrowType.circle:
        return getCirclePath(
          arrowSize,
          point1.offset,
          point2.offset,
          scale,
          false,
        );
      case ArrowType.centerCircle:
        return getCirclePath(
          arrowSize,
          point1.offset,
          point2.offset,
          scale,
          true,
        );
      case ArrowType.semiCircle:
        return getSemiCirclePath(
          arrowSize,
          point1.offset,
          point2.offset,
          scale,
        );
    }
  }

  Path getLinePath(Offset point1, Offset point2, double scale) {
    switch (lineType) {
      case LineType.solid:
        return getSolidLinePath(point1, point2);
      case LineType.dashed:
        return getDashedLinePath(point1, point2, scale, 16, 16);
      case LineType.dotted:
        return getDashedLinePath(
            point1, point2, scale, lineWidth, lineWidth * 5);
    }
  }

  Path getArrowPath(double arrowSize, Offset point1, Offset point2,
      double scale, double pointed) {
    Offset left = point2 +
        VectorUtils.normalizeVector(
                VectorUtils.getPerpendicularVector(point1, point2)) *
            arrowSize *
            scale -
        VectorUtils.normalizeVector(
                VectorUtils.getDirectionVector(point1, point2)) *
            pointed *
            arrowSize *
            scale;
    Offset right = point2 -
        VectorUtils.normalizeVector(
                VectorUtils.getPerpendicularVector(point1, point2)) *
            arrowSize *
            scale -
        VectorUtils.normalizeVector(
                VectorUtils.getDirectionVector(point1, point2)) *
            pointed *
            arrowSize *
            scale;

    Path path = new Path();

    path.moveTo(point2.dx, point2.dy);
    path.lineTo(left.dx, left.dy);
    path.lineTo(right.dx, right.dy);
    path.close();

    return path;
  }

  Path getCirclePath(double arrowSize, Offset point1, Offset point2,
      double scale, bool isCenter) {
    Path path = new Path();
    if (isCenter) {
      path.addOval(Rect.fromCircle(center: point2, radius: scale * arrowSize));
    } else {
      Offset circleCenter = point2 -
          VectorUtils.normalizeVector(
                  VectorUtils.getDirectionVector(point1, point2)) *
              arrowSize *
              scale;
      path.addOval(
          Rect.fromCircle(center: circleCenter, radius: scale * arrowSize));
    }
    return path;
  }

  Path getSemiCirclePath(
      double arrowSize, Offset point1, Offset point2, double scale) {
    Path path = new Path();
    Offset circleCenter = point2 -
        VectorUtils.normalizeVector(
                VectorUtils.getDirectionVector(point1, point2)) *
            arrowSize *
            scale;
    path.addArc(
      Rect.fromCircle(center: circleCenter, radius: scale * arrowSize),
      math.pi - math.atan2(point2.dx - point1.dx, point2.dy - point1.dy),
      -math.pi,
    );
    return path;
  }

  Path getSolidLinePath(Offset point1, Offset point2) {
    Path path = new Path();
    path.moveTo(point1.dx, point1.dy);
    path.lineTo(point2.dx, point2.dy);
    return path;
  }

  Path getDashedLinePath(
    Offset point1,
    Offset point2,
    double scale,
    double dashLength,
    double dashSpace,
  ) {
    Path path = new Path();

    Offset normalized = VectorUtils.normalizeVector(
        VectorUtils.getDirectionVector(point1, point2));
    double lineDistance = (point2 - point1).distance;
    Offset currentPoint = Offset(point1.dx, point1.dy);

    double dash = dashLength * scale;
    double space = dashSpace * scale;
    double currentDistance = 0;
    while (currentDistance < lineDistance) {
      path.moveTo(currentPoint.dx, currentPoint.dy);
      currentPoint = currentPoint + normalized * dash;

      if (currentDistance + dash > lineDistance) {
        path.lineTo(point2.dx, point2.dy);
      } else {
        path.lineTo(currentPoint.dx, currentPoint.dy);
      }
      currentPoint = currentPoint + normalized * space;

      currentDistance += dash + space;
    }

    path.moveTo(
      point2.dx - normalized.dx * lineWidth * scale,
      point2.dy - normalized.dy * lineWidth * scale,
    );
    path.lineTo(point2.dx, point2.dy);
    return path;
  }
}
