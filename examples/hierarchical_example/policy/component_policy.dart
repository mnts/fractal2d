import '/diagram_editor.dart';
import '/hierarchical_example/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyComponentPolicy implements ComponentPolicy, CustomPolicy {
  Offset lastFocalPoint;

  @override
  onComponentTap(String componentId) {
    hideComponentHighlight(selectedComponentId);
    model.hideAllLinkJoints();

    if (isReadyToAddParent) {
      model.setComponentParent(selectedComponentId, componentId);
      selectedComponentId = null;
      isReadyToAddParent = false;
    } else {
      bool connected = connectComponents(selectedComponentId, componentId);
      if (connected) {
        selectedComponentId = null;
      } else {
        selectedComponentId = componentId;
        highlightComponent(componentId);
      }
    }
  }

  @override
  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;
  }

  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;

    model.moveComponentWithChildren(componentId, positionDelta);

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
        lineWidth: 2,
        arrowType: ArrowType.arrow,
      ),
    );

    return true;
  }
}
