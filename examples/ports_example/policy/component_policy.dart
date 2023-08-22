import '/diagram_editor.dart';
import '/ports_example/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyComponentPolicy implements ComponentPolicy, CustomPolicy {
  Offset lastFocalPoint;

  @override
  onComponentTap(String componentId) {
    model.hideAllLinkJoints();

    var component = model.getComponent(componentId);

    if (component.type == 'port') {
      bool connected = connectComponents(selectedPortId, componentId);
      deselectAllPorts();
      if (!connected) {
        selectPort(componentId);
      }
    }
  }

  @override
  onComponentLongPress(String componentId) {
    var component = model.getComponent(componentId);
    if (component.type == 'component') {
      model.hideAllLinkJoints();
      model.removeComponentWithChildren(componentId);
    }
  }

  @override
  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;
  }

  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;

    var component = model.getComponent(componentId);

    if (component.type == 'component') {
      model.moveComponentWithChildren(componentId, positionDelta);
    } else if (component.type == 'port') {
      model.moveComponentWithChildren(component.parentId, positionDelta);
    }

    lastFocalPoint = details.localFocalPoint;
  }

  bool connectComponents(String sourceComponentId, String targetComponentId) {
    if (!canConnectThesePorts(sourceComponentId, targetComponentId)) {
      return false;
    }

    model.connectTwoComponents(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
      ),
    );

    return true;
  }
}
