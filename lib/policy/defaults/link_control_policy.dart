import 'package:fractal2d/lib.dart';

import 'package:fractals2d/models/policy.dart';
import '/policy/base/link_policy.dart';
import 'package:flutter/material.dart';

/// Optimized implementation of [LinkPolicy].
///
/// Adding new joints and showing joints on link tap.
///
/// It uses [onLinkTapUp], [onLinkScaleStart], [onLinkScaleUpdate], [onLinkLongPressStart], [onLinkLongPressMoveUpdate].
/// Feel free to override other functions from [LinkPolicy] and add them to [PolicySet].
mixin LinkControlPolicy implements LinkPolicy {
  @override
  onLinkTapUp(int linkId, TapUpDetails details) {
    model.hideAllLinkJoints();
    model.showLinkJoints(linkId);
  }

  var _segmentIndex;

  @override
  onLinkScaleStart(int linkId, ScaleStartDetails details) {
    model.hideAllLinkJoints();
    model.showLinkJoints(linkId);
    _segmentIndex =
        model.determineLinkSegmentIndex(linkId, details.localFocalPoint.f);
    if (_segmentIndex != null) {
      model.insertLinkMiddlePoint(
          linkId, details.localFocalPoint.f, _segmentIndex);
      model.updateLink(linkId);
    }
  }

  @override
  onLinkScaleUpdate(int linkId, ScaleUpdateDetails details) {
    if (_segmentIndex != null) {
      model.setLinkMiddlePointPosition(
        linkId,
        details.localFocalPoint.f,
        _segmentIndex,
      );
      model.updateLink(linkId);
    }
  }

  @override
  onLinkLongPressStart(int linkId, LongPressStartDetails details) {
    model.hideAllLinkJoints();
    model.showLinkJoints(linkId);
    _segmentIndex = model.determineLinkSegmentIndex(
      linkId,
      details.localPosition.f,
    );
    if (_segmentIndex != null) {
      model.insertLinkMiddlePoint(
        linkId,
        details.localPosition.f,
        _segmentIndex,
      );
      model.updateLink(linkId);
    }
  }

  @override
  onLinkLongPressMoveUpdate(int linkId, LongPressMoveUpdateDetails details) {
    if (_segmentIndex != null) {
      model.setLinkMiddlePointPosition(
        linkId,
        details.localPosition.f,
        _segmentIndex,
      );
      model.updateLink(linkId);
    }
  }
}
