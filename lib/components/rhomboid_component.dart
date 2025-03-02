import 'package:fractal_flutter/extensions/color.dart';
import 'package:fractals2d/models/component.dart';
import '/components/base_component_body.dart';
import 'package:flutter/material.dart';

class RhomboidBody extends StatelessWidget {
  final ComponentFractal component;

  const RhomboidBody({
    super.key,
    required this.component,
  });

  @override
  Widget build(BuildContext context) {
    return BaseComponentBody(
      component: component,
      componentPainter: RhomboidPainter(
        color: Colors.grey.shade200.withOpacity(0.5),
//component.color.toMaterial,
        borderColor: component.borderColor.toMaterial.withAlpha(64),
        borderWidth: 2,
      ),
    );
  }
}

class RhomboidPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  Size componentSize = const Size(0, 0);
  RhomboidPainter({
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
    path.moveTo(componentSize.width / 6, 0);
    path.lineTo(componentSize.width, 0);
    path.lineTo(5 * componentSize.width / 6, componentSize.height);
    path.lineTo(0, componentSize.height);
    path.close();
    return path;
  }
}
