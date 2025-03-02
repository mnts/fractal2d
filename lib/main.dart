import 'package:flutter/material.dart';
import 'package:fractal_layout/widget.dart';
import 'init.dart';
import 'package:fractal_layout/routes/index.dart' as routes;

void main() async {
  /*
  PlatformDispatcher.instance.onError = (error, stack) {
    FSys.error('$error');w
    return true;
  };
  */

  await FractalSystem.initUI(
    host: 'fractal.bond',
  );

  await F2dScheme().init();

  await DiagramAppFractal.prepare();
  await ServicesF.init();
  await UIF.init();
  //runServer(8810);

  //NetworkFractal.active = null;

  final router = GoRouter(
    routes: [
      routes.home,
      routes.auth,
      //routes.chatHome,
      //routes.chat,
      routes.hashRoute,
      routes.profile,
    ],
  );

  //FractalScaffoldState.menu = MapRoute.nav;

  runApp(
    FractalSystem(
      child: FractalLayout(
        AppFractal.active,
        title: const Text('fractal'),
        router: router,
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
