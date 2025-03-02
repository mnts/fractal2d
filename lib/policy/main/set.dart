import 'package:flutter/material.dart';
import 'package:fractal2d/policy/defaults/canvas_control_policy.dart';
import '../../lib.dart';
import '../base/policy_set.dart';

class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        MyComponentDesignPolicy,
        MyLinkControlPolicy,
        MyLinkJointControlPolicy,
        MyLinkWidgetsPolicy,
        MyLinkAttachmentPolicy,
        MyCanvasWidgetsPolicy,
        MyComponentWidgetsPolicy,
        //
        CanvasControlPolicy,
        //
        //RiverpodPolicy,
        CustomStatePolicy,
        CustomBehaviourPolicy {
  MyPolicySet({
    required super.model,
    TickerProvider? ticker,
  }) {
    if (ticker != null) {
      setAnimationController(
        AnimationController(
          duration: const Duration(seconds: 1),
          vsync: ticker,
        ),
      );
    }
  }
}
