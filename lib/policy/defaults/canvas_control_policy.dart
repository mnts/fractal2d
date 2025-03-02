import '../../lib.dart';
import 'package:fractals2d/models/policy.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Optimized implementation of [CanvasPolicy].
///
/// It enabled pan and zoom of the canvas.
///
/// It uses [onCanvasScaleStart], [onCanvasScaleUpdate], [onCanvasScaleEnd], [onCanvasPointerSignal].
/// Feel free to override other functions from [CanvasPolicy] and add them to [PolicySet].
mixin CanvasControlPolicy on BasePolicySet {
  AnimationController? _animationController;
  double _baseScale = 1.0;
  var _basePosition = Offset.zero;

  var _lastFocalPoint = Offset.zero;

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
    _baseScale = model.cState.scale;
    _basePosition = model.cState.position.offset;

    _lastFocalPoint = details.focalPoint;
  }

  onCanvasScaleUpdate(ScaleUpdateDetails details) {
    if (!canUpdateCanvasModel) return;
    //if (this is ConstrainsPolicy && state.scale <= state.minScale) return;
    _animationController?.repeat();
    //_updateCanvasModelWithLastValues();

    double previousScale = transformScale;

    //final pos = transformPosition + (details.focalPoint - _lastFocalPoint);
    //final nPos = _basePosition + pos;
    //transformPosition = pos;
    transformPosition += details.focalPoint - _lastFocalPoint;
    transformScale = keepScaleInBounds(details.scale, _baseScale);

    var focalPoint = (details.localFocalPoint - transformPosition);
    var focalPointScaled = focalPoint * (transformScale / previousScale);

    _lastFocalPoint = details.focalPoint;

    transformPosition += (focalPoint - focalPointScaled);

    //_animationController?.reset();
  }

  onCanvasScaleEnd(ScaleEndDetails details) {
    if (canUpdateCanvasModel) {
      _updateCanvasModelWithLastValues();
    }

    _animationController?.reset();

    transformPosition = Offset.zero;
    transformScale = 1.0;

    state.updateCanvas();
  }

  _updateCanvasModelWithLastValues() {
    state.setPosition(((_basePosition * transformScale) + transformPosition).f);
    state.setScale(transformScale * _baseScale);
    canUpdateCanvasModel = false;
  }

  onCanvasPointerSignal(PointerSignalEvent event) {
    //return;
    if (event is PointerScrollEvent) {
      double scaleChange = event.scrollDelta.dy < 0
          ? (1 / state.mouseScaleSpeed)
          : (state.mouseScaleSpeed);

      scaleChange = keepScaleInBounds(scaleChange, state.scale);

      if (scaleChange == 0.0) {
        return;
      }

      double previousScale = state.scale;

      state.updateScale(scaleChange);

      var focalPoint = (event.localPosition.f - state.position);
      var focalPointScaled = focalPoint * (state.scale / previousScale);

      state.updatePosition(focalPoint - focalPointScaled);

      state.updateCanvas();
      _animationController?.repeat();
    }
  }

  double keepScaleInBounds(double scale, double canvasScale) {
    double scaleResult = scale;
    if (scale * canvasScale <= state.minScale) {
      scaleResult = state.minScale / canvasScale;
    }
    if (scale * canvasScale >= state.maxScale) {
      scaleResult = state.maxScale / canvasScale;
    }
    return scaleResult;
  }
}
