import '/abstraction_layer/policy/base_policy_set.dart';
import '../../../models/component.dart';
import 'package:flutter/material.dart';

/// Allows you to specify a design of the components.
mixin ComponentDesignPolicy on BasePolicySet {
  /// Returns a widget that specifies a design of this component.
  ///
  /// Recommendation: type can by used to determine what widget should be returned.
  Widget? showComponentBody(ComponentData componentData) {
    return null;
  }
}
