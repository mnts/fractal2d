import 'package:fractals2d/models/policy.dart';
import 'package:flutter/material.dart';

import '../../lib.dart';

/// Allows you to define the link's joint behaviour on any gesture registered by the link's joint.
mixin LinkJointPolicy on BasePolicySet {
  onLinkJointTap(int jointIndex, LinkFractal link) {}

  onLinkJointTapDown(
      int jointIndex, LinkFractal link, TapDownDetails details) {}

  onLinkJointTapUp(int jointIndex, LinkFractal link, TapUpDetails details) {}

  onLinkJointTapCancel(int jointIndex, LinkFractal link) {}

  onLinkJointScaleStart(
      int jointIndex, LinkFractal link, ScaleStartDetails details) {}

  onLinkJointScaleUpdate(
      int jointIndex, LinkFractal link, ScaleUpdateDetails details) {}

  onLinkJointScaleEnd(
      int jointIndex, LinkFractal link, ScaleEndDetails details) {}

  onLinkJointLongPress(int jointIndex, LinkFractal link) {}

  onLinkJointLongPressStart(
      int jointIndex, LinkFractal link, LongPressStartDetails details) {}

  onLinkJointLongPressMoveUpdate(
      int jointIndex, LinkFractal link, LongPressMoveUpdateDetails details) {}

  onLinkJointLongPressEnd(
      int jointIndex, LinkFractal link, LongPressEndDetails details) {}

  onLinkJointLongPressUp(int jointIndex, LinkFractal link) {}
}
