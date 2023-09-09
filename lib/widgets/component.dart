import 'package:fractal2d/policy/base/index.dart';
import 'package:fractals2d/models/component.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../apps/diagram.dart';

class Component extends StatelessWidget {
  const Component({super.key});

  @override
  Widget build(context) {
    final app = context.watch<DiagramAppFractal>();

    final componentData = Provider.of<ComponentFractal>(context);
    final policy = Provider.of<PolicySet>(context);

    return Positioned(
      left: app.state.scale * componentData.position.value.dx +
          app.state.position.value.dx,
      top: app.state.scale * componentData.position.value.dy +
          app.state.position.dy,
      width: app.state.scale * componentData.size.width,
      height: app.state.scale * componentData.size.height,
      child: Listener(
        onPointerSignal: (PointerSignalEvent event) {
          policy.onComponentPointerSignal(componentData.id, event);
        },
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  width: componentData.size.width,
                  height: componentData.size.height,
                  child: Container(
                    transform: Matrix4.identity()
                      ..scale(
                        app.state.scale,
                      ),
                    child: policy.showComponentBody(componentData),
                  ),
                ),
                policy.showCustomWidgetWithComponentFractal(
                  context,
                  componentData,
                ),
              ],
            ),
            onTap: () => policy.onComponentTap(componentData),
            onTapDown: (details) {
              policy.onComponentTapDown(componentData.id, details);
            },
            onTapUp: (details) {
              policy.onComponentTapUp(componentData.id, details);
            },
            onTapCancel: () {
              policy.onComponentTapCancel(componentData.id);
            },
            onScaleStart: (details) {
              policy.onComponentScaleStart(
                componentData.id,
                details,
              );
            },
            onScaleUpdate: (details) {
              policy.onComponentScaleUpdate(
                componentData,
                details,
              );
            },
            onScaleEnd: (details) {
              policy.onComponentScaleEnd(
                componentData.id,
                details,
              );
            },
            onLongPress: () {
              policy.onComponentLongPress(componentData.id);
            },
            onLongPressStart: (details) {
              policy.onComponentLongPressStart(
                componentData.id,
                details,
              );
            },
            onLongPressMoveUpdate: (details) {
              policy.onComponentLongPressMoveUpdate(
                componentData.id,
                details,
              );
            },
            onLongPressEnd: (details) {
              policy.onComponentLongPressEnd(
                componentData.id,
                details,
              );
            },
            onLongPressUp: () {
              policy.onComponentLongPressUp(componentData.id);
            }),
      ),
    );
  }
}
