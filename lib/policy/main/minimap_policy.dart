import 'package:color/color.dart';
import 'package:fractal2d/policy/defaults/canvas_control_policy.dart';
import 'package:position_fractal/fractals/offset.dart';

import '../base/init_policy.dart';
import '../../lib.dart';
import '../base/policy_set.dart';

class MiniMapPolicySet extends PolicySet
    with MiniMapInitPolicy, CanvasControlPolicy, MyComponentDesignPolicy {
  MiniMapPolicySet({required super.model});
}

mixin MiniMapInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    state.minScale = (0.025);
    state.maxScale = (0.25);
    state.setScale(0.1);
    state.color = (Color.rgb(25, 25, 25));
    state.setPosition(OffsetF(80, 60));
  }
}
