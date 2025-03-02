import 'package:fractal/fractal.dart';
import 'package:signed_fractal/signed_fractal.dart';
import '../models/product.dart';

class ProductCtrl extends NodeCtrl<ProductFractal> {
  ProductCtrl({
    super.name = 'product',
    required super.make,
    required super.extend,
    required super.attributes,
  });

  @override
  final icon = IconF(0xe8cc); // Shopping cart icon
}
