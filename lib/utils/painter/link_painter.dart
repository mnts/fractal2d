import 'package:fractal_flutter/extensions/color.dart';
import 'package:fractal2d/extensions/link_style.dart';
import 'package:fractal2d/extensions/position.dart';
import 'package:fractals2d/models/link_style.dart';
import 'package:position_fractal/fractals/offset.dart';

import '/utils/vector_utils.dart';
import 'package:flutter/material.dart';

class LinkPainter extends CustomPainter {
  final List<OffsetF> linkPoints;
  final double scale;
  final LinkStyle linkStyle;

  LinkPainter({
    required this.linkPoints,
    required this.scale,
    required this.linkStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = linkStyle.color.toMaterial
      ..strokeWidth = linkStyle.lineWidth * scale
      ..strokeJoin = StrokeJoin.bevel
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Path path = Path();
    /*
    for (int i = 0; i < linkPoints.length - 1; i++) {
      if (linkPoints.length == 2) {
        canvas.drawPath(
          linkStyle.getLinePath(
            VectorUtils.getShorterLineStart(
              linkPoints[i].offset,
              linkPoints[i + 1].offset,
              scale * linkStyle.getEndShortening(linkStyle.backArrowType),
            ),
            VectorUtils.getShorterLineEnd(
              linkPoints[i].offset,
              linkPoints[i + 1].offset,
              scale * linkStyle.getEndShortening(linkStyle.arrowType),
            ),
            scale,
          ),
          paint,
        );
      } else if (i == 0) {
        path.moveTo(linkPoints[i].dx, linkPoints[i].dy);
        /*
        canvas.drawPath(
          linkStyle.getLinePath(
            VectorUtils.getShorterLineStart(
              linkPoints[i].offset,
              linkPoints[i + 1].offset,
              scale * linkStyle.getEndShortening(linkStyle.backArrowType),
            ),
            linkPoints[i + 1].offset,
            scale,
          ),
          paint,
        );
        */
//      } else if (i == linkPoints.length - 2) {
      } else if (linkPoints.length < 3 && i == linkPoints.length - 2) {
        canvas.drawPath(
          linkStyle.getLinePath(
            linkPoints[i].offset,
            VectorUtils.getShorterLineEnd(
              linkPoints[i].offset,
              linkPoints[i + 1].offset,
              scale * linkStyle.getEndShortening(linkStyle.arrowType),
            ),
            scale,
          ),
          paint,
        );
      } else {
        /*
        canvas.drawPath(
            linkStyle.getLinePath(
              linkPoints[i].offset,
              linkPoints[i + 1].offset,
              scale,
            ),
            paint);
        */
      }
    }
    */

    //path.moveTo(linkPoints[0].dx, linkPoints[0].dy);

    final ctrlV = 0.2;
    var points = <OffsetF>[]..addAll(linkPoints);
    path.reset();
    points.insert(0, OffsetF(points.first.dx, points.first.dy));
    points.add(OffsetF(points.last.dx, points.last.dy));
    points.add(OffsetF(points.last.dx, points.last.dy));
    path.moveTo(points.first.dx, points.first.dy);

    double ax, ay, bx = 0, by = 0;
    for (int i = 1; i < points.length - 3; i++) {
      ax = points[i].dx + (points[i + 1].dx - points[i - 1].dx) * ctrlV * 2;
      ay = points[i].dy + (points[i + 1].dy - points[i - 1].dy) * ctrlV;
      bx = points[i + 1].dx - (points[i + 2].dx - points[i].dx) * ctrlV * 2;
      by = points[i + 1].dy - (points[i + 2].dy - points[i].dy) * ctrlV;
      path.cubicTo(ax, ay, bx, by, points[i + 1].dx, points[i + 1].dy);
    }
    canvas.drawPath(path, paint);

    //paint.color = Colors.blue.withOpacity(0.8); //linkStyle.color.toMaterial

    paint..style = PaintingStyle.fill;
    canvas.drawPath(
        linkStyle.getArrowTipPath(
          linkStyle.arrowType,
          linkStyle.arrowSize,
          //linkPoints[linkPoints.length - 2],
          OffsetF(bx, by),
          linkPoints[linkPoints.length - 1],
          scale,
        ),
        paint);

    canvas.drawPath(
        linkStyle.getArrowTipPath(
          linkStyle.backArrowType,
          linkStyle.backArrowSize,
          linkPoints[1],
          linkPoints[0],
          scale,
        ),
        paint);

    // DEBUG:
    // paint
    //   ..color = Colors.green
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = scale * 0.2;
    // canvas.drawPath(
    //     makeWiderLinePath(scale * (5 + linkStyle.lineWidth)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    Path path = makeWiderLinePath(scale * (5 + linkStyle.lineWidth));
    return path.contains(position);
  }

  Path makeWiderLinePath(double hitAreaWidth) {
    Path path = new Path();
    for (int i = 0; i < linkPoints.length - 1; i++) {
      var point1 = linkPoints[i];
      var point2 = linkPoints[i + 1];

      // if (i == 0)
      //   point1 = PainterUtils.getShorterLineStart(point1, point2, scale * 10);
      // if (i == linkPoints.length - 2)
      //   point2 = PainterUtils.getShorterLineEnd(point1, point2, scale * 10);

      path.addPath(
          VectorUtils.getRectAroundLine(
            point1.offset,
            point2.offset,
            hitAreaWidth,
          ),
          Offset(0, 0));
    }
    return path;
  }
}
