import '/diagram_editor.dart';
import '/ports_example/policy/canvas_policy.dart';
import '/ports_example/policy/component_design_policy.dart';
import '/ports_example/policy/component_policy.dart';
import '/ports_example/policy/custom_policy.dart';
import '/ports_example/policy/init_policy.dart';

class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyComponentDesignPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        CustomPolicy,
        //
        CanvasControlPolicy,
        LinkControlPolicy,
        LinkJointControlPolicy {}
