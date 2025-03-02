import 'package:fractal/lib.dart';
import 'package:position_fractal/fractals/offset.dart';

import 'package:signed_fractal/models/event.dart';

import '../base/canvas_widgets_policy.dart';
import '../../lib.dart';
import 'package:flutter/material.dart';

import 'constrains.dart';

mixin MyCanvasWidgetsPolicy implements CanvasWidgetsPolicy, CustomStatePolicy {
  @override
  List<Widget> showCustomWidgetsOnCanvasBackground(BuildContext context) {
    return [
      //if (gridGap > 0)
      Visibility(
        visible: isGridVisible,
        child: CustomPaint(
          size: Size.infinite,
          painter: GridPainter(
            horizontalGap: gridGap,
            verticalGap: gridGap,
            offset: state.position.offset / state.scale,
            scale: state.scale,
            lineWidth: (state.scale < 1.0) ? state.scale : 1.0,
            matchParentSize: false,
            lineColor: Color.fromARGB(255, 243, 247, 250),
          ),
        ),
      ),
      if (this is ConstrainsPolicy) (this as ConstrainsPolicy).showConstrains(),
      DragTarget<Fractal>(
        builder: (_, __, ___) => Container(),
        onWillAccept: (data) => true,
        onAcceptWithDetails: (details) =>
            _onAcceptWithDetails(details, context),
      ),
    ];
  }

  _onAcceptWithDetails(
    DragTargetDetails<Fractal> details,
    BuildContext context,
  ) {
    final ob = context.findRenderObject();
    if (ob == null) return;
    final renderBox = ob as RenderBox;
    final localOffset = renderBox.globalToLocal(details.offset);
    final componentPosition = state.fromCanvasCoordinates(localOffset.f);
    final newComponent = switch (details.data) {
      (ComponentFractal d) => ComponentFractal(
          to: model,
          position: componentPosition,
          //data: MyComponentFractal.copy(componentData.data),
          size: d.size.value,
          //minSize: componentData.minSize,
          //type: d.type,
        ),
      (EventFractal d) => ComponentFractal(
          position: componentPosition,

          to: model,
          //data: MyComponentFractal.copy(componentData.data),
          size: const SizeF(192, 108),
          data: d,
          //minSize: componentData.minSize,
          //type: (d.file.isEmpty) ? 'text' : 'image', //d.type,
        ),
      _ => throw 'wrong data for component',
    };

    newComponent.synch();
    //model.components.add(newComponent);

    //model.moveComponentToTheFrontWithChildren(newComponent.id);
  }
}
