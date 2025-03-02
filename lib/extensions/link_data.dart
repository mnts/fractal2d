import 'dart:ui';
import 'package:fractal2d/extensions/position.dart';
import 'package:fractals2d/models/link_data.dart';
import 'package:position_fractal/fractals/offset.dart';

import '../utils/vector_utils.dart';

extension LinkDataExt on LinkFractal {
  /// If a link is compound from more than one segments this returns an index of the link segment, which was tapped on.
  ///
  /// Segments are indexed from 1.
  /// If there is no link segment on the tap location it returns null.
  /// It should take a [localPosition] from a [onLinkTap] function or similar.
  int? determineLinkSegmentIndex(
    OffsetF position,
    OffsetF canvasPosition,
    double canvasScale,
  ) {
    for (int i = 0; i < linkPoints.length - 1; i++) {
      var point1 = linkPoints[i] * canvasScale + canvasPosition;
      var point2 = linkPoints[i + 1] * canvasScale + canvasPosition;

      Path rect = VectorUtils.getRectAroundLine(point1.offset, point2.offset,
          canvasScale * (linkStyle.lineWidth + 5));

      if (rect.contains(position.offset)) {
        return i + 1;
      }
    }
    return null;
  }
}
