import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:fractals2d/models/state.dart';

import '../lib.dart';
import '../policy/base/policy_set.dart';
import '../policy/main/set.dart';

/*
class CanvasArea extends StatelessWidget {
  final MyPolicySet policy;
  const CanvasArea({required this.policy, super.key});

  @override
  Widget build(BuildContext context) {
    return FMultiProvider(
      providers: [
        FChangeNotifierProvider<CanvasMix>.value(
          value: policy.model,
        ),
        FChangeNotifierProvider<PolicySet>.value(
          value: policy,
        ),
        FChangeNotifierProvider<CanvasState>.value(
          value: policy.state,
        ),
      ],
      builder: (context, child) => const DiagramEditorCanvas(),
    );
  }
}

*/