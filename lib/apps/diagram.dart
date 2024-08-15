import 'package:app_fractal/app.dart';
import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal/fractal.dart';
import 'package:fractal/utils/random.dart';
import 'package:fractal2d/diagram_editor.dart';
import 'package:fractal_base/db.dart';
import 'package:fractal_base/fractals/device.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/models/index.dart';
import 'package:fractal_layout/widget.dart';
import 'package:fractals2d/client.dart';
import 'package:fractals2d/mixins/canvas.dart';
import '../widgets/default.dart';

class DiagramAppFractal extends AppFractal with CanvasMix {
  /*
  final socket = Fractal2dClient(
    name: socketId,
  )..connect();

  static String get socketId => DBF.main['socket'] ??= getRandomString(8);
  */

  DiagramAppFractal({
    required super.name,
  });

  /*
  @override
  consume(event) {
    canvasConsume(event);
    return super.consume(event);
  }
  */

  static Future<bool> prepare() async {
    await Fractals2d.init();

    final canvasUI = UIF<CanvasFractal>('canvas');

    var name = (await DBF.main.getVar('device'));
    if (name == null) {
      name = getRandomString(8);
      await DBF.main.setVar('device', name);
    }

    final map = EventFractal.map.map;

    map['network'] =
        NetworkFractal.active = await NetworkFractal.controller.put({
      'name': FileF.host,
      'createdAt': 2,
      'pubkey': '',
    });

    map['device'] = DeviceFractal.my = await DeviceFractal.controller.put({
      'name': name,
      'createdAt': 0,
      'pubkey': '',
    })
      ..synch();

    map['app'] = AppFractal.main = await AppFractal.controller.put({
      'name': FileF.main,
      'createdAt': 2,
      'owner': '',
    });

    canvasUI.builders[''] = (f) => FractalAreaWidget(
          f,
          () => DefaultCanvasArea(
            fractal: f as CanvasMix,
            key: f.widgetKey('canvas'),
          ),
        );

    return true;
  }

  //Widget Function() positionerBuilder = () => const PositionerArea();
}
