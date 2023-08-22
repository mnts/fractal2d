import 'package:position_fractal/fractals/offset.dart';

import '../base/link_widgets_policy.dart';
import '/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyLinkWidgetsPolicy implements LinkWidgetsPolicy, CustomStatePolicy {
  @override
  List<Widget> showWidgetsWithLinkData(
      BuildContext context, LinkFractal linkData) {
    double linkLabelSize = 32;
    var linkStartLabelPosition = labelPosition(
      linkData.linkPoints.first,
      linkData.linkPoints[1],
      linkLabelSize / 2,
      false,
    );
    var linkEndLabelPosition = labelPosition(
      linkData.linkPoints.last,
      linkData.linkPoints[linkData.linkPoints.length - 2],
      linkLabelSize / 2,
      true,
    );

    return [
      label(
        linkStartLabelPosition,
        linkData.data.startLabel,
        linkLabelSize,
      ),
      label(
        linkEndLabelPosition,
        linkData.data.endLabel,
        linkLabelSize,
      ),
      if (selectedLinkId == linkData.id) showLinkOptions(context, linkData),
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
              model.removeLink(linkData.id);
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
              showEditLinkDialog(
                context,
                linkData,
              );
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

  Widget label(OffsetF position, String label, double size) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      width: size * state.scale,
      height: size * state.scale,
      child: Container(
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
    bool left,
  ) {
    var normalized = VectorUtils.normalizeVector(
      point2.offset - point1.offset,
    ).f;

    return state.toCanvasCoordinates(
      point1 -
          OffsetF(labelSize, labelSize) +
          normalized * labelSize +
          VectorUtils.getPerpendicularVectorToVector(normalized.offset, left)
                  .f *
              labelSize,
    );
  }

  // @override
  // Widget showOnLinkTapWidget(
  //     BuildContext context, LinkData linkData, Offset tapPosition) {
  //   return Positioned(
  //     left: tapPosition.dx,
  //     top: tapPosition.dy,
  //     child: Row(
  //       children: [
  //         GestureDetector(
  //           onTap: () {
  //             model.removeLink(linkData.id);
  //           },
  //           child: Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.red.withOpacity(0.7),
  //                 shape: BoxShape.circle,
  //               ),
  //               width: 32,
  //               height: 32,
  //               child: Center(child: Icon(Icons.close, size: 20))),
  //         ),
  //         SizedBox(width: 8),
  //         GestureDetector(
  //           onTap: () {
  //             showEditLinkDialog(
  //               context,
  //               linkData,
  //             );
  //           },
  //           child: Container(
  //               decoration: BoxDecoration(
  //                 color: Colors.grey.withOpacity(0.7),
  //                 shape: BoxShape.circle,
  //               ),
  //               width: 32,
  //               height: 32,
  //               child: Center(child: Icon(Icons.edit, size: 20))),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
