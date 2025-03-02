// You can create your own Policy to define own variables and functions with canvasReader and
import 'package:fractal2d/policy/base/policy_set.dart';

mixin CustomPolicy implements PolicySet {
  int? selectedComponentId;
  String serializedDiagram = '{"components": [], "links": []}';

  /*
  highlightComponent(int componentId) {
    model.getComponent(componentId).showHighlight();
    model.getComponent(componentId).updateComponent();
    selectedComponentId = componentId;
  }

  hideComponentHighlight(int? componentId) {
    if (componentId != null) {
      model.getComponent(componentId).hideHighlight();
      model.getComponent(componentId).updateComponent();
      selectedComponentId = null;
    }
  }
  */

  /*
  // Save the diagram to String in json format.
  serialize() {
    serializedDiagram = model.serializeDiagram();
  }

  // Load the diagram from json format. Do it cautiously, to prevent unstable state remove the previous diagram (id collision can happen).
  deserialize() {
    model.removeAllComponents();
    model.deserializeDiagram(
      serializedDiagram,
      //decodeCustomComponentFractal: (json) => MyComponentFractal.fromJson(json),
      decodeCustomLinkData: null,
    );
  }
  */
}
