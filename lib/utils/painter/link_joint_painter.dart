import 'package:flutter/material.dart';
import 'package:fractal2d/lib.dart';
import 'package:position_fractal/fractals/offset.dart';

class LinkJointPainter extends CustomPainter {
  final OffsetF location;
  final double radius;
  final double scale;
  final Color color;

  LinkJointPainter({
    required this.location,
    required this.radius,
    required this.scale,
    required this.color,
  }) : assert(radius > 0);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(location.offset, scale * radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    Path path = Path();
    path.addOval(Rect.fromCircle(
      center: location.offset,
      radius: scale * radius,
    ));

    return path.contains(position);
  }
}
