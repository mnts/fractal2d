import 'package:app_fractal/app.dart';
import 'package:currency_fractal/fractals/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fractal2d/lib.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/routes/index.dart' as routes;
import 'package:signed_fractal/signed_fractal.dart';
import 'package:signed_fractal/sys.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:path_provider/path_provider.dart';
import 'package:color/color.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  /*
  PlatformDispatcher.instance.onError = (error, stack) {
    FSys.error('$error');
    return true;
  };
  */

  FileF.isSecure = true;
  //const domain = 'ryde.quest';
  FileF.host = ((kIsWeb && Uri.base.host != 'localhost')
          ? Uri.base.host
          //: '45.33.0.98:2415') *
          : 'chats.xnests.com'
      //'localhost:2415'
      )
      .replaceFirst('.beta', '');

  final d = [...FileF.host.split('.').reversed];
  FileF.main = d.length == 1 ? d[0] : '${d[1]}.${d[0]}';

  AppFractal.defaultOnlyAuthorized = false;
  AppFractal.defaultColor = const Color.rgb(10, 45, 155);
  //AppFractal.defaultColor = const Color.rgb(67, 20, 90);
  //AppFractal.defaultColor = const Color.rgb(210, 120, 20);
  //AppWallF.provider = Provider<NftMillionApp>((ref) => NftMillionApp(ref));
  //FileF.path = '';
  WidgetsFlutterBinding.ensureInitialized();

  if ((Platform.isAndroid || Platform.isIOS) && !kIsWeb) {
    FileF.path = (await getApplicationDocumentsDirectory()).path;
  }
  print(FileF.path);

  await DBF.initiate();

  await SignedFractal.init();
  await AppFractal.init();
  await TransactionFractal.controller.init();
  await DiagramAppFractal.prepare();

  final map = EventFractal.map.map;

  await FSys.setup();
  map['network'] = NetworkFractal.active = await NetworkFractal.controller.put({
    'name': FileF.host,
    'kind': 3,
    'pubkey': '',
  });
  await NetworkFractal.active!.synch();

  map['app'] = AppFractal.main = await AppFractal.controller.put({
    'name': FileF.host,
    'kind': 3,
    'owner': '',
  });
  await AppFractal.main.synch();

  AppFractal.active = AppFractal.fromDomain(FileF.host);

  UIF.init();

  //runServer(8810);

  runApp(
    FractalSystem(
      child: FractalLayout(
        AppFractal.active,
        title: const Text('fractal'),
        routes: [
          //routes.home,
          routes.chatHome,
          routes.chat,
          routes.hashRoute,
          routes.profileRoute,
        ],
      ),
    ),
  );
}

/*
+370 52362444
           00

+370 52717112


+370 52362626
     52362444
*/
