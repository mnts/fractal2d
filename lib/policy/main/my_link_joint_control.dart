import 'package:fractal2d/init.dart';

import '../base/link_joints_policy.dart';
import 'package:flutter/material.dart';

mixin MyLinkJointControlPolicy implements LinkJointPolicy, CustomStatePolicy {
  @override
  onLinkJointLongPress(int jointIndex, LinkFractal link) {
    model.removeLinkMiddlePoint(link, jointIndex);
    link.notifyListeners();

    hideLinkOption();
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

    hideLinkOption();
  }
}
