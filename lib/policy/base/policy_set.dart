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
  PolicySet({required super.model}) {
    initializeDiagramEditor();

    /*
    if (!policy.state.isInitialized) {
      policy.initializeDiagramEditor();
      policy.state.isInitialized = true;
    }
    */
  }
}
