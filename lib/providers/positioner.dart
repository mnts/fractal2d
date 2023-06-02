import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/position.dart';

class Positioner extends StateNotifier<Position> {
  static final provider = StateNotifierProvider<Positioner, Position>(
    (ref) => Positioner(),
  );

  Positioner() : super(const Position(0, 0));

  Timer? _timer;
  //final pointers = <Pointer>[];

  bool get isPlaced => state.x != 0 || state.y != 0;
  double get x => state.x;
  double get y => state.y;

  hold(void Function(Timer) fn) {
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      fn,
    );
    fn(_timer!);
  }

  cancel() {
    _timer?.cancel();
    _timer = null;
  }

  moveTo(Offset offset) {
    state = Position(
      offset.dx,
      offset.dy,
      state.z,
    );
  }

  moveY([double value = 1]) {
    if (value == 0) return;
    state = Position(
      state.x,
      state.y + value,
      state.z,
    );
  }

  moveX([double value = 1]) {
    if (value == 0) return;
    state = Position(
      state.x + value,
      state.y,
      state.z,
    );
  }

  reset() {
    state = const Position(0, 0, 1);
  }
}
