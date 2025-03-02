import 'package:fractal2d/lib.dart';
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
  onLinkTapUp(LinkFractal link, TapUpDetails details) {
    model.hideAllLinkJoints();
    link.showJoints();
  }

  var _segmentIndex;

  @override
  onLinkScaleStart(LinkFractal link, ScaleStartDetails details) {
    model.hideAllLinkJoints();
    link.showJoints();
    _segmentIndex =
        model.determineLinkSegmentIndex(link, details.localFocalPoint.f);
    if (_segmentIndex != null) {
      model.insertLinkMiddlePoint(
          link, details.localFocalPoint.f, _segmentIndex);
      link.notifyListeners();
    }
  }

  @override
  onLinkScaleUpdate(LinkFractal link, ScaleUpdateDetails details) {
    if (_segmentIndex != null) {
      model.setLinkMiddlePointPosition(
        link,
        details.localFocalPoint.f,
        _segmentIndex,
      );
      link.notifyListeners();
    }
  }

  @override
  onLinkLongPressStart(LinkFractal link, LongPressStartDetails details) {
    model.hideAllLinkJoints();
    link.showJoints();
    _segmentIndex = model.determineLinkSegmentIndex(
      link,
      details.localPosition.f,
    );
    if (_segmentIndex != null) {
      model.insertLinkMiddlePoint(
        link,
        details.localPosition.f,
        _segmentIndex,
      );
      link.notifyListeners();
    }
  }

  @override
  onLinkLongPressMoveUpdate(
      LinkFractal link, LongPressMoveUpdateDetails details) {
    if (_segmentIndex != null) {
      model.setLinkMiddlePointPosition(
        link,
        details.localPosition.f,
        _segmentIndex,
      );
      link.notifyListeners();
    }
  }
}
