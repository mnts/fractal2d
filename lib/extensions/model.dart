import 'package:fractal2d/extensions/component.dart';
import 'package:fractal2d/lib.dart';
import 'package:fractals2d/models/link_style.dart';
import 'package:fractals2d/models/canvas.dart';
import 'package:flutter/material.dart';
import 'package:position_fractal/fractals/offset.dart';
import '../policy/base/link_attachment_policy.dart';

extension CanvasModelWriter on CanvasMix {
  /*
  /// Loads a diagram from json string.
  ///
  /// !!! Beware of passing correct json string.
  /// The diagram may become unstable if any data are manipulated.
  /// Deleting existing diagram is recommended.
  deserializeDiagram(
    String json, {
    Function(Map<String, dynamic> json)? decodeCustomComponentFractal,
    Function(Map<String, dynamic> json)? decodeCustomLinkData,
  }) {
    final diagram = CanvasModel.fromJson(
      jsonDecode(json),
      decodeCustomComponentFractal: decodeCustomComponentFractal,
      decodeCustomLinkData: decodeCustomLinkData,
    );
    for (final componentData in diagram.components) {
      components[componentData.id] = componentData;
    }
    for (final linkData in diagram.links) {
      links[linkData.id] = linkData;
      linkData.updateLink();
    }
    updateCanvas();
  }
  */

  int? determineLinkSegmentIndex(
    int linkId,
    OffsetF tapPosition,
  ) {
    return getLink(linkId).determineLinkSegmentIndex(
      tapPosition,
      state.position.value,
      state.scale,
    );
  }

  updateLinks(ComponentFractal component) {
    for (final connection in component.connections) {
      var link = getLink(connection.connectionId);

      ComponentFractal sourceComponent = component;
      var targetComponent = getComponent(connection.otherComponentId);

      if (connection is ConnectionOut) {
        sourceComponent = component;
        targetComponent = getComponent(connection.otherComponentId);
      } else if (connection is ConnectionIn) {
        sourceComponent = getComponent(connection.otherComponentId);
        targetComponent = component;
      } else {
        throw ArgumentError('Invalid port connection.');
      }

      Alignment firstLinkAlignment = _getLinkEndpointAlignment(
        sourceComponent,
        targetComponent,
        link,
        1,
      );

      Alignment secondLinkAlignment = _getLinkEndpointAlignment(
        targetComponent,
        sourceComponent,
        link,
        link.linkPoints.length - 2,
      );

      _setLinkEndpoints(link, sourceComponent, targetComponent,
          firstLinkAlignment, secondLinkAlignment);
    }
  }

  Alignment _getLinkEndpointAlignment(
    ComponentFractal component1,
    ComponentFractal component2,
    LinkFractal link,
    int linkPointIndex,
  ) {
    return Alignment.center;
    /*
    if (this.policy is! LinkAttachmentPolicy) return Alignment.center;
    final policy = this.policy as LinkAttachmentPolicy;

    if (link.linkPoints.length <= 2) {
      return policy.getLinkEndpointAlignment(
        component1,
        component2.position.value +
            component2.size.value.center(
              OffsetF(),
            ),
      );
    } else {
      return policy.getLinkEndpointAlignment(
        component1,
        link.linkPoints[linkPointIndex],
      );
    }
    */
  }

  /// Creates a link between components. Returns created link's id.
  int connectTwoComponents(
    int sourceComponentId,
    int targetComponentId,
    LinkStyle? linkStyle,
    dynamic data,
  ) {
    return 0;
    /*
    if (this.policy is! LinkAttachmentPolicy) return 0;
    final policy = this.policy as LinkAttachmentPolicy;

    var linkId = ++LinkFractal.maxId;
    var sourceComponent = getComponent(sourceComponentId);
    var targetComponent = getComponent(targetComponentId);

    sourceComponent.addConnection(
      ConnectionOut(
        connectionId: linkId,
        otherComponentId: targetComponentId,
      ),
    );
    targetComponent.addConnection(
      ConnectionIn(
        connectionId: linkId,
        otherComponentId: sourceComponentId,
      ),
    );

    var sourceLinkAlignment = policy.getLinkEndpointAlignment(
      sourceComponent,
      targetComponent.position.value +
          targetComponent.size.value.center(OffsetF()),
    );
    var targetLinkAlignment = policy.getLinkEndpointAlignment(
      targetComponent,
      sourceComponent.position.value +
          sourceComponent.size.value.center(OffsetF()),
    );

    links[linkId] = LinkFractal(
      id: linkId,
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkPoints: [
        sourceComponent.position.value +
            sourceComponent.getPointOnComponent(
              sourceLinkAlignment,
            ),
        targetComponent.position.value +
            targetComponent.getPointOnComponent(
              targetLinkAlignment,
            ),
      ],
      data: data,
    );

    notifyListeners();
    return linkId;
    */
  }

  _setLinkEndpoints(
    LinkFractal link,
    ComponentFractal component1,
    ComponentFractal component2,
    Alignment alignment1,
    Alignment alignment2,
  ) {
    link.setEndpoints(
      component1.position.value +
          component1.getPointOnComponent(
            alignment1,
          ),
      component2.position.value +
          component2.getPointOnComponent(
            alignment2,
          ),
    );
  }

  /// Update a component with [componentId].
  ///
  /// It calls [notifyListeners] function of [ChangeNotifier] on [ComponentFractal].
  updateComponent(int componentId) {
    assert(componentExists(componentId),
        'model does not contain this component id: $componentId');
    getComponent(componentId).updateComponent();
  }

  /// Sets the position of the component to [position] value.
  setComponentPosition(ComponentFractal component, OffsetF position) {
    //assert(componentExists(componentId), 'model does not contain this component id: $componentId');
    //final comp = getComponent(componentId);
    component.position.move(position);
    updateLinks(component);
  }

  /// Translates the component by [offset] value.
  moveComponent(int componentId, OffsetF offset) {
    assert(
      componentExists(componentId),
      'model does not contain this component id: $componentId',
    );

    final comp = getComponent(componentId);
    comp.position.move(offset / state.scale);
    updateLinks(comp);
  }

  /*
  /// Translates the component by [offset] value and all its children as well.
  moveComponentWithChildren(int componentId, OffsetF offset) {
    assert(componentExists(componentId),
        'model does not contain this component id: $componentId');
    moveComponent(componentId, offset);
    getComponent(componentId).childrenIds.forEach((childId) {
      moveComponentWithChildren(childId, offset);
    });
  }
  */

  /// Removes all connections that the component with [componentId] has.
  removeComponentConnections(int componentId) {
    assert(componentExists(componentId),
        'model does not contain this component id: $componentId');
    removeComponentConnections(componentId);
  }

  /// Sets the components's z-order to the highest z-order value of all components +1 and sets z-order of its children to +2...
  int moveComponentToTheFrontWithChildren(int componentId) {
    assert(
      componentExists(componentId),
      'model does not contain this component id: $componentId',
    );
    int zOrder = moveComponentToTheFront(componentId);
    _setZOrderToChildren(componentId, zOrder);
    return zOrder;
  }

  _setZOrderToChildren(int componentId, int zOrder) {
    assert(componentExists(componentId),
        'model does not contain this component id: $componentId');
    setComponentZOrder(componentId, zOrder);
    getComponent(componentId).childrenIds.forEach((childId) {
      _setZOrderToChildren(childId, zOrder + 1);
    });
  }

  /// Sets the components's z-order to the lowest z-order value of all components -1 and sets z-order of its children to one more than the component and their children to one more..
  int moveComponentToTheBackWithChildren(int componentId) {
    assert(componentExists(componentId),
        'model does not contain this component id: $componentId');
    int zOrder = moveComponentToTheBack(componentId);
    _setZOrderToChildren(componentId, zOrder);
    return zOrder;
  }

  /// Changes the component's size by [deltaSize].
  ///
  /// You cannot change its size to smaller than [minSize] defined on the component.
  resizseComponent(int componentId, OffsetF deltaSize) {
    assert(componentExists(componentId),
        'model does not contain this component id: $componentId');
    getComponent(componentId).resizeDelta(deltaSize);
  }

  /// Sets the component's to [size].
  setcomponentSizse(int componentId, SizeF size) {
    assert(
      componentExists(componentId),
      'model does not contain this component id: $componentId',
    );
    //getComponent(componentId).setSize(size);
  }

  /// Sets the component's parent.
  ///
  /// It's not possible to make a parent-child loop. (its ancestor cannot be its child)
  setComponentParent(int componentId, int parentId) {
    assert(
      componentExists(componentId),
      'model does not contain this component id: $componentId',
    );
    removeComponentParent(componentId);
    if (_checkParentChildLoop(componentId, parentId)) {
      getComponent(componentId).setParent(parentId);
      getComponent(parentId).addChild(componentId);
    }
  }

  bool _checkParentChildLoop(int componentId, int parentId) {
    if (componentId == parentId) return false;
    final _parentIdOfParent = getComponent(parentId).parentId;
    if (_parentIdOfParent != null) {
      return _checkParentChildLoop(componentId, _parentIdOfParent);
    }

    return true;
  }

  /// Makes all link's joints visible.
  showLinkJoints(int linkId) {
    assert(linkExists(linkId), 'model does not contain this link id: $linkId');
    getLink(linkId).showJoints();
  }

  /// Makes all link's joints invisible.
  hideLinkJoints(int linkId) {
    assert(linkExists(linkId), 'model does not contain this link id: $linkId');
    getLink(linkId).hideJoints();
  }

  /// Makes invisible all link joints on the canvas.
  hideAllLinkJoints() {
    links.values.forEach((link) {
      link.hideJoints();
    });
  }

  /// Updates the link.
  ///
  /// Use it when something is changed and the link is not updated to its proper positions.
  updateLink(int linkId) {
    assert(linkExists(linkId), 'model does not contain this link id: $linkId');
    final link = getLink(linkId);
    updateLinks(getComponent(
      link.sourceComponentId,
    ));
    updateLinks(getComponent(
      link.targetComponentId,
    ));
  }

  /// Creates a new link's joint on [point] location.
  ///
  /// [index] is an index of link's segment where you want to insert the point.
  /// Indexed from 1.
  /// When the link is a straight line you want to add a point to index 1.
  insertLinkMiddlePoint(int linkId, OffsetF point, int index) {
    assert(
      linkExists(linkId),
      'model does not contain this link id: $linkId',
    );

    getLink(linkId).insertMiddlePoint(
      state.fromCanvasCoordinates(point),
      index,
    );
  }

  /// Sets the new position ([point]) to the existing link's joint point.
  ///
  /// Joints are indexed from 1.
  setLinkMiddlePointPosition(int linkId, OffsetF point, int index) {
    assert(linkExists(linkId), 'model does not contain this link id: $linkId');
    getLink(linkId).setMiddlePointPosition(
      state.fromCanvasCoordinates(point),
      index,
    );
  }

  /// Updates link's joint position by [offset].
  ///
  /// Joints are indexed from 1.
  moveLinkMiddlePoint(int linkId, OffsetF offset, int index) {
    assert(linkExists(linkId), 'model does not contain this link id: $linkId');

    getLink(linkId).moveMiddlePoint(
      offset / state.scale,
      index,
    );
  }

  /// Removes the joint on [index]th place from the link.
  ///
  /// Joints are indexed from 1.
  removeLinkMiddlePoint(int linkId, int index) {
    assert(linkExists(linkId), 'model does not contain this link id: $linkId');
    getLink(linkId).removeMiddlePoint(index);
  }

  /// Updates all link's joints position by [offset].
  moveAllLinkMiddlePoints(int linkId, OffsetF position) {
    assert(linkExists(linkId), 'model does not contain this link id: $linkId');
    getLink(linkId).moveAllMiddlePoints(position / state.scale);
  }
}

/*
extension ConnectionWriter on CanvasModel {
  /// Connects two components with a new link. The link is added to the model.
  ///
  /// The link points from [sourceComponentId] to [targetComponentId].
  /// Connection information is added to both components.
  ///
  /// Returns id of the created link.
  ///
  /// You can define the design of the link with [LinkStyle].
  /// You can add your own dynamic [data] to the link.
  String connectTwoComponents(
    String sourceComponentId,
    String targetComponentId,
    LinkStyle? linkStyle,
    dynamic data,
  ) {
    assert(componentExists(sourceComponentId));
    assert(componentExists(targetComponentId));
    return connectTwoComponents(
      sourceComponentId,
      targetComponentId,
      linkStyle,
      data,
    );
  }
}
*/