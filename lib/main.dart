import 'package:app_fractal/app.dart';
import 'package:currency_fractal/fractals/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fractal2d/lib.dart';
import 'package:fractal_flutter/app.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/routes/index.dart' as routes;
import 'package:signed_fractal/signed_fractal.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:path_provider/path_provider.dart';
import 'package:color/color.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  FileF.isSecure = true;
  FileF.host = ((kIsWeb && Uri.base.host != 'localhost')
          ? Uri.base.host
          : FileF.isSecure
              ? 'ego.bio'
              : 'localhost:2415')
      .replaceFirst('.beta', '');

  final d = [...FileF.host.split('.').reversed];
  FileF.main = d.length == 1 ? d[0] : '${d[1]}.${d[0]}';

  AppFractal.defaultOnlyAuthorized = false;
  AppFractal.defaultColor = const Color.rgb(100, 45, 155);
  //AppWallF.provider = Provider<NftMillionApp>((ref) => NftMillionApp(ref));
  //FileF.path = '';
  WidgetsFlutterBinding.ensureInitialized();

  if ((Platform.isAndroid || Platform.isIOS) && !kIsWeb) {
    FileF.path = (await getApplicationDocumentsDirectory()).path;
  }

  await DBF.initiate();

  await SignedFractal.init();
  await AppFractal.init();
  await DiagramAppFractal.prepare();
  await TransactionFractal.controller.init();

  UIF.init();

  //runServer(8810);

  AppFractal.active = AppFractal.fromDomain(FileF.host);

  runApp(
    FractalApp(
      child: FractalLayout(
        AppFractal.active,
        title: const Text('fractal'),
        routes: [
          routes.home,
          routes.hashRoute,
          routes.profileRoute,
        ],
      ),
    ),
  );
}
