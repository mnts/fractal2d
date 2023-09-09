import 'package:fractal2d/lib.dart';
import '../base/link_policy.dart';
import '/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyLinkControlPolicy implements LinkPolicy, CustomStatePolicy {
  @override
  onLinkTapUp(int linkId, TapUpDetails details) {
    hideLinkOption();
    model.hideAllLinkJoints();
    model.showLinkJoints(linkId);

    showLinkOption(
        linkId,
        state.fromCanvasCoordinates(
          details.localPosition.f,
        ));
  }

  var segmentIndex;

  @override
  onLinkScaleStart(int linkId, ScaleStartDetails details) {
    hideLinkOption();
    model.hideAllLinkJoints();
    model.showLinkJoints(linkId);
    segmentIndex = model.determineLinkSegmentIndex(
      linkId,
      details.localFocalPoint.f,
    );
    if (segmentIndex != null) {
      model.insertLinkMiddlePoint(
        linkId,
        details.localFocalPoint.f,
        segmentIndex,
      );
      model.updateLink(linkId);
    }
  }

  @override
  onLinkScaleUpdate(int linkId, ScaleUpdateDetails details) {
    if (segmentIndex != null) {
      model.setLinkMiddlePointPosition(
          linkId, details.localFocalPoint.f, segmentIndex);
      model.updateLink(linkId);
    }
  }

  @override
  onLinkLongPressStart(int linkId, LongPressStartDetails details) {
    hideLinkOption();
    model.hideAllLinkJoints();
    model.showLinkJoints(linkId);
    segmentIndex =
        model.determineLinkSegmentIndex(linkId, details.localPosition.f);
    if (segmentIndex != null) {
      model.insertLinkMiddlePoint(
        linkId,
        details.localPosition.f,
        segmentIndex,
      );
      model.updateLink(linkId);
    }
  }

  @override
  onLinkLongPressMoveUpdate(int linkId, LongPressMoveUpdateDetails details) {
    if (segmentIndex != null) {
      model.setLinkMiddlePointPosition(
        linkId,
        details.localPosition.f,
        segmentIndex,
      );
      model.updateLink(linkId);
    }
  }
}
