import '/diagram_editor.dart';
import '/simple_diagram_editor/data/custom_link_data.dart';
import '/simple_diagram_editor/policy/custom_policy.dart';
import 'package:flutter/material.dart';

enum Movement { topLeft, topRight, bottomLeft, bottomRight }

mixin MyComponentPolicy implements ComponentPolicy, CustomStatePolicy {
  @override
  onComponentTap(String componentId) {
    if (isMultipleSelectionOn) {
      if (multipleSelected.contains(componentId)) {
        removeComponentFromMultipleSelection(componentId);
        hideComponentHighlight(componentId);
      } else {
        addComponentToMultipleSelection(componentId);
        highlightComponent(componentId);
      }
    } else {
      hideAllHighlights();

      if (isReadyToConnect && selectedComponentId != null) {
        isReadyToConnect = false;
        bool connected = connectComponents(selectedComponentId!, componentId);
        if (connected) {
          print('connected');
          selectedComponentId = null;
        } else {
          print('not connected');
          selectedComponentId = componentId;
          highlightComponent(componentId);
        }
      } else {
        selectedComponentId = componentId;
        highlightComponent(componentId);
      }
    }
  }

  late Offset lastFocalPoint;

  @override
  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;

    startFocalPosition = details.localFocalPoint;
    startComponentPosition =
        canvasReader.model.getComponent(componentId).position;

    hideLinkOption();
    if (isMultipleSelectionOn) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
    }
  }

  /*
  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;
    if (isMultipleSelectionOn) {
      multipleSelected.forEach((compId) {
        var cmp = canvasReader.model.getComponent(compId);
        canvasWriter.model.moveComponent(compId, positionDelta);
        cmp.connections.forEach((connection) {
          if (connection is ConnectionOut &&
              multipleSelected.contains(connection.otherComponentId)) {
            canvasWriter.model.moveAllLinkMiddlePoints(
                connection.connectionId, positionDelta);
          }
        });
      });
    } else {
      canvasWriter.model.moveComponent(componentId, positionDelta);
    }
    lastFocalPoint = details.localFocalPoint;
  }
  */

  bool connectComponents(String sourceComponentId, String targetComponentId) {
    if (sourceComponentId == null) {
      return false;
    }
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    if (canvasReader.model.getComponent(sourceComponentId).connections.any(
        (connection) =>
            (connection is ConnectionOut) &&
            (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    canvasWriter.model.connectTwoComponents(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
        backArrowType: ArrowType.centerCircle,
      ),
      data: MyLinkData(),
    );

    return true;
  }

  late Offset startFocalPosition;
  late Offset startComponentPosition;
  Offset lastPositionChange = Offset.zero;
  Movement movement = Movement.topLeft;

  @override
  onComponentLongPress(String componentId) {
    canvasWriter.model.removeComponent(componentId);
  }

  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionChange = details.localFocalPoint - startFocalPosition;

    Offset newPosition =
        startComponentPosition + (positionChange) / canvasReader.state.scale;

    canvasWriter.model.setComponentPosition(componentId, newPosition);
    if (isSnappingEnabled) {
      var component = canvasReader.model.getComponent(componentId);

      double finalPosX = newPosition.dx;
      double finalPosY = newPosition.dy;

      bool isCloser(double position, [double size = 0]) {
        if (size == 0) {
          return (position) % gridGap < snapSize;
        } else {
          return (position + size + snapSize) % gridGap < snapSize;
        }
      }

      Offset delta = lastPositionChange - positionChange;

      if (delta.dx > 0 && delta.dy > 0) {
        movement = Movement.topLeft;
      } else if (delta.dx < 0 && delta.dy > 0) {
        movement = Movement.topRight;
      } else if (delta.dx > 0 && delta.dy < 0) {
        movement = Movement.bottomLeft;
      } else if (delta.dx < 0 && delta.dy < 0) {
        movement = Movement.bottomRight;
      } else if (delta.dx == 0 && delta.dy > 0) {
        if (movement != Movement.topRight) {
          movement = Movement.topLeft;
        }
      } else if (delta.dx == 0 && delta.dy < 0) {
        if (movement != Movement.bottomRight) {
          movement = Movement.bottomLeft;
        }
      } else if (delta.dy == 0 && delta.dx > 0) {
        if (movement != Movement.bottomLeft) {
          movement = Movement.topLeft;
        }
      } else if (delta.dy == 0 && delta.dx < 0) {
        if (movement != Movement.bottomRight) {
          movement = Movement.topRight;
        }
      }

      switch (movement) {
        case Movement.topLeft:
          if (isCloser(newPosition.dx)) {
            finalPosX = newPosition.dx - newPosition.dx % gridGap;
          }
          if (isCloser(newPosition.dy)) {
            finalPosY = newPosition.dy - newPosition.dy % gridGap;
          }
          break;
        case Movement.topRight:
          if (isCloser(newPosition.dx, component.size.width)) {
            finalPosX = newPosition.dx +
                snapSize -
                (newPosition.dx + component.size.width + snapSize) % gridGap;
          }
          if (isCloser(newPosition.dy)) {
            finalPosY = newPosition.dy - newPosition.dy % gridGap;
          }
          break;
        case Movement.bottomLeft:
          if (isCloser(newPosition.dx)) {
            finalPosX = newPosition.dx - newPosition.dx % gridGap;
          }
          if (isCloser(newPosition.dy, component.size.height)) {
            finalPosY = newPosition.dy +
                snapSize -
                (newPosition.dy + component.size.height + snapSize) % gridGap;
          }
          break;
        case Movement.bottomRight:
          if (isCloser(newPosition.dx, component.size.width)) {
            finalPosX = newPosition.dx +
                snapSize -
                (newPosition.dx + component.size.width + snapSize) % gridGap;
          }
          if (isCloser(newPosition.dy, component.size.height)) {
            finalPosY = newPosition.dy +
                snapSize -
                (newPosition.dy + component.size.height + snapSize) % gridGap;
          }
          break;
      }

      canvasWriter.model.setComponentPosition(
          componentId,
          Offset(
            finalPosX,
            finalPosY,
          ));
    }
    lastPositionChange = positionChange;
  }

  @override
  onComponentScaleEnd(String componentId, ScaleEndDetails details) {
    lastPositionChange = Offset.zero;
  }
}
