import 'package:fractals2d/models/policy.dart';
import 'package:flutter/gestures.dart';

import '../../lib.dart';

/// Allows you to define the link behaviour on any gesture registered by the [Link].
mixin LinkPolicy on BasePolicySet {
  onLinkTap(LinkFractal link) {}

  onLinkTapDown(LinkFractal link, TapDownDetails details) {}

  onLinkTapUp(LinkFractal link, TapUpDetails details) {}

  onLinkTapCancel(LinkFractal link) {}

  onLinkScaleStart(LinkFractal link, ScaleStartDetails details) {}

  onLinkScaleUpdate(LinkFractal link, ScaleUpdateDetails details) {}

  onLinkScaleEnd(LinkFractal link, ScaleEndDetails details) {}

  onLinkLongPress(LinkFractal link) {}

  onLinkLongPressStart(LinkFractal link, LongPressStartDetails details) {}

  onLinkLongPressMoveUpdate(
      LinkFractal link, LongPressMoveUpdateDetails details) {}

  onLinkLongPressEnd(LinkFractal link, LongPressEndDetails details) {}

  onLinkLongPressUp(LinkFractal link) {}

  onLinkPointerSignal(LinkFractal link, PointerSignalEvent event) {}
}
