import 'package:fractals2d/models/policy.dart';
import 'package:flutter/gestures.dart';

/// Allows you to define the link behaviour on any gesture registered by the [Link].
mixin LinkPolicy on BasePolicySet {
  onLinkTap(int linkId) {}

  onLinkTapDown(int linkId, TapDownDetails details) {}

  onLinkTapUp(int linkId, TapUpDetails details) {}

  onLinkTapCancel(int linkId) {}

  onLinkScaleStart(int linkId, ScaleStartDetails details) {}

  onLinkScaleUpdate(int linkId, ScaleUpdateDetails details) {}

  onLinkScaleEnd(int linkId, ScaleEndDetails details) {}

  onLinkLongPress(int linkId) {}

  onLinkLongPressStart(int linkId, LongPressStartDetails details) {}

  onLinkLongPressMoveUpdate(int linkId, LongPressMoveUpdateDetails details) {}

  onLinkLongPressEnd(int linkId, LongPressEndDetails details) {}

  onLinkLongPressUp(int linkId) {}

  onLinkPointerSignal(int linkId, PointerSignalEvent event) {}
}
