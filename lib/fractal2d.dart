import 'package:app_fractal/index.dart';

final NetworkFractal network = NetworkFractal.fromMap({
  'name': FileF.host,
  'kind': 3,
  'pubkey': '',
})
  ..synch()
  ..preload();

class Fractal2d {}
