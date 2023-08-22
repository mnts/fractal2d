import 'package:flutter/material.dart';
import 'package:position_fractal/fractals/offset.dart';

import '../lib.dart';

extension ComponentMix on ComponentFractal {
  OffsetF getPointOnComponent(Alignment alignment) {
    return OffsetF(
      size.value.width * ((alignment.x + 1) / 2),
      size.value.height * ((alignment.y + 1) / 2),
    );
  }

  resizeDelta(OffsetF deltaSize) {
    size.move(size.value + deltaSize);
  }
}
