import 'package:fractal2d/policy/base/index.dart';
import 'package:fractal_flutter/fractal_flutter.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:fractals2d/models/component.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:signed_fractal/models/index.dart';

class Component extends StatelessWidget {
  const Component({super.key});

  @override
  Widget build(context) {
    final c = context.watch<CanvasMix>();

    final component = Provider.of<ComponentFractal>(context);
    final policy = Provider.of<PolicySet>(context);

    return Positioned(
      left: c.cState.scale * component.position.value.dx + c.cState.position.dx,
      top: c.cState.scale * component.position.value.dy + c.cState.position.dy,
      width: c.cState.scale * component.size.width,
      height: c.cState.scale * component.size.height,
      child: Listener(
        onPointerSignal: (PointerSignalEvent event) {
          policy.onComponentPointerSignal(component, event);
        },
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  width: component.size.width,
                  height: component.size.height,
                  child: Container(
                    transform: Matrix4.identity()
                      ..scale(
                        c.cState.scale,
                      ),
                    child: policy.showComponentBody(component),
                  ),
                ),
                policy.showCustomWidgetWithComponentFractal(
                  context,
                  component,
                ),
              ],
            ),
            onTap: () => policy.onComponentTap(component),
            onTapDown: (details) {
              policy.onComponentTapDown(component, details);
            },
            onTapUp: (details) {
              policy.onComponentTapUp(component, details);
            },
            onTapCancel: () {
              policy.onComponentTapCancel(component);
            },
            onScaleStart: (details) {
              policy.onComponentScaleStart(
                component,
                details,
              );
            },
            onScaleUpdate: (details) {
              policy.onComponentScaleUpdate(
                component,
                details,
              );
            },
            onScaleEnd: (details) {
              policy.onComponentScaleEnd(
                component,
                details,
              );
            },
            onLongPress: () {
              policy.onComponentLongPress(component);
            },
            onLongPressStart: (details) {
              policy.onComponentLongPressStart(
                component,
                details,
              );
            },
            onLongPressMoveUpdate: (details) {
              policy.onComponentLongPressMoveUpdate(
                component,
                details,
              );
            },
            onLongPressEnd: (details) {
              policy.onComponentLongPressEnd(
                component,
                details,
              );
            },
            onLongPressUp: () {
              policy.onComponentLongPressUp(component);
            }),
      ),
    );
  }
}
