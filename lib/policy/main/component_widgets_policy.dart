import 'dart:math';

import 'package:currency_ui/pay.dart';
import 'package:fractal2d/lib.dart';
import 'package:fractal2d/policy/base/component_widgets_policy.dart';
import 'package:position_fractal/fractals/offset.dart';
import 'package:signed_fractal/models/event.dart';

import '/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyComponentWidgetsPolicy
    implements ComponentWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentFractalOver(
      BuildContext context, ComponentFractal componentData) {
    bool isJunction = componentData.type == 'junction';
    bool showOptions =
        (!isMultipleSelectionOn) && (!isReadyToConnect) && !isJunction;

    return Visibility(
      visible: componentData.isHighlightVisible,
      child: Stack(
        children: [
          if (showOptions) componentTopOptions(componentData, context),
          //if (showOptions) componentBottomOptions(componentData),
          highlight(
            componentData,
            isMultipleSelectionOn ? Colors.cyan : Theme.of(context).canvasColor,
          ),
          if (showOptions) resizeCorner(componentData),
          if (isJunction && !isReadyToConnect) junctionOptions(componentData),
        ],
      ),
    );
  }

  Widget componentTopOptions(ComponentFractal f, context) {
    final width = f.size.width.round();
    final height = f.size.height.round();
    OffsetF tLeft = state.toCanvasCoordinates(f.position.value);
    OffsetF bRight = state.toCanvasCoordinates(
      OffsetF(
        f.position.value.dx + width,
        f.position.value.dy + height,
      ),
    );

    final price = (width * height / 100).round() / 5000;

    const double maxW = 320;
    final double w = max(bRight.dx - tLeft.dx, maxW);
    return Positioned(
      left: tLeft.dx - 5,
      top: tLeft.dy - 42,
      child: Container(
        width: w,
        alignment: Alignment.center,
        padding: EdgeInsets.all(4),
        height: 42,
        child: Flex(
          //mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) =>
                      Theme.of(context).canvasColor.withOpacity(0.7),
                ),
              ),
              onPressed: () {
                CryptoPay.request(price);
              },
              child: Row(
                children: [
                  Icon(Icons.monetization_on),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('w: $width'),
                      Text('h: $height'),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${price.toStringAsFixed(4)} Ξ',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset('assets/icons/metamask.png'),
                  ),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }

  Widget componentBottomOptions(ComponentFractal componentData) {
    final componentBottomLeftCorner = state.toCanvasCoordinates(
      componentData.position.value +
          componentData.size.value.size.bottomLeft(Offset.zero).f,
    );
    return Positioned(
      left: componentBottomLeftCorner.dx - 16,
      top: componentBottomLeftCorner.dy + 8,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_upward,
            tooltip: 'bring to front',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () => model.moveComponentToTheFront(componentData.id),
          ),
          SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_downward,
            tooltip: 'move to back',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () => model.moveComponentToTheBack(componentData.id),
          ),
          SizedBox(width: 40),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_right_alt,
            tooltip: 'connect',
            size: 40,
            onPressed: () {
              isReadyToConnect = true;
              componentData.updateComponent();
            },
          ),
        ],
      ),
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
          componentData.size.move(
            componentData.size.value + offset.f,
          );
          model.updateLinks(componentData);
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
              model.removeComponent(componentData.id);
              selectedComponentId = null;
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
