import 'package:app_fractal/app.dart';
import 'package:fractal/fractal.dart';
import 'package:fractal/utils/random.dart';
import 'package:fractal2d/diagram_editor.dart';
import 'package:fractal_base/db.dart';
import 'package:fractals2d/client.dart';
import 'package:fractals2d/models/canvas.dart';

class DiagramAppFractal extends AppFractal with CanvasMix {
  final socket = Fractal2dClient(
    name: socketId,
  );

  static String get socketId => DBF.main['socket'] ??= getRandomString(8);

  DiagramAppFractal({
    required super.domain,
    required super.color,
    required super.title,
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
  }

  //Widget Function() positionerBuilder = () => const PositionerArea();
}
