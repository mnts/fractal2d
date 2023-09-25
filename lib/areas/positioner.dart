import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../apps/diagram.dart';

class PositionerArea extends StatelessWidget {
  const PositionerArea({super.key});

  @override
  Widget build(context) {
    //final app = context.watch<DiagramAppFractal>();

    return Container(
      color: Colors.orange.withAlpha(200),
      child: Column(children: [
        IconButton(
          onPressed: () async {
            //app.putImage(app.position);
            //app.reposition();
          },
          icon: const Icon(
            Icons.image,
          ),
        ),
      ]),
    );
  }
}
