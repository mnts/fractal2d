import 'dart:ui';

import 'package:position_fractal/fractals/offset.dart';

extension OffsetFMix on OffsetF {
  Offset get offset => Offset(x, y);
}

extension SizeFMix on SizeF {
  Size get size => Size(width, height);
}

extension OffsetMix on Offset {
  OffsetF get f => OffsetF(dx, dy);
}

extension SizeMix on Size {
  get f => SizeF(width, height);
}
