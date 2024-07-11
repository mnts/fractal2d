import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../policy/main/index.dart';
import 'policy.dart';

class DefaultCanvasArea extends StatefulWidget {
  final CanvasMix fractal;
  const DefaultCanvasArea({required this.fractal, super.key});

  @override
  State<DefaultCanvasArea> createState() => _DefaultCanvasAreaState();
}

class _DefaultCanvasAreaState extends State<DefaultCanvasArea> {
  late final policy = MyPolicySet(widget.fractal);
  @override
  void initState() {
    widget.fractal.preload('node');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Watch(
      widget.fractal,
      (ctx, child) => CanvasArea(
        policy: policy,
      ),
    );
  }
}
