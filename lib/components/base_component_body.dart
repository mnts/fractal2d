import 'package:fractal2d/builders/text.dart';
import 'package:fractals2d/models/component.dart';
import 'package:flutter/material.dart';

class BaseComponentBody extends StatelessWidget {
  final ComponentFractal component;
  final CustomPainter componentPainter;

  const BaseComponentBody({
    super.key,
    required this.component,
    required this.componentPainter,
  });

  @override
  Widget build(BuildContext context) {
    //final Mycomponent customData = component.data;

    return GestureDetector(
      child: CustomPaint(
        painter: componentPainter,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          child: component.build(context),
        ),
      ),
    );
  }
}
