import 'package:fractal2d/lib.dart';
import 'package:fractals2d/models/policy.dart';
import 'package:flutter/gestures.dart';

/// Allows you to define the component behaviour on any gesture registered by the [Component].
mixin ComponentPolicy on BasePolicySet {
  onComponentTap(ComponentFractal componentId) {}

  onComponentTapDown(int componentId, TapDownDetails details) {}

  onComponentTapUp(int componentId, TapUpDetails details) {}

  onComponentTapCancel(int componentId) {}

  onComponentScaleStart(int componentId, ScaleStartDetails details) {}

  onComponentScaleUpdate(
      ComponentFractal component, ScaleUpdateDetails details) {}

  onComponentScaleEnd(int componentId, ScaleEndDetails details) {}

  onComponentLongPress(int componentId) {}

  onComponentLongPressStart(int componentId, LongPressStartDetails details) {}

  onComponentLongPressMoveUpdate(
      int componentId, LongPressMoveUpdateDetails details) {}

  onComponentLongPressEnd(int componentId, LongPressEndDetails details) {}

  onComponentLongPressUp(int componentId) {}

  onComponentPointerSignal(int componentId, PointerSignalEvent event) {}
}
