import 'package:fractal2d/lib.dart';
import 'package:fractal2d/policy/base/component_policy.dart';
import 'package:fractals2d/models/link_style.dart';
import 'package:position_fractal/fractals/offset.dart';

import 'package:flutter/material.dart';

enum Movement { topLeft, topRight, bottomLeft, bottomRight }

mixin MyComponentPolicy implements ComponentPolicy, CustomStatePolicy {
  @override
  onComponentTap(int componentId) {
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

    startFocalPosition = details.localFocalPoint.f;
    startComponentPosition = model.getComponent(componentId).position.value;

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
        var cmp = model.getComponent(compId);
        model.moveComponent(compId, positionDelta);
        cmp.connections.forEach((connection) {
          if (connection is ConnectionOut &&
              multipleSelected.contains(connection.otherComponentId)) {
            model.moveAllLinkMiddlePoints(
                connection.connectionId, positionDelta);
          }
        });
      });
    } else {
      model.moveComponent(componentId, positionDelta);
    }
    lastFocalPoint = details.localFocalPoint;
  }
  */

  bool connectComponents(int sourceComponentId, int targetComponentId) {
    if (sourceComponentId == null) {
      return false;
    }
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    if (model.getComponent(sourceComponentId).connections.any((connection) =>
        (connection is ConnectionOut) &&
        (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    model.connectTwoComponents(
      sourceComponentId,
      targetComponentId,
      LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
        backArrowType: ArrowType.centerCircle,
      ),
      MyLinkData(),
    );

    return true;
  }

  late OffsetF startFocalPosition;
  late OffsetF startComponentPosition;
  Offset lastPositionChange = Offset.zero;
  Movement movement = Movement.topLeft;

  @override
  onComponentLongPress(int componentId) {
    model.removeComponent(componentId);
  }

  @override
  onComponentScaleUpdate(ComponentFractal component, details) {
    final positionChange = details.localFocalPoint - startFocalPosition.offset;

    final newPosition =
        startComponentPosition.offset + (positionChange) / state.scale;

    model.setComponentPosition(component, newPosition.f);
    if (isSnappingEnabled) {
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

      model.setComponentPosition(
        component,
        OffsetF(
          finalPosX,
          finalPosY,
        ),
      );
    }
    lastPositionChange = positionChange;
  }

  @override
  onComponentScaleEnd(int componentId, ScaleEndDetails details) {
    final reposition = OffsetF(
      lastPositionChange.dx,
      lastPositionChange.dy,
    ); //..store();

    lastPositionChange = Offset.zero;
  }
}
