import 'package:position_fractal/fractals/offset.dart';

import '../base/policy_set.dart';
import '/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin CustomStatePolicy implements PolicySet {
  bool isGridVisible = true;

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

  int? selectedComponentId;

  bool isMultipleSelectionOn = false;
  List<int> multipleSelected = [];

  Offset deleteLinkPos = Offset.zero;

  bool isReadyToConnect = false;

  int? selectedLinkId;
  var tapLinkPosition = OffsetF();

  hideAllHighlights() {
    model.hideAllLinkJoints();
    hideLinkOption();
    for (final component in model.components.values) {
      if (component.isHighlightVisible) {
        component.hideHighlight();
        model.updateComponent(component.id);
      }
    }
  }

  highlightComponent(int componentId) {
    model.getComponent(componentId).showHighlight();
    model.getComponent(componentId).updateComponent();
  }

  hideComponentHighlight(int componentId) {
    model.getComponent(componentId).hideHighlight();
    model.getComponent(componentId).updateComponent();
  }

  turnOnMultipleSelection() {
    isMultipleSelectionOn = true;
    isReadyToConnect = false;

    if (selectedComponentId != null) {
      addComponentToMultipleSelection(selectedComponentId!);
      selectedComponentId = null;
    }
  }

  turnOffMultipleSelection() {
    isMultipleSelectionOn = false;
    multipleSelected = [];
    hideAllHighlights();
  }

  addComponentToMultipleSelection(int componentId) {
    if (!multipleSelected.contains(componentId)) {
      multipleSelected.add(componentId);
    }
  }

  removeComponentFromMultipleSelection(int componentId) {
    multipleSelected.remove(componentId);
  }

  int duplicate(ComponentFractal componentData) {
    var cd = ComponentFractal(
      //type: componentData.type,
      size: componentData.size.value,
      data: componentData.data,
      position: OffsetF(
        componentData.position.x + 20,
        componentData.position.y + 20,
      ),
    );
    int id = model.components.add(cd);
    return id;
  }

  showLinkOption(int linkId, OffsetF position) {
    selectedLinkId = linkId;
    tapLinkPosition = position;
  }

  hideLinkOption() {
    selectedLinkId = null;
  }

  //grid

  double gridGap = 30;

// if the component is this pixels close to grid line than it snaps to it.
  double snapSize = 10;

  bool isSnappingEnabled = true;

  switchIsSnappingEnabled() {
    isSnappingEnabled = !isSnappingEnabled;
  }
}

mixin CustomBehaviourPolicy implements PolicySet, CustomStatePolicy {
  resetView() {
    state.resetCanvasView();
  }

  removeSelected() {
    multipleSelected.forEach((compId) {
      model.removeComponent(compId);
    });
    multipleSelected = [];
  }

  duplicateSelected() {
    List<int> duplicated = [];
    multipleSelected.forEach((componentId) {
      int newId = duplicate(model.getComponent(componentId));
      duplicated.add(newId);
    });
    hideAllHighlights();
    multipleSelected = [];
    duplicated.forEach((componentId) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
      model.moveComponentToTheFront(componentId);
    });
  }

  selectAll() {
    var components = model.components.keys;

    for (var componentId in components) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
    }
  }
}
