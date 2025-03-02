import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fractal2d/lib.dart';
import 'package:fractals2d/models/policy.dart';
import 'package:position_fractal/fractals/offset.dart';

import 'canvas_control_policy.dart';

/// Optimized implementation of [CanvasPolicy].
///
/// It enabled only pan of the canvas.
///
/// It uses [onCanvasScaleStart], [onCanvasScaleUpdate], [onCanvasScaleEnd].
/// Feel free to override other functions from [CanvasPolicy] and add them to [PolicySet].
mixin CanvasMovePolicy on BasePolicySet implements CanvasControlPolicy {
  AnimationController? _animationController;

  var _basePosition = OffsetF(0, 0);

  var _lastFocalPoint = OffsetF(0, 0);

  var transformPosition = Offset.zero;
  double transformScale = 1.0;

  bool canUpdateCanvasModel = false;

  getAnimationController() {
    return _animationController;
  }

  setAnimationController(AnimationController animationController) {
    _animationController = animationController;
  }

  disposeAnimationController() {
    _animationController?.dispose();
  }

  onCanvasScaleStart(ScaleStartDetails details) {
    _basePosition = state.position;

    _lastFocalPoint = details.focalPoint.f;
  }

  onCanvasScaleUpdate(ScaleUpdateDetails details) {
    if (canUpdateCanvasModel) {
      _animationController?.repeat();
      _updateCanvasModelWithLastValues();

      transformPosition += details.focalPoint - _lastFocalPoint.offset;

      _lastFocalPoint = details.focalPoint.f;

      _animationController?.reset();
    }
  }

  onCanvasScaleEnd(ScaleEndDetails details) {
    if (canUpdateCanvasModel) {
      _updateCanvasModelWithLastValues();
    }

    _animationController?.reset();

    transformPosition = Offset.zero;

    state.updateCanvas();
  }

  _updateCanvasModelWithLastValues() {
    state.setPosition(_basePosition + transformPosition.f);
    canUpdateCanvasModel = false;
  }

  onCanvasPointerSignal(PointerSignalEvent event) {}

  double keepScaleInBounds(double scale, double canvasScale) {
    return 1.0;
  }
}
