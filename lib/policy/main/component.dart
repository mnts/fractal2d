import 'package:fractal2d/lib.dart';
import 'package:fractal2d/policy/base/component_policy.dart';
import 'package:fractal2d/policy/main/constrains.dart';
import 'package:fractals2d/models/link_style.dart';
import 'package:position_fractal/fractals/offset.dart';
import 'package:flutter/material.dart';

enum Movement { topLeft, topRight, bottomLeft, bottomRight }

mixin MyComponentPolicy implements ComponentPolicy, CustomStatePolicy {
  @override
  onComponentTap(component) {
    final componentId = component.id;

    /*
    final url = component.link.value?.content ?? '';
    if (url.isEmpty) return;
    launchUrl(
      Uri.parse(url),
    );
    */

    if (isMultipleSelectionOn) {
      if (multipleSelected.contains(componentId)) {
        removeComponentFromMultipleSelection(componentId);
        hideComponentHighlight(component);
      } else {
        addComponentToMultipleSelection(component);
        highlightComponent(component);
      }
    } else {
      hideAllHighlights();

      if (isReadyToConnect &&
          selectedComponent != null &&
          selectedComponent != component) {
/*
    if (model.getComponent(sourceComponentId).connections.any((connection) =>
        (connection is ConnectionOut) &&
        (connection.otherComponentId == targetComponentId))) {
      return false;
    }
    */
        isReadyToConnect = false;
        final link = model.connectTwoComponents(
          selectedComponent!,
          component,
          const LinkStyle(
            arrowType: ArrowType.pointedArrow,
            lineWidth: 1.5,
            backArrowType: ArrowType.centerCircle,
          ),
        );
        if (link != null) {
          print('connected');
          selectedComponent = null;
        } else {
          print('not connected');
          selectedComponent = component;
          highlightComponent(component);
        }
      } else if (isReadyToConnect && selectedComponent == component) {
        hideAllHighlights();
      } else {
        selectedComponent = component;
        highlightComponent(component);
      }
    }
  }

  late Offset lastFocalPoint;

  @override
  onComponentScaleStart(ComponentFractal component, details) {
    lastFocalPoint = details.localFocalPoint;

    startFocalPosition = details.localFocalPoint.f;
    startComponentPosition = component.position.value;

    hideLinkOption();
    if (isMultipleSelectionOn) {
      addComponentToMultipleSelection(component);
      highlightComponent(component);
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

  late OffsetF startFocalPosition;
  late OffsetF startComponentPosition;
  Offset lastPositionChange = Offset.zero;
  Movement movement = Movement.topLeft;

  @override
  onComponentLongPress(ComponentFractal component) {
    //model.removeComponent(component);
  }

  @override
  onComponentScaleUpdate(ComponentFractal component, details) {
    final positionChange = details.localFocalPoint - startFocalPosition.offset;
    var newPosition =
        startComponentPosition.offset + (positionChange) / state.scale;

    if (this is ConstrainsPolicy) {
      newPosition =
          (this as ConstrainsPolicy).constrain(component, newPosition);
    }

    component.position.move(newPosition.f);
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

      component.position.move(
        OffsetF(
          finalPosX,
          finalPosY,
        ),
      );
    }
    lastPositionChange = positionChange;
  }

  @override
  onComponentScaleEnd(ComponentFractal component, ScaleEndDetails details) {
    /*
    final reposition = OffsetF(
      lastPositionChange.dx,
      lastPositionChange.dy,
    );
    */ //..store();

    lastPositionChange = Offset.zero;
  }
}
