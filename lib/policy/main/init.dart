import 'package:color/color.dart';
import 'package:fractal2d/policy/base/init_policy.dart';

mixin MyInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    state.color = (const Color.rgb(255, 255, 255));
  }
}
