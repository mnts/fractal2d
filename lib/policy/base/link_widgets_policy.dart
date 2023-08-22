import 'package:fractals2d/models/link_data.dart';

import 'package:fractals2d/models/policy.dart';
import 'package:flutter/material.dart';

/// Allows you to add any widget to a link.
mixin LinkWidgetsPolicy on BasePolicySet {
  /// Allows you to add any widget to a link.
  ///
  /// You have [LinkData] here so you can customize the widgets to individual link.
  ///
  /// Recommendation: use Positioned as the root widget.
  List<Widget> showWidgetsWithLinkData(
      BuildContext context, LinkFractal linkData) {
    return [];
  }
}
