import 'package:fractal_flutter/extensions/color.dart';
import 'package:fractals2d/models/component.dart';
import '/components/base_component_body.dart';
import 'package:flutter/material.dart';

class NoCornerRectBody extends StatelessWidget {
  final ComponentFractal component;

  const NoCornerRectBody({
    super.key,
    @required required this.component,
  });

  @override
  Widget build(BuildContext context) {
    return BaseComponentBody(
      component: component,
      componentPainter: NoCornerRectPainter(
        color: component.color.toMaterial,
        borderColor: component.borderColor.toMaterial,
        borderWidth: component.borderWidth,
      ),
    );
  }
}

class NoCornerRectPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  Size componentSize = const Size(0, 0);
  NoCornerRectPainter({
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
    path.moveTo(componentSize.width / 8, 0);
    path.lineTo(7 * componentSize.width / 8, 0);
    path.lineTo(componentSize.width, componentSize.height / 8);
    path.lineTo(componentSize.width, 7 * componentSize.height / 8);
    path.lineTo(7 * componentSize.width / 8, componentSize.height);
    path.lineTo(componentSize.width / 8, componentSize.height);
    path.lineTo(0, 7 * componentSize.height / 8);
    path.lineTo(0, componentSize.height / 8);
    path.close();
    return path;
  }
}
