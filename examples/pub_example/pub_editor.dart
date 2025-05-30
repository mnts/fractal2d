import 'dart:math' as math;

import '/diagram_editor.dart';
import 'package:flutter/material.dart';

void main() => runApp(PubDiagramEditor());

class PubDiagramEditor extends StatefulWidget {
  @override
  _PubDiagramEditorState createState() => _PubDiagramEditorState();
}

class _PubDiagramEditorState extends State<PubDiagramEditor> {
  MyPolicySet myPolicySet = MyPolicySet();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Padding(
                padding: EdgeInsets.all(16),
                child: DiagramEditor(
                  diagramEditorContext: DiagramEditorContext(
                    policySet: myPolicySet,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => myPolicySet.deleteAllComponents(),
                child: Container(
                  width: 80,
                  height: 32,
                  color: Colors.red,
                  child: Center(child: Text('delete all')),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      SizedBox(width: 8),
                      Text('BACK TO MENU'),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom component Data which you can assign to a component to data property.
class MyComponentFractal {
  bool isHighlightVisible = false;
  Color color =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }
}

// A set of policies compound of mixins. There are some custom policy implementations and some policies defined by diagram_editor library.
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
        LinkJointControlPolicy,
        LinkAttachmentRectPolicy {}

// A place where you can init the canvas or your diagram (eg. load an existing diagram).
mixin MyInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    state.setCanvasColor(Colors.grey[300]);
  }
}

// This is the place where you can design a component.
// Use switch on componentData.type or componentData.data to define different component designs.
mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override
  Widget showComponentBody(ComponentFractal componentData) {
    return Container(
      decoration: BoxDecoration(
        color: (componentData.data as MyComponentFractal).color,
        border: Border.all(
          width: 2,
          color: (componentData.data as MyComponentFractal).isHighlightVisible
              ? Colors.pink
              : Colors.black,
        ),
      ),
      child: Center(child: Text('component')),
    );
  }
}

// You can override the behavior of any gesture on canvas here.
// Note that it also implements CustomPolicy where own variables and functions can be defined and used here.
mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  @override
  onCanvasTapUp(TapUpDetails details) {
    model.hideAllLinkJoints();
    if (selectedComponentId != null) {
      hideComponentHighlight(selectedComponentId);
    } else {
      model.addComponent(
        ComponentFractal(
          size: Size(96, 72),
          position: state.fromCanvasCoordinates(details.localPosition),
          data: MyComponentFractal(),
        ),
      );
    }
  }
}

// Mixin where component behaviour is defined. In this example it is the movement, highlight and connecting two components.
mixin MyComponentPolicy implements ComponentPolicy, CustomPolicy {
  // variable used to calculate delta offset to move the component.
  Offset lastFocalPoint;

  @override
  onComponentTap(String componentId) {
    model.hideAllLinkJoints();

    bool connected = connectComponents(selectedComponentId, componentId);
    hideComponentHighlight(selectedComponentId);
    if (!connected) {
      highlightComponent(componentId);
    }
  }

  @override
  onComponentLongPress(String componentId) {
    hideComponentHighlight(selectedComponentId);
    model.hideAllLinkJoints();
    model.removeComponent(componentId);
  }

  @override
  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;
  }

  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;
    model.moveComponent(componentId, positionDelta);
    lastFocalPoint = details.localFocalPoint;
  }

  // This function tests if it's possible to connect the components and if yes, connects them
  bool connectComponents(String sourceComponentId, String targetComponentId) {
    if (sourceComponentId == null || targetComponentId == null) {
      return false;
    }
    // tests if the ids are not same (the same component)
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    // tests if the connection between two components already exists (one way)
    if (model.getComponent(sourceComponentId).connections.any((connection) =>
        (connection is ConnectionOut) &&
        (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    // This connects two components (creates a link between), you can define the design of the link with LinkStyle.
    model.connectTwoComponents(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
        backArrowType: ArrowType.centerCircle,
      ),
    );

    return true;
  }
}

// You can create your own Policy to define own variables and functions with canvasReader and
mixin CustomPolicy implements PolicySet {
  String selectedComponentId;

  highlightComponent(String componentId) {
    model.getComponent(componentId).data.showHighlight();
    model.getComponent(componentId).updateComponent();
    selectedComponentId = componentId;
  }

  hideComponentHighlight(String componentId) {
    if (componentId != null) {
      model.getComponent(componentId).data.hideHighlight();
      model.getComponent(componentId).updateComponent();
      selectedComponentId = null;
    }
  }

  deleteAllComponents() {
    selectedComponentId = null;
    model.removeAllComponents();
  }
}
