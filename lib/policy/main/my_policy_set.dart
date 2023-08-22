import 'package:fractal2d/policy/defaults/canvas_control_policy.dart';
import '/diagram_editor.dart';
import '../base/policy_set.dart';

class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        MyComponentDesignPolicy,
        MyLinkControlPolicy,
        MyLinkJointControlPolicy,
        MyLinkWidgetsPolicy,
        MyLinkAttachmentPolicy,
        MyCanvasWidgetsPolicy,
        MyComponentWidgetsPolicy,
        //
        CanvasControlPolicy,
        //
        //RiverpodPolicy,
        CustomStatePolicy,
        CustomBehaviourPolicy {}
