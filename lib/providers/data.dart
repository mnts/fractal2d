import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/component.dart';

final componentDataProvider = Provider<ComponentData>((ref) {
  return ComponentData();
});
