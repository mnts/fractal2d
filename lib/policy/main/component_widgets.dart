import 'dart:math';
import 'package:app_fractal/index.dart';
import 'package:fractal2d/lib.dart';
import 'package:fractal2d/policy/base/component_widgets_policy.dart';
import 'package:fractal2d/policy/main/constrains.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:position_fractal/fractals/offset.dart';
import 'package:flutter/material.dart';

mixin MyComponentWidgetsPolicy
    implements ComponentWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentFractalOver(
    BuildContext context,
    ComponentFractal componentData,
  ) {
    if (!componentData.isHighlightVisible) return const SizedBox();
    bool isJunction = componentData.type == 'junction';
    bool showOptions =
        (!isMultipleSelectionOn) && (!isReadyToConnect) && !isJunction;

    final theme = Theme.of(context);
    return Stack(
      children: [
        if (showOptions)
          componentTopOptionsArea(
            componentData,
            context,
          ),
        if (showOptions)
          componentBottomOptionsArea(
            componentData,
            context,
          ),
        highlight(
          componentData,
          isReadyToConnect
              ? Colors.orange
              : isMultipleSelectionOn
                  ? Colors.cyan
                  : Colors.grey,
        ),
        if (showOptions) resizeCorner(componentData),
        if (isJunction && !isReadyToConnect) junctionOptions(componentData),
      ],
    );
  }

  Widget componentTopOptionsArea(
    ComponentFractal f,
    BuildContext ctx,
  ) {
    final width = f.size.width.round();
    final height = f.size.height.round();
    OffsetF tLeft = state.toCanvasCoordinates(f.position.value);
    OffsetF bRight = state.toCanvasCoordinates(
      OffsetF(
        f.position.value.dx + width,
        f.position.value.dy + height,
      ),
    );

    const double maxW = 320;
    final double w = max(bRight.dx - tLeft.dx, maxW);

    return Positioned(
      left: tLeft.dx - 5,
      top: tLeft.dy - 46,
      child: Container(
          width: w,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(0),
          height: 48,
          child: componentTopRow(f, ctx)
          /*
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 40,
            onPressed: () {
              model.removeComponent(componentData.id);
              selectedComponentId = null;
            },
          ),
          SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.copy,
            tooltip: 'duplicate',
            size: 40,
            onPressed: () {
              String newId = duplicate(componentData);
              model.moveComponentToTheFront(newId);
              selectedComponentId = newId;
              hideComponentHighlight(componentData.id);
              highlightComponent(newId);
            },
          ),
          
          SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.edit,
            tooltip: 'edit',
            size: 40,
            onPressed: () => showEditComponentDialog(context, componentData),
          ),
          
          SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.link_off,
            tooltip: 'remove links',
            size: 40,
            onPressed: () =>
                model.removeComponentConnections(componentData.id),
          ),
          */

          ),
    );
  }

  Widget componentTopRow(ComponentFractal f, BuildContext ctx) {
    final width = f.size.width;
    final height = f.size.height;
    final price = (width * height / 100).round() / 5000;

    return Flex(
      //mainAxisAlignment: MainAxisAlignment.center,
      direction: Axis.horizontal,
      children: [],
    );
  }

  Widget componentBottomOptionsArea(ComponentFractal f, BuildContext ctx) {
    final bLeft = state.toCanvasCoordinates(
      f.position.value + f.size.value.size.bottomLeft(Offset.zero).f,
    );

    final width = f.size.width.round();
    final height = f.size.height.round();
    OffsetF tLeft = state.toCanvasCoordinates(f.position.value);
    OffsetF bRight = state.toCanvasCoordinates(
      OffsetF(
        bLeft.dx + width,
        bLeft.dy + height,
      ),
    );

    const double maxW = 320;
    final double w = max(bRight.dx - tLeft.dx, maxW);

    return Positioned(
      left: bLeft.dx - 5,
      top: bLeft.dy,
      child: Container(
        width: width.toDouble(),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(0),
        height: 48,
        transform: Matrix4.identity()
          ..scale(
            state.scale,
          ),
        child: componentBottomRow(f, ctx),
      ), /*Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.6),
            iconData: Icons.remove,
            tooltip: 'remove',
            size: 24,
            onPressed: () {
              OffsetF.zero.store(f);
            },
          ),*/
      /*
          OptionIcon(
            color: Colors.grey.withOpacity(0.6),
            iconData: Icons.arrow_upward,
            tooltip: 'bring to front',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () => model.moveComponentToTheFront(
              componentData.id,
            ),
          ),
          SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_downward,
            tooltip: 'move to back',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () => model.moveComponentToTheBack(
              componentData.id,
            ),
          ),
          */
    );
  }

  static final seq = SortedFrac<NodeFractal<EventFractal>>([
    AppFractal.active,
  ]);

  static Widget get nav => ScreensArea(
        node: AppFractal.active,
        onTap: (f) {},
      );

  connect(ComponentFractal f) {
    isReadyToConnect = true;
    f.updateComponent();
    notifyListeners();
    f.to?.notifyListeners();
  }

  Widget componentBottomRow(ComponentFractal f, BuildContext ctx) {
    final width = f.size.width;
    final height = f.size.height;
    final price = (width * height / 100).round() / 5000;

    return Flex(
      //mainAxisAlignment: MainAxisAlignment.center,
      direction: Axis.horizontal,
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.check),
          tooltip: 'submit',
          onPressed: () async {
            final rew = await f.myInteraction;
            final m = rew.m.writtenMap;
            final pulse = PulseF(map: m, by: rew);
            f.spread(pulse);
          },
        ),
        /*
        IconButton.filledTonal(
          icon: const Icon(Icons.settings),
          tooltip: 'setup',
          onPressed: () {
            ConfigFArea.openDialog(f);
          },
        ),
        */
        IconButton.filledTonal(
          icon: const Icon(Icons.delete_forever),
          tooltip: 'delete',
          onPressed: () {
            f.remove();
            if (f.to case CanvasMix c) {
              c.removeComponent(f);
            }
          },
        ),
        FractalTooltip(
          content: Builder(
            builder: (ctx) => nav,
          ),
          width: 300,
          height: 400,
          child: InkWell(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Tooltip(
                child: Icon(
                  Icons.arrow_right_alt,
                  color: isReadyToConnect ? Colors.orange : null,
                ),
                message: 'connect',
              ),
            ),
          ),
        ),
        const Spacer(),
        if (f.data case NodeFractal node)
          IconButton.filledTonal(
            icon: const Icon(Icons.screen_share_outlined),
            tooltip: 'navigate',
            onPressed: () {
              FractalLayoutState.active.go(node);
            },
          ),
      ],
    );
  }

  Widget highlight(ComponentFractal componentData, Color color) {
    return Positioned(
      left: state
          .toCanvasCoordinates(
            componentData.position.value - const OffsetF(2, 2),
          )
          .dx,
      top: state
          .toCanvasCoordinates(
            componentData.position.value - const OffsetF(2, 2),
          )
          .dy,
      child: CustomPaint(
        painter: ComponentHighlightPainter(
          width: (componentData.size.width + 4) * state.scale,
          height: (componentData.size.height + 4) * state.scale,
          color: color,
        ),
      ),
    );
  }

  resizeCorner(ComponentFractal componentData) {
    final componentBottomRightCorner = state.toCanvasCoordinates(
      componentData.position.value +
          componentData.size.value.size.bottomRight(Offset.zero).f,
    );
    return Positioned(
      left: componentBottomRightCorner.dx - 12,
      top: componentBottomRightCorner.dy - 12,
      child: GestureDetector(
        onPanUpdate: (details) {
          final offset = details.delta / state.scale;
          var newSize = componentData.size.value + offset.f;
          if (this is ConstrainsPolicy) {
            newSize = (this as ConstrainsPolicy).constrainSize(
              componentData,
              newSize,
            );
          }
          componentData.size.move(newSize);
          //model.updateLinks(componentData);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeDownRight,
          child: Container(
            width: 24,
            height: 24,
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: Colors.grey.shade600,
                  border: Border.all(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget junctionOptions(ComponentFractal componentData) {
    final componentPosition = state.toCanvasCoordinates(
      componentData.position.value,
    );
    return Positioned(
      left: componentPosition.dx - 24,
      top: componentPosition.dy - 48,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 32,
            onPressed: () {
              model.removeComponent(componentData);
              selectedComponent = null;
            },
          ),
          SizedBox(width: 8),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_right_alt,
            tooltip: 'connect',
            size: 32,
            onPressed: () {
              isReadyToConnect = true;
              componentData.updateComponent();
            },
          ),
        ],
      ),
    );
  }
}
