import 'package:fractal_layout/index.dart';
import 'package:position_fractal/fractals/offset.dart';

import '../base/link_widgets_policy.dart';
import '../../lib.dart';
import 'package:flutter/material.dart';

mixin MyLinkWidgetsPolicy implements LinkWidgetsPolicy, CustomStatePolicy {
  @override
  List<Widget> showWidgetsWithLinkData(BuildContext context, LinkFractal link) {
    //return [];
    double linkLabelSize = 48;

    return [
      if (link['input'] case String input)
        label(
          labelPosition(
            link.linkPoints.first,
            link.linkPoints[1],
            linkLabelSize / 2,
          ),
          input, //linkData.data.startLabel,
          linkLabelSize,
        ),
      if (link['output'] case String output)
        label(
          labelPosition(
            link.linkPoints.last,
            link.linkPoints[link.linkPoints.length - 2],
            linkLabelSize / 2,
          ),
          output, //linkData.data.endLabel,
          linkLabelSize,
        ),
      if (selectedLink == link) showLinkOptions(context, link),
    ];
  }

  Widget showLinkOptions(BuildContext context, LinkFractal linkData) {
    var nPos = state.toCanvasCoordinates(tapLinkPosition);
    return Positioned(
      left: nPos.dx,
      top: nPos.dy,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              model.removeLink(linkData);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              width: 32,
              height: 32,
              child: const Center(
                child: Icon(Icons.close, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              //ConfigFArea.openDialog(linkData);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              width: 32,
              height: 32,
              child: const Center(
                child: Icon(Icons.edit, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget label(OffsetF position, String label, double size) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      width: size * state.scale,
      height: size * state.scale,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: GestureDetector(
          onTap: () {},
          onLongPress: () {},
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10 * state.scale,
              ),
            ),
          ),
        ),
      ),
    );
  }

  OffsetF labelPosition(
    OffsetF point1,
    OffsetF point2,
    double labelSize,
  ) {
    var normalized = VectorUtils.normalizeVector(
      point2.offset - point1.offset,
    ).f;

    var left = point1.offset.dx > point2.offset.dx;

    return state.toCanvasCoordinates(
      point1 -
          OffsetF(labelSize, labelSize) +
          normalized * labelSize +
          VectorUtils.getPerpendicularVectorToVector(
                normalized.offset,
                left,
              ).f *
              labelSize,
    );
  }

  @override
  Widget showOnLinkTapWidget(
      BuildContext context, LinkFractal link, Offset tapPosition) {
    return Positioned(
      left: tapPosition.dx,
      top: tapPosition.dy,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              model.removeLink(link);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                width: 32,
                height: 32,
                child: Center(child: Icon(Icons.close, size: 20))),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              //ConfigFArea.openDialog(link);
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                width: 32,
                height: 32,
                child: Center(child: Icon(Icons.edit, size: 20))),
          ),
        ],
      ),
    );
  }
}
