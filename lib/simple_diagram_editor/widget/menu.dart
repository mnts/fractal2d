import '/diagram_editor.dart';
import '/simple_diagram_editor/data/custom_component_data.dart';
import '/simple_diagram_editor/policy/my_policy_set.dart';
import 'package:flutter/material.dart';

class DraggableMenu extends StatelessWidget {
  final MyPolicySet myPolicySet;

  const DraggableMenu({
    super.key,
    required this.myPolicySet,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...myPolicySet.bodies.map(
          (componentType) {
            var componentData = getComponentData(componentType);
            return Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth < componentData.size.width
                        ? componentData.size.width *
                            (constraints.maxWidth / componentData.size.width)
                        : componentData.size.width,
                    height: constraints.maxWidth < componentData.size.width
                        ? componentData.size.height *
                            (constraints.maxWidth / componentData.size.width)
                        : componentData.size.height,
                    child: Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: componentData.size.aspectRatio,
                        child: Tooltip(
                          message: componentData.type,
                          child: DraggableComponent(
                            myPolicySet: myPolicySet,
                            componentData: componentData,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ).toList(),
      ],
    );
  }

  ComponentData getComponentData(String componentType) {
    switch (componentType) {
      case 'junction':
        return ComponentData(
          size: Size(16, 16),
          minSize: Size(4, 4),
          data: MyComponentData(
            color: Colors.black,
            borderWidth: 0.0,
          ),
          type: componentType,
        );
      default:
        return ComponentData(
          size: Size(120, 72),
          data: MyComponentData(
            color: Colors.white,
            borderColor: Colors.black,
            borderWidth: 2.0,
          ),
          type: componentType,
        );
    }
  }
}

class DraggableComponent extends StatelessWidget {
  final MyPolicySet myPolicySet;
  final ComponentData componentData;
  final Widget? child;

  const DraggableComponent({
    super.key,
    this.child,
    required this.myPolicySet,
    required this.componentData,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<ComponentData>(
      affinity: Axis.horizontal,
      ignoringFeedbackSemantics: true,
      data: componentData,
      childWhenDragging: myPolicySet.showComponentBody(componentData),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: componentData.size.width,
          height: componentData.size.height,
          child: myPolicySet.showComponentBody(componentData),
        ),
      ),
      child: child ?? myPolicySet.showComponentBody(componentData),
    );
  }
}
