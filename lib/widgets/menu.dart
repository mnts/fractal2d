import 'package:color/color.dart';
import 'package:position_fractal/fractals/offset.dart';

import '../lib.dart';
import 'package:flutter/material.dart' hide Color;

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
            var componentData = getComponentFractal(componentType);
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
                        aspectRatio: componentData.size.value.size.aspectRatio,
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

  ComponentFractal getComponentFractal(String componentType) {
    switch (componentType) {
      case 'junction':
        return ComponentFractal(
          id: 0,
          size: SizeF(16, 16),
          position: OffsetF.zero,
          color: const Color.rgb(0, 0, 0),
        );
      default:
        return ComponentFractal(
          id: 0,
          size: const Size(120, 72).f,
          position: OffsetF.zero,
          color: const Color.rgb(255, 255, 255),
        );
    }
  }
}

class DraggableComponent extends StatelessWidget {
  final MyPolicySet myPolicySet;
  final ComponentFractal componentData;
  final Widget? child;

  const DraggableComponent({
    super.key,
    this.child,
    required this.myPolicySet,
    required this.componentData,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<ComponentFractal>(
      affinity: Axis.horizontal,
      ignoringFeedbackSemantics: true,
      data: componentData,
      childWhenDragging: myPolicySet.showComponentBody(componentData),
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: componentData.size.width,
          height: componentData.size.height,
          child: myPolicySet.showComponentBody(componentData),
        ),
      ),
      child: child ?? myPolicySet.showComponentBody(componentData),
    );
  }
}
