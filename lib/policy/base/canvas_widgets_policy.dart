import 'package:fractals2d/models/policy.dart';
import 'package:flutter/material.dart';

/// Allows you to add any widget to the canvas.
mixin CanvasWidgetsPolicy on BasePolicySet {
  /// Allows you to add any widget to the canvas.
  ///
  /// The widgets will be displayed under all components and links.
  ///
  /// Recommendation: use Positioned as the root widget.
  List<Widget> showCustomWidgetsOnCanvasBackground(BuildContext context) {
    return [];
  }

  /// Allows you to add any widget to the canvas.
  ///
  /// The widgets will be displayed over all components and links.
  ///
  /// Recommendation: use Positioned as the root widget.
  List<Widget> showCustomWidgetsOnCanvasForeground(BuildContext context) {
    return [];
  }
}
