/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal2d/policy/base/canvas_policy.dart';

import '../../providers/positioner.dart';

mixin RiverpodPolicy implements CanvasPolicy {

  late Ref ref;
  refer(Ref ref) {
    this.ref = ref;
  }

  @override
  onCanvasTapUp(TapUpDetails details) async {
    final positioner = ref.read(Positioner.provider.notifier);

    if (!positioner.isPlaced) positioner.moveTo(details.localPosition);
  }
}

*/