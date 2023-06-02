import '../../components/image_component.dart';
import '../../components/text_component.dart';
import '/diagram_editor.dart';
import '../../components/bean_component.dart';
import '../../components/bean_left_component.dart';
import '../../components/bean_right_component.dart';
import '../../components/bend_left_component.dart';
import '../../components/bend_right_component.dart';
import '../../components/crystal_component.dart';
import '../../components/document_component.dart';
import '../../components/hexagon_horizontal_component.dart';
import '../../components/hexagon_vertical_component.dart';
import '../../components/no_corner_rect_component.dart';
import '../../components/oval_component.dart';
import '../../components/rect_component.dart';
import '../../components/rhomboid_component.dart';
import '../../components/round_rect_component.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  final builders = <String, Widget Function(ComponentData)>{};
  @override
  Widget showComponentBody(ComponentData componentData) {
    final builder = builders[componentData.type];
    if (builder != null) return builder(componentData);
    switch (componentData.type) {
      case 'image':
        return ImageBody(componentData: componentData);
      case 'text':
        return TextBody(componentData: componentData);
      case 'rect':
        return RectBody(componentData: componentData);
      case 'round_rect':
        return RoundRectBody(componentData: componentData);
      case 'oval':
        return OvalBody(componentData: componentData);
      case 'crystal':
        return CrystalBody(componentData: componentData);
      case 'body':
        return RectBody(componentData: componentData);
      case 'rhomboid':
        return RhomboidBody(componentData: componentData);
      case 'bean':
        return BeanBody(componentData: componentData);
      case 'bean_left':
        return BeanLeftBody(componentData: componentData);
      case 'bean_right':
        return BeanRightBody(componentData: componentData);
      case 'document':
        return DocumentBody(componentData: componentData);
      case 'hexagon_horizontal':
        return HexagonHorizontalBody(componentData: componentData);
      case 'hexagon_vertical':
        return HexagonVerticalBody(componentData: componentData);
      case 'bend_left':
        return BendLeftBody(componentData: componentData);
      case 'bend_right':
        return BendRightBody(componentData: componentData);
      case 'no_corner_rect':
        return NoCornerRectBody(componentData: componentData);
      case 'junction':
        return OvalBody(componentData: componentData);
      default:
        return Text('error');
    }
  }
}
