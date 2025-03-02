import 'package:fractal2d/policy/base/index.dart';
import 'package:fractal_flutter/fractal_flutter.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:fractals2d/models/component.dart';
import 'package:flutter/material.dart';

import '../policy/main/custom.dart';

class Component extends StatelessWidget {
  final ComponentFractal component;
  const Component(this.component, {super.key});

  @override
  Widget build(context) {
    final policy = context.read<PolicySet>();

    if (component.to case CanvasMix c) {
      return Listen(
        component,
        (ctx, ch) => Positioned(
          left: c.cState.scale * component.position.value.dx +
              c.cState.position.dx,
          top: c.cState.scale * component.position.value.dy +
              c.cState.position.dy,
          width: c.cState.scale * component.size.width,
          height: c.cState.scale * component.size.height,
          child: Listener(
            onPointerSignal: (event) {
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
                  if (policy case CustomStatePolicy policy
                      when policy.isReadyToConnect &&
                          policy.selectedComponent != component)
                    Positioned(
                      left: 0,
                      top: 0,
                      width: component.size.width,
                      height: component.size.height,
                      child: Container(
                        color: Colors.green.withAlpha(150),
                        transform: Matrix4.identity()
                          ..scale(
                            c.cState.scale,
                          ),
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
              },
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
