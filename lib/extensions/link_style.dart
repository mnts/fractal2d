import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fractal2d/init.dart';
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
        return getArrowPath(arrowSize, point1.offset, point2.offset, scale, 2);
      case ArrowType.pointedArrow:
        return getArrowPath(arrowSize, point1.offset, point2.offset, scale, 3);
      case ArrowType.circle:
        return getCirclePath(
            arrowSize, point1.offset, point2.offset, scale, false);
      case ArrowType.centerCircle:
        return getCirclePath(
            arrowSize, point1.offset, point2.offset, scale, true);
      case ArrowType.semiCircle:
        return getSemiCirclePath(
            arrowSize, point1.offset, point2.offset, scale);
      case ArrowType.square:
        return getSquarePath(arrowSize, point1.offset, point2.offset, scale);
      case ArrowType.diamond:
        return getDiamondPath(arrowSize, point1.offset, point2.offset, scale);
      case ArrowType.triangle:
        return getTrianglePath(arrowSize, point1.offset, point2.offset, scale);
      case ArrowType.star:
        return getStarPath(arrowSize, point1.offset, point2.offset, scale);
      case ArrowType.hexagon:
        return getPolygonPath(
            arrowSize, point1.offset, point2.offset, scale, 6);
      case ArrowType.pentagon:
        return getPolygonPath(
            arrowSize, point1.offset, point2.offset, scale, 5);
    }
  }

  // Existing getLinePath method remains unchanged
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

  // Existing getArrowPath remains unchanged
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

    Path path = Path();
    path.moveTo(point2.dx, point2.dy);
    path.lineTo(left.dx, left.dy);
    path.lineTo(right.dx, right.dy);
    path.close();
    return path;
  }

  // Existing getCirclePath remains unchanged
  Path getCirclePath(double arrowSize, Offset point1, Offset point2,
      double scale, bool isCenter) {
    Path path = Path();
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

  // Existing getSemiCirclePath remains unchanged
  Path getSemiCirclePath(
      double arrowSize, Offset point1, Offset point2, double scale) {
    Path path = Path();
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

  Path getSquarePath(
      double arrowSize, Offset point1, Offset point2, double scale) {
    Path path = Path();
    Offset center = point2 -
        VectorUtils.normalizeVector(
                VectorUtils.getDirectionVector(point1, point2)) *
            arrowSize *
            scale;
    double size = arrowSize * scale;
    double angle = math.atan2(point2.dy - point1.dy, point2.dx - point1.dx);

    path.addPolygon([
      _rotatePoint(center, Offset(center.dx - size, center.dy - size), angle),
      _rotatePoint(center, Offset(center.dx + size, center.dy - size), angle),
      _rotatePoint(center, Offset(center.dx + size, center.dy + size), angle),
      _rotatePoint(center, Offset(center.dx - size, center.dy + size), angle),
    ], true);
    return path;
  }

  Path getDiamondPath(
      double arrowSize, Offset point1, Offset point2, double scale) {
    Path path = Path();
    Offset center = point2 -
        VectorUtils.normalizeVector(
                VectorUtils.getDirectionVector(point1, point2)) *
            arrowSize *
            scale;
    double size = arrowSize * scale;
    double angle = math.atan2(point2.dy - point1.dy, point2.dx - point1.dx);

    path.addPolygon([
      _rotatePoint(center, Offset(center.dx, center.dy - size), angle),
      _rotatePoint(center, Offset(center.dx + size, center.dy), angle),
      _rotatePoint(center, Offset(center.dx, center.dy + size), angle),
      _rotatePoint(center, Offset(center.dx - size, center.dy), angle),
    ], true);
    return path;
  }

  Path getTrianglePath(
      double arrowSize, Offset point1, Offset point2, double scale) {
    Path path = Path();
    Offset baseCenter = point2 -
        VectorUtils.normalizeVector(
                VectorUtils.getDirectionVector(point1, point2)) *
            arrowSize *
            scale;
    double size = arrowSize * scale;
    Offset perpendicular = VectorUtils.normalizeVector(
        VectorUtils.getPerpendicularVector(point1, point2));

    path.moveTo(point2.dx, point2.dy);
    path.lineTo((baseCenter + perpendicular * size).dx,
        (baseCenter + perpendicular * size).dy);
    path.lineTo((baseCenter - perpendicular * size).dx,
        (baseCenter - perpendicular * size).dy);
    path.close();
    return path;
  }

  Path getStarPath(
      double arrowSize, Offset point1, Offset point2, double scale) {
    Path path = Path();
    Offset center = point2 -
        VectorUtils.normalizeVector(
                VectorUtils.getDirectionVector(point1, point2)) *
            arrowSize *
            scale;
    double outerRadius = arrowSize * scale;
    double innerRadius = outerRadius * 0.5;
    double angle = math.atan2(point2.dy - point1.dy, point2.dx - point1.dx);
    List<Offset> points = [];

    for (int i = 0; i < 10; i++) {
      double radius = i % 2 == 0 ? outerRadius : innerRadius;
      double pointAngle = angle + (i * math.pi / 5);
      points.add(Offset(
        center.dx + radius * math.cos(pointAngle),
        center.dy + radius * math.sin(pointAngle),
      ));
    }

    path.addPolygon(points, true);
    return path;
  }

  Path getPolygonPath(
      double arrowSize, Offset point1, Offset point2, double scale, int sides) {
    Path path = Path();
    Offset center = point2 -
        VectorUtils.normalizeVector(
                VectorUtils.getDirectionVector(point1, point2)) *
            arrowSize *
            scale;
    double radius = arrowSize * scale;
    double angle = math.atan2(point2.dy - point1.dy, point2.dx - point1.dx);
    List<Offset> points = [];

    for (int i = 0; i < sides; i++) {
      double pointAngle = angle + (i * 2 * math.pi / sides);
      points.add(Offset(
        center.dx + radius * math.cos(pointAngle),
        center.dy + radius * math.sin(pointAngle),
      ));
    }

    path.addPolygon(points, true);
    return path;
  }

  Offset _rotatePoint(Offset center, Offset point, double angle) {
    final double cosA = math.cos(angle);
    final double sinA = math.sin(angle);
    final double dx = point.dx - center.dx;
    final double dy = point.dy - center.dy;
    return Offset(
      center.dx + (dx * cosA - dy * sinA),
      center.dy + (dx * sinA + dy * cosA),
    );
  }

  // Existing getSolidLinePath and getDashedLinePath remain unchanged
  Path getSolidLinePath(Offset point1, Offset point2) {
    Path path = Path();
    path.moveTo(point1.dx, point1.dy);
    path.lineTo(point2.dx, point2.dy);
    return path;
  }

  Path getDashedLinePath(Offset point1, Offset point2, double scale,
      double dashLength, double dashSpace) {
    Path path = Path();
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

    path.moveTo(point2.dx - normalized.dx * lineWidth * scale,
        point2.dy - normalized.dy * lineWidth * scale);
    path.lineTo(point2.dx, point2.dy);
    return path;
  }
}
