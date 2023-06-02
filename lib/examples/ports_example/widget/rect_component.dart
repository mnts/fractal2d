import '/diagram_editor.dart';
import '/ports_example/widget/port_component.dart';
import 'package:flutter/material.dart';

class RectComponent extends StatelessWidget {
  final ComponentData componentData;

  const RectComponent({
    super.key,
    @required required this.componentData,
  });

  @override
  Widget build(BuildContext context) {
    final MyComponentData myCustomData = componentData.data;

    return Container(
      decoration: BoxDecoration(
        color: myCustomData.color,
        border: Border.all(
          width: 2.0,
          color: Colors.black,
        ),
      ),
    );
  }
}

class MyComponentData {
  final Color color;
  List<PortData> portData = [];

  MyComponentData({
    this.color = Colors.white,
  });
}
