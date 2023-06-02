import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppFractal {
  //ChangeNotifier stuff;
  static var provider = Provider(
    (ref) => AppFractal(),
  );
}
