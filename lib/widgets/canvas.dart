//import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider, Consumer, Provider;
import 'package:fractal2d/policy/defaults/canvas_move.dart';
import 'package:fractal_flutter/extensions/index.dart';
import 'package:fractal_flutter/fractal_flutter.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:fractals2d/models/component.dart';
import 'package:fractals2d/models/link_data.dart';
import 'package:fractals2d/models/state.dart';
import 'package:provider/provider.dart';
import '../policy/base/policy_set.dart';
import '../policy/defaults/canvas_control_policy.dart';
import 'component.dart';
import 'link.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DiagramEditorCanvas extends StatefulWidget {
  /// The canvas where all components and links are shown on.
  const DiagramEditorCanvas({
    super.key,
  });

  @override
  _DiagramEditorCanvasState createState() => _DiagramEditorCanvasState();
}

class _DiagramEditorCanvasState extends State<DiagramEditorCanvas>
    with TickerProviderStateMixin {
  PolicySet? withControlPolicy;

  bool ready = false;
  void init() {
    if (ready) return;
    withControlPolicy =
        (policy is CanvasControlPolicy || policy is CanvasMovePolicy)
            ? policy
            : null;

    (withControlPolicy as CanvasControlPolicy?)?.setAnimationController(
      AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      ),
    );
  }

  @override
  void dispose() {
    (withControlPolicy as CanvasControlPolicy?)?.disposeAnimationController();
    super.dispose();
  }

  List<Widget> showComponents(CanvasMix canvasModel) {
    var zOrderedComponents = canvasModel.components.toList();
    zOrderedComponents.sort((a, b) => a.zOrder.compareTo(b.zOrder));

    return [
      ...zOrderedComponents.map(
        (componentData) => FChangeNotifierProvider<ComponentFractal>.value(
          key: Key('FCNP_${componentData.path}'),
          value: componentData,
          child: Component(
            key: componentData.widgetKey('canvas'),
          ),
        ),
      ),
    ];
  }

  List<Widget> showLinks(CanvasMix canvasModel) {
    return [
      for (final link in canvasModel.links)
        if (link.linkPoints.length > 1)
          FChangeNotifierProvider<LinkFractal>.value(
            value: link,
            key: Key('Link_${link.path}'),
            child: Link(
              key: link.widgetKey('canvas'),
            ),
          )
    ];
  }

  List<Widget> showOtherWithComponentFractalUnder(CanvasMix canvasModel) {
    return canvasModel.components.map((ComponentFractal componentData) {
      return FChangeNotifierProvider<ComponentFractal>.value(
        value: componentData,
        builder: (context, child) {
          return Consumer<ComponentFractal>(
            builder: (context, data, child) {
              return policy.showCustomWidgetWithComponentFractalUnder(
                  context, data);
            },
          );
        },
      );
    }).toList();
  }

  List<Widget> showOtherWithComponentFractalOver(CanvasMix canvasModel) {
    return canvasModel.components.map((ComponentFractal componentData) {
      return FChangeNotifierProvider<ComponentFractal>.value(
        value: componentData,
        builder: (context, child) {
          return Consumer<ComponentFractal>(
            builder: (context, data, child) {
              return policy.showCustomWidgetWithComponentFractalOver(
                  context, data);
            },
          );
        },
      );
    }).toList();
  }

  List<Widget> showBackgroundWidgets() {
    return policy.showCustomWidgetsOnCanvasBackground(context);
  }

  List<Widget> showForegroundWidgets() {
    return policy.showCustomWidgetsOnCanvasForeground(context);
  }

  Widget canvasStack(CanvasMix canvasModel) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        ...showBackgroundWidgets(),
        ...showOtherWithComponentFractalUnder(canvasModel),
        ...showComponents(canvasModel),
        ...showLinks(canvasModel),
        ...showOtherWithComponentFractalOver(canvasModel),
        ...showForegroundWidgets(),
        //if (app.position.x != 0 || app.position.y != 0) OptionsArea()
      ],
    );
  }

  Widget canvasAnimated(CanvasMix canvasModel) {
    return AnimatedBuilder(
      animation:
          (withControlPolicy as CanvasControlPolicy).getAnimationController(),
      builder: (BuildContext context, Widget? child) {
        (withControlPolicy as CanvasControlPolicy).canUpdateCanvasModel = true;
        return Transform(
          transform: Matrix4.identity()
            ..translate(
                (withControlPolicy as CanvasControlPolicy).transformPosition.dx,
                (withControlPolicy as CanvasControlPolicy).transformPosition.dy)
            ..scale((withControlPolicy as CanvasControlPolicy).transformScale),
          child: child,
        );
      },
      child: canvasStack(canvasModel),
    );
  }

  static GlobalKey canvasGlobalKey = GlobalKey();

  late PolicySet policy;

  @override
  Widget build(BuildContext context) {
    policy = context.read<PolicySet>();
    init();
    final canvasModel = Provider.of<CanvasMix>(context);
    final canvasState = Provider.of<CanvasState>(context);

    return RepaintBoundary(
      key: canvasGlobalKey,
      child: AbsorbPointer(
        absorbing: canvasState.shouldAbsorbPointer,
        child: Listener(
          onPointerSignal: (PointerSignalEvent event) =>
              policy.onCanvasPointerSignal(event),
          child: GestureDetector(
            child: ClipRect(
              child: (withControlPolicy != null)
                  ? canvasAnimated(canvasModel)
                  : canvasStack(canvasModel),
            ),
            onScaleStart: (details) => policy.onCanvasScaleStart(details),
            onScaleUpdate: (details) => policy.onCanvasScaleUpdate(details),
            onScaleEnd: (details) => policy.onCanvasScaleEnd(details),
            onTap: () => policy.onCanvasTap(),
            onTapDown: (details) => policy.onCanvasTapDown(details),
            onTapUp: (details) => policy.onCanvasTapUp(details),
            onTapCancel: () => policy.onCanvasTapCancel(),
            onLongPress: () => policy.onCanvasLongPress(),
            onLongPressStart: (details) =>
                policy.onCanvasLongPressStart(details),
            onLongPressMoveUpdate: (details) =>
                policy.onCanvasLongPressMoveUpdate(details),
            onLongPressEnd: (details) => policy.onCanvasLongPressEnd(details),
            onLongPressUp: () => policy.onCanvasLongPressUp(),
          ),
        ),
      ),
    );
  }
}
