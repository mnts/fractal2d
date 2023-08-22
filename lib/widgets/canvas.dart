//import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider, Consumer, Provider;
import 'package:fractal2d/extensions/color.dart';
import 'package:fractal2d/policy/defaults/canvas_move.dart';
import 'package:fractal2d/widgets/options.dart';
import 'package:fractals2d/models/canvas.dart';
import 'package:fractals2d/models/component.dart';
import 'package:fractals2d/models/link_data.dart';
import 'package:fractals2d/models/state.dart';
import '../apps/diagram.dart';
import '../policy/base/policy_set.dart';
import '../policy/defaults/canvas_control_policy.dart';
import 'component.dart';
import 'link.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fractal_flutter/fractal_flutter.dart';

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

  List<Widget> showComponents(CanvasModel canvasModel) {
    var zOrderedComponents = canvasModel.components.values.toList();
    zOrderedComponents.sort((a, b) => a.zOrder.compareTo(b.zOrder));

    return [
      ...zOrderedComponents.map(
        (componentData) => FChangeNotifierProvider<ComponentFractal>.value(
          key: Key('FCNP_${componentData.path}'),
          value: componentData,
          child: Component(
            key: Key(
              componentData.path,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> showLinks(CanvasModel canvasModel) {
    return canvasModel.links.values.map((LinkFractal linkData) {
      return FChangeNotifierProvider<LinkFractal>.value(
        value: linkData,
        child: Link(),
      );
    }).toList();
  }

  List<Widget> showOtherWithComponentFractalUnder(CanvasModel canvasModel) {
    return canvasModel.components.values.map((ComponentFractal componentData) {
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

  List<Widget> showOtherWithComponentFractalOver(CanvasModel canvasModel) {
    return canvasModel.components.values.map((ComponentFractal componentData) {
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

  Widget canvasStack(CanvasModel canvasModel) {
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

  Widget canvasAnimated(CanvasModel canvasModel) {
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

  late DiagramAppFractal app;

  late PolicySet policy;
  @override
  Widget build(BuildContext context) {
    app = context.read<DiagramAppFractal>();
    policy = app.policy;
    init();
    final canvasModel = Provider.of<CanvasModel>(context);
    final canvasState = Provider.of<CanvasState>(context);

    return RepaintBoundary(
      key: canvasGlobalKey,
      child: AbsorbPointer(
        absorbing: canvasState.shouldAbsorbPointer,
        child: Listener(
          onPointerSignal: (PointerSignalEvent event) =>
              policy.onCanvasPointerSignal(event),
          child: GestureDetector(
            child: Container(
              color: canvasState.color.toMaterial,
              child: ClipRect(
                child: (withControlPolicy != null)
                    ? canvasAnimated(canvasModel)
                    : canvasStack(canvasModel),
              ),
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
