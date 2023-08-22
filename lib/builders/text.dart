import 'package:flutter/material.dart';
import 'package:fractal_flutter/future.dart';
import 'package:fractals2d/models/component.dart';

extension ComponentFractalExt on ComponentFractal {
  Widget build(BuildContext ctx) => Text(data?.content ?? '');
}
