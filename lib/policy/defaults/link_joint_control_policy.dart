import '../../lib.dart';
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
  onLinkJointLongPress(int jointIndex, LinkFractal link) {
    model.removeLinkMiddlePoint(link, jointIndex);
    link.notifyListeners();
  }

  @override
  onLinkJointScaleUpdate(
      int jointIndex, LinkFractal link, ScaleUpdateDetails details) {
    model.setLinkMiddlePointPosition(
      link,
      details.localFocalPoint.f,
      jointIndex,
    );
    link.notifyListeners();
  }
}
