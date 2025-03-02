import 'package:fractal2d/lib.dart';
import 'package:fractals2d/models/policy.dart';
import 'package:flutter/gestures.dart';

/// Allows you to define the component behaviour on any gesture registered by the [Component].
mixin ComponentPolicy on BasePolicySet {
  onComponentTap(ComponentFractal componentId) {}

  onComponentTapDown(ComponentFractal component, TapDownDetails details) {}

  onComponentTapUp(ComponentFractal component, TapUpDetails details) {}

  onComponentTapCancel(ComponentFractal component) {}

  onComponentScaleStart(
      ComponentFractal component, ScaleStartDetails details) {}

  onComponentScaleUpdate(
      ComponentFractal component, ScaleUpdateDetails details) {}

  onComponentScaleEnd(ComponentFractal component, ScaleEndDetails details) {}

  onComponentLongPress(ComponentFractal component) {}

  onComponentLongPressStart(
      ComponentFractal component, LongPressStartDetails details) {}

  onComponentLongPressMoveUpdate(
      ComponentFractal component, LongPressMoveUpdateDetails details) {}

  onComponentLongPressEnd(
      ComponentFractal component, LongPressEndDetails details) {}

  onComponentLongPressUp(ComponentFractal component) {}

  onComponentPointerSignal(
      ComponentFractal component, PointerSignalEvent event) {}
}
