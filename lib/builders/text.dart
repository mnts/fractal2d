import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/extensions/index.dart';
import 'package:fractals2d/models/component.dart';
import 'package:provider/provider.dart';
import 'package:signed_fractal/models/event.dart';

extension ComponentFractalExt on ComponentFractal {
  Widget build(BuildContext ctx) => switch (data) {
        ScreenFractal f => Center(
            child: IconButton(
              icon: f.ctrl.icon.widget,
              onPressed: () {
                final app = ctx.read<AppFractal>();
                app.go(f);
              },
            ),
          ),
        EventFractal() => Text(data?.content ?? ''),
        null => Container(),
      };
}
