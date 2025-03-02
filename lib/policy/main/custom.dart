import 'package:position_fractal/fractals/offset.dart';

import '../base/policy_set.dart';
import '../../lib.dart';
import 'package:flutter/material.dart';

mixin CustomStatePolicy implements PolicySet {
  bool isGridVisible = false;

  List<String> bodies = [
    'text',
    'junction',
    'rect',
    'round_rect',
    'oval',
    'crystal',
    'rhomboid',
    'bean',
    'bean_left',
    'bean_right',
    'document',
    'hexagon_horizontal',
    'hexagon_vertical',
    'bend_left',
    'bend_right',
    'no_corner_rect',
  ];

  ComponentFractal? selectedComponent;

  bool isMultipleSelectionOn = false;
  List<ComponentFractal> multipleSelected = [];

  Offset deleteLinkPos = Offset.zero;

  bool isReadyToConnect = false;

  LinkFractal? selectedLink;
  var tapLinkPosition = OffsetF();

  hideAllHighlights() {
    model.hideAllLinkJoints();
    hideLinkOption();

    final l = model.list.whereType<ComponentFractal>();
    for (final component in l) {
      if (component.isHighlightVisible) {
        component.hideHighlight();
        component.notifyListeners();
      }
    }
  }

  highlightComponent(ComponentFractal component) {
    component.showHighlight();
    component.notifyListeners();
  }

  hideComponentHighlight(ComponentFractal component) {
    component.hideHighlight();
    component.updateComponent();
  }

  turnOnMultipleSelection() {
    isMultipleSelectionOn = true;
    isReadyToConnect = false;

    if (selectedComponent != null) {
      addComponentToMultipleSelection(selectedComponent!);
      selectedComponent = null;
    }
  }

  turnOffMultipleSelection() {
    isMultipleSelectionOn = false;
    multipleSelected = [];
    hideAllHighlights();
  }

  addComponentToMultipleSelection(ComponentFractal component) {
    multipleSelected.add(component);
  }

  removeComponentFromMultipleSelection(int componentId) {
    multipleSelected.remove(componentId);
  }

  /*
  ComponentFractal duplicate(ComponentFractal componentData) {
    final c = ComponentFractal(
      //type: componentData.type,
      size: componentData.size.value,
      data: componentData.data?.value,
      position: OffsetF(
        componentData.position.x + 20,
        componentData.position.y + 20,
      ),
    );
    c.synch();
    return c;
  }
  */

  showLinkOption(LinkFractal link, OffsetF position) {
    selectedLink = link;
    tapLinkPosition = position;
  }

  hideLinkOption() {
    selectedLink = null;
  }

  //grid

  double gridGap = 20;

// if the component is this pixels close to grid line than it snaps to it.
  double snapSize = 10;

  bool isSnappingEnabled = false;

  switchIsSnappingEnabled() {
    isSnappingEnabled = !isSnappingEnabled;
  }
}

mixin CustomBehaviourPolicy implements PolicySet, CustomStatePolicy {
  resetView() {
    state.resetCanvasView();
  }

  removeSelected() {
    for (var comp in multipleSelected) {
      model.removeComponent(comp);
    }
    multipleSelected = [];
  }

  /*
  duplicateSelected() {
    List<ComponentFractal> duplicated = [];
    for (var component in multipleSelected) {
      final c = duplicate(component);
      duplicated.add(c);
    }
    hideAllHighlights();
    multipleSelected = [];
    for (var component in duplicated) {
      addComponentToMultipleSelection(component);
      highlightComponent(component);
      model.moveComponentToTheFront(component);
    }
  }
  */

  selectAll() {
    final l = model.list.whereType<ComponentFractal>();
    for (final component in l) {
      addComponentToMultipleSelection(component);
      highlightComponent(component);
    }
  }
}
