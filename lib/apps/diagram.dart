import 'package:fractal_layout/models/index.dart';
import 'package:fractal_layout/widget.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:latlong2/latlong.dart';

import '../lib.dart';

class DiagramAppFractal extends AppFractal with CanvasMix {
  final bool showMap;
  final String? mapTileProvider;
  final LatLng mapCenter;
  final double mapZoom;

  /*
  final socket = Fractal2dClient(
    name: socketId,
  )..connect();

  static String get socketId => DBF.main['socket'] ??= getRandomString(8);
  */

  DiagramAppFractal({
    required super.name,
    this.showMap = false,
    this.mapTileProvider,
    this.mapCenter = const LatLng(0, 0),
    this.mapZoom = 1,
  });

  /*
  @override
  consume(event) {
    canvasConsume(event);
    return super.consume(event);
  }
  */

  static Future<bool> prepare() async {
    final canvasUI = UIF<CanvasFractal>('canvas');

    canvasUI.builders[''] = (f) => FractalAreaWidget(
          f,
          () => DiagramEditorCanvas(
            f as CanvasMix,
            key: f.widgetKey('canvas'),
            showMap: true,
            mapTileProvider: FTileProviders.google,
            mapCenter: const LatLng(0, 0),
            mapZoom: 1,
          ),
        );

    await FractalMap.prepare();
    return true;
  }

  //Widget Function() positionerBuilder = () => const PositionerArea();
}
