import '/diagram_editor.dart';
import '/components/base_component_body.dart';
import 'package:flutter/material.dart';

class RoundRectBody extends StatelessWidget {
  final ComponentData componentData;

  const RoundRectBody({
    super.key,
    @required required this.componentData,
  });

  @override
  Widget build(BuildContext context) {
    return BaseComponentBody(
      componentData: componentData,
      componentPainter: RoundRectPainter(
        color: componentData.data.color,
        borderColor: componentData.data.borderColor,
        borderWidth: componentData.data.borderWidth,
      ),
    );
  }
}

class RoundRectPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  Size componentSize = const Size(0, 0);
  RoundRectPainter({
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

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          0,
          componentSize.width,
          componentSize.height,
        ),
        Radius.circular(16),
      ),
    );

    return path;
  }
}
