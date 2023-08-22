import 'package:fractal2d/diagram_editor.dart';
import '../base/link_joints_policy.dart';
import 'package:flutter/material.dart';

mixin MyLinkJointControlPolicy implements LinkJointPolicy, CustomStatePolicy {
  @override
  onLinkJointLongPress(int jointIndex, int linkId) {
    model.removeLinkMiddlePoint(linkId, jointIndex);
    model.updateLink(linkId);

    hideLinkOption();
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

    hideLinkOption();
  }
}
