import 'package:app_fractal/app.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:signed_fractal/signed_fractal.dart';

import '../base/component_design_policy.dart';
import '/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  final builders = <String, Widget Function(ComponentFractal)>{};
  @override
  Widget showComponentBody(ComponentFractal d) {
    final builder = builders['text' ?? d.type];
    if (builder != null) return builder(d);
    return FRL(d.data, (data) {
      data.preload('node');
      return switch (data) {
        'text' => TextBody(component: d),
        'rect' => RectBody(component: d),
        'round_rect' => RoundRectBody(component: d),
        'oval' => OvalBody(component: d),
        //CanvasFractal c => CrystalBody(component: d),
        'body' => RectBody(component: d),
        //CanvasFractal c => Text('canvas'),
        CanvasMix c => RhomboidBody(component: d),
        AppFractal c => RhomboidBody(component: d),
        'bean' => BeanBody(component: d),
        'bean_left' => BeanLeftBody(component: d),
        'bean_right' => BeanRightBody(component: d),
        'document' => DocumentBody(component: d),
        'hexagon_horizontal' => HexagonHorizontalBody(component: d),
        'hexagon_vertical' => HexagonVerticalBody(component: d),
        'bend_left' => BendLeftBody(component: d),
        'bend_right' => BendRightBody(component: d),
        'no_corner_rect' => NoCornerRectBody(component: d),
        'junction' => OvalBody(component: d),
        _ => TextBody(component: d),
      };
    });
  }
}
