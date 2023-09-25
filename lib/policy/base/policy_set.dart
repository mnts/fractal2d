import 'package:fractals2d/mixins/canvas.dart';
import 'package:fractals2d/models/state.dart';

import '/diagram_editor.dart';
import 'package:fractals2d/models/policy.dart';
import 'index.dart';

/// Fundamental policy set. Your policy set should extend [PolicySet].
class PolicySet extends BasePolicySet
    with
        InitPolicy,
        CanvasPolicy,
        ComponentPolicy,
        ComponentDesignPolicy,
        LinkPolicy,
        LinkJointPolicy,
        LinkAttachmentPolicy,
        LinkWidgetsPolicy,
        CanvasWidgetsPolicy,
        ComponentWidgetsPolicy {
  PolicySet(super.model) {
    initializeDiagramEditor();
    /*
    if (!policy.state.isInitialized) {
      policy.initializeDiagramEditor();
      policy.state.isInitialized = true;
    }
    */
  }
}
