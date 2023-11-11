import 'package:app_fractal/app.dart';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal/fractal.dart';
import 'package:fractal/utils/random.dart';
import 'package:fractal2d/diagram_editor.dart';
import 'package:fractal_base/db.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/models/index.dart';
import 'package:fractals2d/client.dart';
import 'package:fractals2d/mixins/canvas.dart';
import '../widgets/default.dart';

class DiagramAppFractal extends AppFractal with CanvasMix {
  final socket = Fractal2dClient(
    name: socketId,
  )..connect();

  static String get socketId => DBF.main['socket'] ??= getRandomString(8);

  DiagramAppFractal({
    required super.name,
  });

  @override
  consume(event) {
    canvasConsume(event);
    return super.consume(event);
  }

  static Future<void> prepare() async {
    await DBF.initiate();

    await Fractals2d.init();

    UIF.map['canvas'] = UIF(
      //tile: (screen, context) => Text(screen.content),
      screen: (screen, context) => DefaultCanvasArea(
        fractal: screen as CanvasMix,
        key: screen.widgetKey('canvas'),
      ),
    );

    return;
  }

  //Widget Function() positionerBuilder = () => const PositionerArea();
}
