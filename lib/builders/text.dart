import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractals2d/models/component.dart';

extension ComponentFractalExt on ComponentFractal {
  Widget build(BuildContext ctx) => switch (data) {
        NodeFractal f => Center(
            child: IconButton(
              icon: f.ctrl.icon.widget,
              onPressed: () {
                //final app = ctx.read<AppFractal>();
                FractalLayoutState.active.go(f);
              },
            ),
          ),
        EventFractal f => Text(f.display),
        _ => Container(),
      };
}
