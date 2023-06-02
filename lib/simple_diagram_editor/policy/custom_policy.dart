import '/diagram_editor.dart';
import '/simple_diagram_editor/data/custom_component_data.dart';
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

  String? selectedComponentId;

  bool isMultipleSelectionOn = false;
  List<String> multipleSelected = [];

  Offset deleteLinkPos = Offset.zero;

  bool isReadyToConnect = false;

  String? selectedLinkId;
  Offset tapLinkPosition = Offset.zero;

  hideAllHighlights() {
    canvasWriter.model.hideAllLinkJoints();
    hideLinkOption();
    canvasReader.model.getAllComponents().values.forEach((component) {
      if (component.data.isHighlightVisible) {
        component.data.hideHighlight();
        canvasWriter.model.updateComponent(component.id);
      }
    });
  }

  highlightComponent(String componentId) {
    canvasReader.model.getComponent(componentId).data.showHighlight();
    canvasReader.model.getComponent(componentId).updateComponent();
  }

  hideComponentHighlight(String componentId) {
    canvasReader.model.getComponent(componentId).data.hideHighlight();
    canvasReader.model.getComponent(componentId).updateComponent();
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

  addComponentToMultipleSelection(String componentId) {
    if (!multipleSelected.contains(componentId)) {
      multipleSelected.add(componentId);
    }
  }

  removeComponentFromMultipleSelection(String componentId) {
    multipleSelected.remove(componentId);
  }

  String duplicate(ComponentData componentData) {
    var cd = ComponentData(
      type: componentData.type,
      size: componentData.size,
      minSize: componentData.minSize,
      data: MyComponentData.copy(componentData.data),
      position: componentData.position + Offset(20, 20),
    );
    String id = canvasWriter.model.addComponent(cd);
    return id;
  }

  showLinkOption(String linkId, Offset position) {
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

  deleteAllComponents() {
    canvasWriter.model.removeAllComponents();
  }
}

mixin CustomBehaviourPolicy implements PolicySet, CustomStatePolicy {
  removeAll() {
    canvasWriter.model.removeAllComponents();
  }

  resetView() {
    canvasWriter.state.resetCanvasView();
  }

  removeSelected() {
    multipleSelected.forEach((compId) {
      canvasWriter.model.removeComponent(compId);
    });
    multipleSelected = [];
  }

  duplicateSelected() {
    List<String> duplicated = [];
    multipleSelected.forEach((componentId) {
      String newId = duplicate(canvasReader.model.getComponent(componentId));
      duplicated.add(newId);
    });
    hideAllHighlights();
    multipleSelected = [];
    duplicated.forEach((componentId) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
      canvasWriter.model.moveComponentToTheFront(componentId);
    });
  }

  selectAll() {
    var components = canvasReader.model.canvasModel.components.keys;

    components.forEach((componentId) {
      addComponentToMultipleSelection(componentId);
      highlightComponent(componentId);
    });
  }
}
