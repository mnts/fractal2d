import '/diagram_editor.dart';

mixin CustomPolicy implements PolicySet {
  String selectedComponentId;

  bool isReadyToAddParent = false;

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
