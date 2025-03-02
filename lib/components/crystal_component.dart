import 'package:fractal_flutter/extensions/color.dart';
import 'package:fractals2d/models/component.dart';
import '/components/base_component_body.dart';
import 'package:flutter/material.dart';

class CrystalBody extends StatelessWidget {
  final ComponentFractal component;

  const CrystalBody({
    super.key,
    required this.component,
  });

  @override
  Widget build(BuildContext context) {
    return BaseComponentBody(
      component: component,
      componentPainter: CrystalPainter(
        color: Theme.of(context).hintColor,
        borderColor: component.borderColor.toMaterial,
        borderWidth: component.borderWidth,
      ),
    );
  }
}

class CrystalPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  Size componentSize = const Size(0, 0);
  CrystalPainter({
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
    path.moveTo(0, componentSize.height / 2);
    path.lineTo(componentSize.width / 2, 0);
    path.lineTo(componentSize.width, componentSize.height / 2);
    path.lineTo(componentSize.width / 2, componentSize.height);
    path.close();
    return path;
  }
}
