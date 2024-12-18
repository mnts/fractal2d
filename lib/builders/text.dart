import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/extensions/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractals2d/models/component.dart';
import 'package:provider/provider.dart';
import 'package:signed_fractal/models/event.dart';
import 'package:signed_fractal/models/index.dart';

extension ComponentFractalExt on ComponentFractal {
  Widget build(BuildContext ctx) => switch (data) {
        NodeFractal f => Center(
            child: IconButton(
              icon: f.ctrl.icon.widget,
              onPressed: () {
                final app = ctx.read<AppFractal>();
                FractalLayoutState.active.go(f);
              },
            ),
          ),
        EventFractal f => Text(f.display),
        _ => Container(),
      };
}
