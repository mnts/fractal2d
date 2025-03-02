import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fractal2d/map/providers.dart';
import 'package:fractal_layout/index.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class MapRoute extends StatelessWidget {
  const MapRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return FractalScaffold(
      body: area,
    );
  }

  Widget get area => FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(34.05736, -118.243683),

          //initialCenter: ll,
          initialZoom: 10,
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

  static Widget get nav => IconButton.filled(
        onPressed: () {},
        icon: Icon(Icons.map),
      );
}
