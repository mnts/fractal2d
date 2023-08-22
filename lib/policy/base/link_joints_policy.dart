import 'package:fractals2d/models/policy.dart';
import 'package:flutter/material.dart';

/// Allows you to define the link's joint behaviour on any gesture registered by the link's joint.
mixin LinkJointPolicy on BasePolicySet {
  onLinkJointTap(int jointIndex, int linkId) {}

  onLinkJointTapDown(int jointIndex, int linkId, TapDownDetails details) {}

  onLinkJointTapUp(int jointIndex, int linkId, TapUpDetails details) {}

  onLinkJointTapCancel(int jointIndex, int linkId) {}

  onLinkJointScaleStart(
      int jointIndex, int linkId, ScaleStartDetails details) {}

  onLinkJointScaleUpdate(
      int jointIndex, int linkId, ScaleUpdateDetails details) {}

  onLinkJointScaleEnd(int jointIndex, int linkId, ScaleEndDetails details) {}

  onLinkJointLongPress(int jointIndex, int linkId) {}

  onLinkJointLongPressStart(
      int jointIndex, int linkId, LongPressStartDetails details) {}

  onLinkJointLongPressMoveUpdate(
      int jointIndex, int linkId, LongPressMoveUpdateDetails details) {}

  onLinkJointLongPressEnd(
      int jointIndex, int linkId, LongPressEndDetails details) {}

  onLinkJointLongPressUp(int jointIndex, int linkId) {}
}
