import 'dart:math' as math;

import '/diagram_editor.dart';
import '/complex_example/components/rainbow.dart';
import '/complex_example/components/random.dart';
import 'package:flutter/material.dart';

class ComplexDiagramEditor extends StatefulWidget {
  @override
  _ComplexDiagramEditorState createState() => _ComplexDiagramEditorState();
}

class _ComplexDiagramEditorState extends State<ComplexDiagramEditor> {
  MyPolicySet myPolicySet = MyPolicySet();
  DiagramEditorContext diagramEditorContext;

  @override
  void initState() {
    diagramEditorContext = DiagramEditorContext(
      policySet: myPolicySet,
    );
    super.initState();
  }

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
                  diagramEditorContext: diagramEditorContext,
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

// Custom component Data

class MyComponentFractal {
  bool isHighlightVisible;
  Color color =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  MyComponentFractal({
    this.isHighlightVisible = false,
  });

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }
}

class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyComponentDesignPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        CustomPolicy,
        MyLinkAttachmentPolicy,
        //
        CanvasControlPolicy,
        LinkControlPolicy,
        LinkJointControlPolicy {}

mixin MyInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    state.setCanvasColor(Colors.grey[300]);
  }
}

mixin MyComponentDesignPolicy implements ComponentDesignPolicy, CustomPolicy {
  @override
  Widget showComponentBody(ComponentFractal componentData) {
    switch (componentData.type) {
      case 'rainbow':
        return ComplexRainbowComponent(componentData: componentData);
        break;
      case 'random':
        return RandomComponent(componentData: componentData);
        break;
      case 'flutter':
        return Container(
          color: componentData.data.isHighlightVisible
              ? Colors.transparent
              : Colors.limeAccent,
          child: componentData.data.isHighlightVisible
              ? FlutterLogo(style: FlutterLogoStyle.horizontal)
              : FlutterLogo(),
        );
        break;
      default:
        return SizedBox.shrink();
        break;
    }
  }
}

mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  @override
  onCanvasTapUp(TapUpDetails details) {
    hideComponentHighlight(selectedComponentId);
    selectedComponentId = null;
    model.hideAllLinkJoints();

    model.addComponent(
      ComponentFractal(
        size: Size(400, 300),
        position: state.fromCanvasCoordinates(details.localPosition),
        data: MyComponentFractal(),
        type: ['rainbow', 'random', 'flutter'][math.Random().nextInt(3)],
      ),
    );
  }
}

mixin MyComponentPolicy implements ComponentPolicy, CustomPolicy {
  Offset lastFocalPoint;

  @override
  onComponentTap(String componentId) {
    hideComponentHighlight(selectedComponentId);
    model.hideAllLinkJoints();

    bool connected = connectComponents(selectedComponentId, componentId);
    if (connected) {
      selectedComponentId = null;
    } else {
      selectedComponentId = componentId;
      highlightComponent(componentId);
    }
  }

  @override
  onComponentLongPress(String componentId) {
    hideComponentHighlight(selectedComponentId);
    selectedComponentId = null;
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

  bool connectComponents(String sourceComponentId, String targetComponentId) {
    if (sourceComponentId == null) {
      return false;
    }
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    // test if the connection between two components already exists (one way)
    if (model.getComponent(sourceComponentId).connections.any((connection) =>
        (connection is ConnectionOut) &&
        (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    model.connectTwoComponents(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: LinkStyle(
        arrowType: ArrowType.arrow,
        lineWidth: 8,
        backArrowType: ArrowType.centerCircle,
        color: Colors.green,
        arrowSize: 15,
        backArrowSize: 10,
        lineType: LineType.dashed,
      ),
    );

    return true;
  }
}

mixin CustomPolicy implements PolicySet {
  String selectedComponentId;

  highlightComponent(String componentId) {
    model.getComponent(componentId).data.showHighlight();
    model.getComponent(componentId).updateComponent();
  }

  hideComponentHighlight(String componentId) {
    if (selectedComponentId != null) {
      model.getComponent(componentId).data.hideHighlight();
      model.getComponent(componentId).updateComponent();
    }
  }

  deleteAllComponents() {
    selectedComponentId = null;
    model.removeAllComponents();
  }
}

mixin MyLinkAttachmentPolicy implements LinkAttachmentPolicy {
  @override
  Alignment getLinkEndpointAlignment(
    ComponentFractal componentData,
    Offset targetPoint,
  ) {
    Offset pointPosition = targetPoint -
        (componentData.position + componentData.size.center(Offset.zero));
    pointPosition = Offset(
      pointPosition.dx / componentData.size.width,
      pointPosition.dy / componentData.size.height,
    );

    switch (componentData.type) {
      case 'random':
        return Alignment.center;
        break;

      case 'flutter':
        return Alignment(-0.54, 0);
        break;

      default:
        Offset pointAlignment;
        if (pointPosition.dx.abs() >= pointPosition.dy.abs()) {
          pointAlignment = Offset(pointPosition.dx / pointPosition.dx.abs(),
              pointPosition.dy / pointPosition.dx.abs());
        } else {
          pointAlignment = Offset(pointPosition.dx / pointPosition.dy.abs(),
              pointPosition.dy / pointPosition.dy.abs());
        }
        return Alignment(pointAlignment.dx, pointAlignment.dy);
        break;
    }
  }
}
