import 'package:flutter/material.dart';
import 'package:position_fractal/fractals/index.dart';

import '../../lib.dart';
import '../base/canvas_widgets_policy.dart';
import 'custom.dart';

mixin ConstrainsPolicy implements CanvasWidgetsPolicy, CustomStatePolicy {
  Size constrains = const Size(1000, 1000);

  Widget showConstrains() => Positioned(
        top: state.position.dy + state.scale * 1,
        left: state.position.dx + state.scale * 1,
        child: Container(
          width: constrains.width * state.scale,
          height: constrains.height * state.scale,
          color: Colors.green.withAlpha(90),
        ),
      );

  Offset constrain(ComponentFractal component, Offset o) {
    if (o.dx < 0) {
      o = Offset(0, o.dy);
    }

    if (o.dy < 0) {
      o = Offset(o.dx, 0);
    }
    if ((o.dx + component.size.width) > constrains.width) {
      o = Offset(
        constrains.width - component.size.width,
        o.dy,
      );
    }

    if ((o.dy + component.size.height) > constrains.height) {
      o = Offset(
        o.dx,
        constrains.height - component.size.height,
      );
    }
    return o;
  }

  SizeF constrainSize(
    ComponentFractal c,
    SizeF s,
  ) {
    final o = c.position.value.offset;
    if (o.dx + s.width > constrains.width) {
      s = SizeF(
        constrains.width - o.dx,
        s.height,
      );
    }

    if (o.dy + s.height > constrains.height) {
      s = SizeF(
        s.width,
        constrains.height - o.dy,
      );
    }
    return s;
  }
}
