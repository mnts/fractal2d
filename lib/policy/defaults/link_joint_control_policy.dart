import 'package:fractal2d/diagram_editor.dart';

import '/extensions/model.dart';

import '/policy/base/link_joints_policy.dart';
import 'package:flutter/material.dart';

/// Optimized implementation of [LinkJointPolicy].
///
/// Moving and removing link joints.
///
/// It uses [onLinkJointLongPress], [onLinkJointScaleUpdate].
/// Feel free to override other functions from [LinkJointPolicy] and add them to [PolicySet].
mixin LinkJointControlPolicy implements LinkJointPolicy {
  @override
  onLinkJointLongPress(int jointIndex, int linkId) {
    model.removeLinkMiddlePoint(linkId, jointIndex);
    model.updateLink(linkId);
  }

  @override
  onLinkJointScaleUpdate(
      int jointIndex, int linkId, ScaleUpdateDetails details) {
    model.setLinkMiddlePointPosition(
      linkId,
      details.localFocalPoint.f,
      jointIndex,
    );
    model.updateLink(linkId);
  }
}
