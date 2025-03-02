import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'providers.dart';
import 'index.dart';

class MapLayer extends StatelessWidget {
  final TransformationController transformationController;
  final String tileProvider;
  final LatLng center;
  final double zoom;

  const MapLayer({
    super.key,
    required this.transformationController,
    this.tileProvider = FTileProviders.osm,
    this.center = const LatLng(0, 0),
    this.zoom = 1,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: tileProvider,
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.app',
        ),
      ],
    );
  }
}
