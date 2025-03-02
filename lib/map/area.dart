import 'package:flutter_map/flutter_map.dart';
import 'package:fractal_layout/models/index.dart';
import 'package:fractal_layout/scaffold.dart';
import 'package:fractal_layout/widget.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:latlong2/latlong.dart';

import '../lib.dart';

class FractalMap extends FEventWidget {
  FractalMap(super.f);

  CanvasMix get canvas => f as CanvasFractal;

  LatLng get ll => LatLng(
        canvas.cState.position.y,
        canvas.cState.position.x,
      );

  @override
  area() {
    return FlutterMap(
      options: MapOptions(
        //initialCenter: ll,
        //initialZoom: canvas.cState.position.z,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: FTileProviders.google,
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.app',
        ),
      ],
    );
  }

  static Future<bool> prepare() async {
    final canvasUI = UIF<CanvasFractal>('canvas');

    canvasUI.builders['map'] = (f) => FractalMap(
          f,
        );

    return true;
  }

  //Widget Function() positionerBuilder = () => const PositionerArea();
}
