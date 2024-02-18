import 'package:app_fractal/index.dart';

final NetworkFractal network = NetworkFractal.fromMap({
  'name': FileF.host,
  'createdAt': 2,
  'pubkey': '',
})
  ..synch()
  ..preload();

class Fractal2d {}
