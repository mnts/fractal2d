import 'package:color/color.dart';
import 'package:fractal_flutter/extensions/color.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractals2d/models/link_data.dart';
import 'package:fractals2d/models/link_style.dart';
import '../apps/diagram.dart';
import '../policy/base/policy_set.dart';
import '/utils/painter/link_joint_painter.dart';
import '/utils/painter/link_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Color;

class Link extends StatelessWidget {
  final LinkFractal link;
  const Link(
    this.link, {
    Key? key,
  });

  @override
  Widget build(context) {
    final policy = context.read<PolicySet>();

    LinkPainter linkPainter = LinkPainter(
      linkPoints: (link.linkPoints.map(
        (point) => point * policy.state.scale + policy.state.position,
      )).toList(),
      scale: policy.state.scale,
      linkStyle: link.style,
    );

    return Listener(
      onPointerSignal: (PointerSignalEvent event) => policy.onLinkPointerSignal(
        link,
        event,
      ),
      child: GestureDetector(
        child: CustomPaint(
          painter: linkPainter,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ...link.linkPoints.getRange(1, link.linkPoints.length - 1).map(
                (jointPoint) {
                  var index = link.linkPoints.indexOf(jointPoint);
                  return Visibility(
                    visible: link.areJointsVisible,
                    child: GestureDetector(
                      onTap: () => policy.onLinkJointTap(index, link),
                      onTapDown: (details) =>
                          policy.onLinkJointTapDown(index, link, details),
                      onTapUp: (details) =>
                          policy.onLinkJointTapUp(index, link, details),
                      onTapCancel: () =>
                          policy.onLinkJointTapCancel(index, link),
                      onScaleStart: (details) =>
                          policy.onLinkJointScaleStart(index, link, details),
                      onScaleUpdate: (details) =>
                          policy.onLinkJointScaleUpdate(index, link, details),
                      onScaleEnd: (details) =>
                          policy.onLinkJointScaleEnd(index, link, details),
                      onLongPress: () =>
                          policy.onLinkJointLongPress(index, link),
                      onLongPressStart: (details) => policy
                          .onLinkJointLongPressStart(index, link, details),
                      onLongPressMoveUpdate: (details) => policy
                          .onLinkJointLongPressMoveUpdate(index, link, details),
                      onLongPressEnd: (details) =>
                          policy.onLinkJointLongPressEnd(index, link, details),
                      onLongPressUp: () =>
                          policy.onLinkJointLongPressUp(index, link),
                      child: CustomPaint(
                        painter: LinkJointPainter(
                          location:
                              policy.state.toCanvasCoordinates(jointPoint),
                          radius: 8,
                          scale: policy.state.scale,
                          color: link.linkStyle.color.toMaterial,
                        ),
                      ),
                    ),
                  );
                },
              ),
              ...policy.showWidgetsWithLinkData(context, link),
            ],
          ),
        ),
        onTap: () => policy.onLinkTap(link),
        onTapDown: (TapDownDetails details) =>
            policy.onLinkTapDown(link, details),
        onTapUp: (TapUpDetails details) => policy.onLinkTapUp(link, details),
        onTapCancel: () => policy.onLinkTapCancel(link),
        onScaleStart: (ScaleStartDetails details) =>
            policy.onLinkScaleStart(link, details),
        onScaleUpdate: (ScaleUpdateDetails details) =>
            policy.onLinkScaleUpdate(link, details),
        onScaleEnd: (ScaleEndDetails details) =>
            policy.onLinkScaleEnd(link, details),
        onLongPress: () => policy.onLinkLongPress(link),
        onLongPressStart: (LongPressStartDetails details) =>
            policy.onLinkLongPressStart(link, details),
        onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) =>
            policy.onLinkLongPressMoveUpdate(link, details),
        onLongPressEnd: (LongPressEndDetails details) =>
            policy.onLinkLongPressEnd(link, details),
        onLongPressUp: () => policy.onLinkLongPressUp(link),
      ),
    );
  }
}
