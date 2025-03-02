import 'package:fractals2d/models/policy.dart';
import 'package:fractals2d/models/component.dart';
import 'package:flutter/material.dart';
import 'package:position_fractal/fractals/offset.dart';

mixin LinkAttachmentPolicy on BasePolicySet {
  /// Calculates an alignment of link endpoint on a component from ComponentFractal and targetPoint (nearest link point from this component).
  ///
  /// With no implementation the link will attach to center of the component.
  Alignment getLinkEndpointAlignment(
    ComponentFractal componentData,
    OffsetF targetPoint,
  ) {
    return Alignment.center;
  }
}
