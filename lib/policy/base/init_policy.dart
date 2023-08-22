import 'package:fractals2d/models/policy.dart';

/// Allows you to prepare canvas before anything.
mixin InitPolicy on BasePolicySet {
  /// Allows you to prepare diagram editor before anything.
  ///
  /// It's possible to change canvas state here. Or load a diagram.
  initializeDiagramEditor() {
    //final CanvasState canvasState = CanvasState();
  }
}
