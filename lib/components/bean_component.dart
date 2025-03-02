import 'package:fractal_flutter/extensions/color.dart';
import 'package:fractals2d/models/component.dart';
import '/components/base_component_body.dart';
import 'package:flutter/material.dart';

class BeanBody extends StatelessWidget {
  final ComponentFractal component;

  const BeanBody({
    super.key,
    required this.component,
  });

  @override
  Widget build(BuildContext context) {
    return BaseComponentBody(
      component: component,
      componentPainter: BeanPainter(
        color: component.color.toMaterial,
        borderColor: component.borderColor.toMaterial,
        borderWidth: component.borderWidth,
      ),
    );
  }
}

class BeanPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  Size componentSize = const Size(0, 0);
  BeanPainter({
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
    path.moveTo(componentSize.width / 5, 0);
    path.lineTo(4 * componentSize.width / 5, 0);
    path.quadraticBezierTo(
      componentSize.width,
      componentSize.height / 6,
      componentSize.width,
      componentSize.height / 2,
    );
    path.quadraticBezierTo(
      componentSize.width,
      5 * componentSize.height / 6,
      4 * componentSize.width / 5,
      componentSize.height,
    );
    path.lineTo(componentSize.width / 5, componentSize.height);
    path.quadraticBezierTo(
      0,
      5 * componentSize.height / 6,
      0,
      componentSize.height / 2,
    );
    path.quadraticBezierTo(
      0,
      componentSize.height / 6,
      componentSize.width / 5,
      0,
    );
    path.close();
    return path;
  }
}
