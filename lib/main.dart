import 'package:app_fractal/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fractal/c.dart';
import 'package:fractal2d/lib.dart';
import 'package:fractal_flutter/app.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/models/ui.dart';
import 'package:fractal_layout/routes/index.dart' as Routes;
import 'package:fractal_layout/screens/fscreen.dart';
import 'package:go_router/go_router.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:path_provider/path_provider.dart';
import 'package:fractal_base/fractals/device.dart';
import 'package:fractal_socket/index.dart';

import 'fractal2d.dart';

void main() async {
  FileF.isSecure = true;
  FileF.host =
      (kIsWeb && Uri.base.host != 'localhost') ? Uri.base.host : 'ego.bio';

  final d = [...FileF.host.split('.').reversed];
  FileF.main = d.length == 1 ? d[0] : '${d[1]}.${d[0]}';

  //AppWallF.provider = Provider<NftMillionApp>((ref) => NftMillionApp(ref));
  //FileF.path = '';
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    FileF.path = (await getApplicationDocumentsDirectory()).path;
  }

  await DBF.initiate();

  await SignedFractal.init();
  await AppFractal.init();
  await DiagramAppFractal.prepare();

  NetworkFractal.active = NetworkFractal.fromMap({
    'name': FileF.host,
    'createdAt': 2,
    'pubkey': '',
  })
    ..synch()
    ..preload();

  Fractal.maps['screens'] = UIF.map;
  FractalC.options['tiles'] = FractalTile.options;

  //runServer(8810);

  final app = AppFractal.active = AppFractal.fromDomain(FileF.host);

  runApp(
    FractalApp(
      child: FractalLayout(
        app,
        title: const Text('fractal'),
        routes: [
          GoRoute(
            path: '/_logs',
            builder: (context, state) => FractalScaffold(
              body: FScreen(
                StreamArea(
                  fractal: CatalogFractal(
                    filter: {},
                    source: WriterFractal.controller,
                    limit: 200,
                  ),
                ),
              ),
            ),
          ),
          Routes.hashRoute,
          /*
        GoRoute(
          path: '/@:name',
          builder: (context, state) {
            final name = state.pathParameters['name'] ??
                UserFractal.active.value?.name ??
                '';

            final path = state.uri.toString();
            return UserRoute(key: Key(path), name: name);
          },
        ),
        */
        ],
      ),
    ),
  );
}
