import 'package:flutter/material.dart';
import 'package:fractal_flutter/provider.dart';
import '../apps/diagram.dart';

class OptionsArea extends StatelessWidget {
  const OptionsArea({super.key});

  @override
  Widget build(context) {
    //final app = context.watch<DiagramAppFractal>();

    double width = 300;

    return Container();
    /*Positioned(
      left: app.position.x - width / 2,
      top: app.position.y - 40,
      width: width,
      height: 400,
      child: TapRegion(
        onTapInside: (tap) {},
        onTapOutside: (tap) {
          app.reposition();
        },
        child: Listener(
          onPointerMove: (event) {
            app.reposition();
          },
          child: app.positionerBuilder(),
        ),
      ),
    );
    */
  }
}
