import 'package:flutter/material.dart';
import 'package:fractal/types/file.dart';
import 'package:fractal2d/diagram_editor.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fractal_socket/index.dart';

void main() async {
  //FileF.path = '/home/mk/Desktop/pub/fractal2d/build/data';

  FileF.isSecure = true;
  FileF.host = (kIsWeb) ? Uri.base.host : 'ego.bio';

  WidgetsFlutterBinding.ensureInitialized();
  await DiagramAppFractal.prepare();

  FClient(
    name: FClient.sid,
  ).connect();

  runApp(
    const FractalDiagram(),
  );
}
