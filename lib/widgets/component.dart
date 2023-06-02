import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:fractal2d/providers/app.dart';
import 'package:provider/provider.dart';

import '/abstraction_layer/policy/base/policy_set.dart';
import '/canvas_context/canvas_state.dart';
import '../models/component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Component extends ConsumerWidget {
  const Component({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ctx = ref.read(editorContextProvider);

    final componentData = Provider.of<ComponentData>(context);
    final canvasState = ctx.canvasState;

    final policy = ctx.policySet;

    return Positioned(
      left: canvasState.scale * componentData.position.dx +
          canvasState.position.dx,
      top: canvasState.scale * componentData.position.dy +
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
                  child: ctx.policySet.showComponentBody(componentData),
                ),
              ),
              policy.showCustomWidgetWithComponentData(context, componentData),
            ],
          ),
          onTap: () => policy.onComponentTap(componentData.id),
          onTapDown: (TapDownDetails details) =>
              policy.onComponentTapDown(componentData.id, details),
          onTapUp: (TapUpDetails details) =>
              policy.onComponentTapUp(componentData.id, details),
          onTapCancel: () => policy.onComponentTapCancel(componentData.id),
          onScaleStart: (ScaleStartDetails details) =>
              policy.onComponentScaleStart(componentData.id, details),
          onScaleUpdate: (ScaleUpdateDetails details) =>
              policy.onComponentScaleUpdate(componentData.id, details),
          onScaleEnd: (ScaleEndDetails details) =>
              policy.onComponentScaleEnd(componentData.id, details),
          onLongPress: () => policy.onComponentLongPress(componentData.id),
          onLongPressStart: (LongPressStartDetails details) =>
              policy.onComponentLongPressStart(componentData.id, details),
          onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) =>
              policy.onComponentLongPressMoveUpdate(componentData.id, details),
          onLongPressEnd: (LongPressEndDetails details) =>
              policy.onComponentLongPressEnd(componentData.id, details),
          onLongPressUp: () => policy.onComponentLongPressUp(componentData.id),
        ),
      ),
    );
  }
}
