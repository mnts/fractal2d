import 'package:flutter/material.dart' as Material;
import 'package:color/color.dart';

extension ColorExt on Color {
  Material.Color get toMaterial => Material.Color(hashCode);
}

extension ColorMExt on Material.Color {
  Color get fromMaterial => Color.hex(hashCode.toString());
}
