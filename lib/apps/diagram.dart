import 'package:fractal/fractal.dart';
import 'package:fractal/types/file.dart';
import 'package:fractal/utils/random.dart';
import 'package:fractal2d/diagram_editor.dart';
import 'package:fractal_base/db.dart';
import 'package:fractals2d/client.dart';
import 'package:position_fractal/fractals/index.dart';
import 'package:signed_fractal/models/event.dart';

class DiagramAppFractal extends DiagramEditorContext {
  final socket = Fractal2dClient(
    name: socketId,
  );

  static String get socketId => DBF.main['socket'] ??= getRandomString(8);

  DiagramAppFractal({required super.policy}) {
    init();
  }

  static Future<void> prepare() async {
    await DBF.initiate();

    await Fractals2d.init();
  }

  //Widget Function() positionerBuilder = () => const PositionerArea();

  init() async {
    if (!policy.state.isInitialized) {
      policy.initializeDiagramEditor();
      policy.state.isInitialized = true;
    }
  }
}
