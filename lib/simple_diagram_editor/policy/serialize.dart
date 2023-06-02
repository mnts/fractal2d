// You can create your own Policy to define own variables and functions with canvasReader and canvasWriter.
import '../../diagram_editor.dart';
import '../data/custom_component_data.dart';

mixin CustomPolicy implements PolicySet {
  String? selectedComponentId;
  String serializedDiagram = '{"components": [], "links": []}';

  highlightComponent(String componentId) {
    canvasReader.model.getComponent(componentId).data.showHighlight();
    canvasReader.model.getComponent(componentId).updateComponent();
    selectedComponentId = componentId;
  }

  hideComponentHighlight(String? componentId) {
    if (componentId != null) {
      canvasReader.model.getComponent(componentId).data.hideHighlight();
      canvasReader.model.getComponent(componentId).updateComponent();
      selectedComponentId = null;
    }
  }

  deleteAllComponents() {
    selectedComponentId = null;
    canvasWriter.model.removeAllComponents();
  }

  // Save the diagram to String in json format.
  serialize() {
    serializedDiagram = canvasReader.model.serializeDiagram();
  }

  // Load the diagram from json format. Do it cautiously, to prevent unstable state remove the previous diagram (id collision can happen).
  deserialize() {
    canvasWriter.model.removeAllComponents();
    canvasWriter.model.deserializeDiagram(
      serializedDiagram,
      //decodeCustomComponentData: (json) => MyComponentData.fromJson(json),
      decodeCustomLinkData: null,
    );
  }
}
