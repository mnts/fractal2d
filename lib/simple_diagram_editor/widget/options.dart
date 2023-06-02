import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app.dart';
import '../../providers/positioner.dart';

class OptionsArea extends ConsumerWidget {
  const OptionsArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positioner = ref.watch(Positioner.provider.notifier);
    final position = ref.watch(Positioner.provider);

    final app = ref.read(editorContextProvider);

    double width = 300;

    return Positioned(
      left: position.x - width / 2,
      top: position.y - 40,
      width: width,
      height: 400,
      child: TapRegion(
        onTapInside: (tap) {},
        onTapOutside: (tap) {
          positioner.reset();
        },
        child: Listener(
          onPointerMove: (event) {
            positioner.reset();
          },
          child: app.positionerBuilder(),
        ),
      ),
    );
  }
}
