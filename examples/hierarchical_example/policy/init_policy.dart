import '/diagram_editor.dart';
import '/hierarchical_example/component_data.dart';
import 'package:flutter/material.dart';

mixin MyInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    state.setCanvasColor(Colors.grey[300]);

    var cd1 = getSmallComponentFractal(Offset(220, 100));
    var cd2 = getSmallComponentFractal(Offset(220, 180));
    var cd3 = getSmallComponentFractal(Offset(400, 100));
    var cd4 = getSmallComponentFractal(Offset(400, 180));

    var cd5 = getBigComponentFractal(Offset(80, 80));
    var cd6 = getBigComponentFractal(Offset(380, 80));

    model.addComponent(cd1);
    model.addComponent(cd2);
    model.addComponent(cd3);
    model.addComponent(cd4);
    model.addComponent(cd5);
    model.addComponent(cd6);

    model.moveComponentToTheFront(cd5.id);
    model.moveComponentToTheFront(cd6.id);

    model.moveComponentToTheFront(cd1.id);
    model.moveComponentToTheFront(cd2.id);
    model.moveComponentToTheFront(cd3.id);
    model.moveComponentToTheFront(cd4.id);

    model.setComponentParent(cd1.id, cd5.id);
    model.setComponentParent(cd2.id, cd5.id);

    model.setComponentParent(cd3.id, cd6.id);
    model.setComponentParent(cd4.id, cd6.id);

    model.connectTwoComponents(
      sourceComponentId: cd1.id,
      targetComponentId: cd3.id,
      linkStyle: LinkStyle(
        lineWidth: 2,
        arrowType: ArrowType.arrow,
      ),
    );
    model.connectTwoComponents(
      sourceComponentId: cd4.id,
      targetComponentId: cd2.id,
      linkStyle: LinkStyle(
        lineWidth: 2,
        arrowType: ArrowType.arrow,
      ),
    );
  }

  ComponentFractal getSmallComponentFractal(Offset position) {
    return ComponentFractal(
      size: Size(80, 64),
      minSize: Size(72, 48),
      position: position,
      data: MyComponentFractal(),
    );
  }

  ComponentFractal getBigComponentFractal(Offset position) {
    return ComponentFractal(
      size: Size(240, 180),
      minSize: Size(72, 48),
      position: position,
      data: MyComponentFractal(),
    );
  }
}
