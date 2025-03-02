import 'package:fractal2d/lib.dart';
import '../base/link_policy.dart';
import '../../lib.dart';
import 'package:flutter/material.dart';

mixin MyLinkControlPolicy implements LinkPolicy, CustomStatePolicy {
  @override
  onLinkTapUp(LinkFractal link, TapUpDetails details) {
    hideLinkOption();
    model.hideAllLinkJoints();
    link.showJoints();

    showLinkOption(
        link,
        state.fromCanvasCoordinates(
          details.localPosition.f,
        ));
  }

  var segmentIndex;

  @override
  onLinkScaleStart(LinkFractal link, ScaleStartDetails details) {
    hideLinkOption();
    model.hideAllLinkJoints();
    link.showJoints();
    segmentIndex = model.determineLinkSegmentIndex(
      link,
      details.localFocalPoint.f,
    );
    if (segmentIndex != null) {
      model.insertLinkMiddlePoint(
        link,
        details.localFocalPoint.f,
        segmentIndex,
      );
      link.notifyListeners();
    }
  }

  @override
  onLinkScaleUpdate(LinkFractal link, ScaleUpdateDetails details) {
    if (segmentIndex != null) {
      model.setLinkMiddlePointPosition(
          link, details.localFocalPoint.f, segmentIndex);
      (link.notifyListeners());
    }
  }

  @override
  onLinkLongPressStart(LinkFractal link, LongPressStartDetails details) {
    hideLinkOption();
    model.hideAllLinkJoints();
    link.showJoints();
    segmentIndex =
        model.determineLinkSegmentIndex(link, details.localPosition.f);
    if (segmentIndex != null) {
      model.insertLinkMiddlePoint(
        link,
        details.localPosition.f,
        segmentIndex,
      );
      link.notifyListeners();
    }
  }

  @override
  onLinkLongPressMoveUpdate(
    LinkFractal link,
    LongPressMoveUpdateDetails details,
  ) {
    if (segmentIndex != null) {
      model.setLinkMiddlePointPosition(
        link,
        details.localPosition.f,
        segmentIndex,
      );
      link.notifyListeners();
    }
  }
}
