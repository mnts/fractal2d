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
    final canvasState = app.policy.state;

    final policy = app.policy;

    return Positioned(
      left: canvasState.scale * componentData.position.value.dx +
          canvasState.position.value.dx,
      top: canvasState.scale * componentData.position.value.dy +
          canvasState.position.dy,
      width: canvasState.scale * componentData.size.width,
      height: canvasState.scale * componentData.size.height,
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
                  transform: Matrix4.identity()..scale(canvasState.scale),
                  child: policy.showComponentBody(componentData),
                ),
              ),
              policy.showCustomWidgetWithComponentFractal(
                context,
                componentData,
              ),
            ],
          ),
          onTap: () => policy.onComponentTap(componentData.id),
          onTapDown: (details) =>
              policy.onComponentTapDown(componentData.id, details),
          onTapUp: (details) =>
              policy.onComponentTapUp(componentData.id, details),
          onTapCancel: () => policy.onComponentTapCancel(componentData.id),
          onScaleStart: (details) =>
              policy.onComponentScaleStart(componentData.id, details),
          onScaleUpdate: (details) =>
              policy.onComponentScaleUpdate(componentData, details),
          onScaleEnd: (details) =>
              policy.onComponentScaleEnd(componentData.id, details),
          onLongPress: () => policy.onComponentLongPress(componentData.id),
          onLongPressStart: (details) =>
              policy.onComponentLongPressStart(componentData.id, details),
          onLongPressMoveUpdate: (details) =>
              policy.onComponentLongPressMoveUpdate(componentData.id, details),
          onLongPressEnd: (details) =>
              policy.onComponentLongPressEnd(componentData.id, details),
          onLongPressUp: () => policy.onComponentLongPressUp(componentData.id),
        ),
      ),
    );
  }
}
