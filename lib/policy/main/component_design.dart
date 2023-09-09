import '../base/component_design_policy.dart';
import '/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  final builders = <String, Widget Function(ComponentFractal)>{};
  @override
  Widget showComponentBody(ComponentFractal d) {
    if (d.data?.file == null) {
      return TextBody(component: d);
    }
    final builder = builders['text' ?? d.type];
    if (builder != null) return builder(d);
    return switch (d.type) {
      'text' => TextBody(component: d),
      'rect' => RectBody(component: d),
      'round_rect' => RoundRectBody(component: d),
      'oval' => OvalBody(component: d),
      'crystal' => CrystalBody(component: d),
      'body' => RectBody(component: d),
      'rhomboid' => RhomboidBody(component: d),
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
  }
}
