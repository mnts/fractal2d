import 'package:fractal_flutter/extensions/color.dart';
import 'package:fractals2d/models/component.dart';
import '/components/base_component_body.dart';
import 'package:flutter/material.dart';

class DocumentBody extends StatelessWidget {
  final ComponentFractal component;

  const DocumentBody({
    super.key,
    required this.component,
  });

  @override
  Widget build(BuildContext context) => BaseComponentBody(
        component: component,
        componentPainter: DocumentPainter(
          color: component.color.toMaterial,
          borderColor: component.borderColor.toMaterial,
          borderWidth: component.borderWidth,
        ),
      );
}

class DocumentPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  Size componentSize = const Size(0, 0);
  DocumentPainter({
    this.color = Colors.grey,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    componentSize = size;

    Path path = componentPath();

    canvas.drawPath(path, paint);

    if (borderWidth > 0) {
      paint
        ..style = PaintingStyle.stroke
        ..color = borderColor
        ..strokeWidth = borderWidth;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    Path path = componentPath();
    return path.contains(position);
  }

  Path componentPath() {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(componentSize.width, 0);
    path.lineTo(componentSize.width, 9 * componentSize.height / 10);
    path.quadraticBezierTo(
      3 * componentSize.width / 4,
      7 * componentSize.height / 10,
      componentSize.width / 2,
      9 * componentSize.height / 10,
    );

    path.quadraticBezierTo(
      componentSize.width / 4,
      11 * componentSize.height / 10,
      0,
      9 * componentSize.height / 10,
    );

    path.close();
    return path;
  }
}
