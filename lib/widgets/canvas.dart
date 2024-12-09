//import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider, Consumer, Provider;
import 'package:fractal2d/policy/defaults/canvas_move.dart';
import 'package:fractal_flutter/extensions/index.dart';
import 'package:fractal_flutter/fractal_flutter.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:fractals2d/models/component.dart';
import 'package:fractals2d/models/link_data.dart';
import 'package:fractals2d/models/state.dart';
import 'package:provider/provider.dart' show Provider, Consumer;
import '../policy/base/policy_set.dart';
import '../policy/defaults/canvas_control_policy.dart';
import 'component.dart';
import 'link.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DiagramEditorCanvas extends StatefulWidget {
  /// The canvas where all components and links are shown on.
  final PolicySet policy;
  const DiagramEditorCanvas(
    this.policy, {
    super.key,
  });

  @override
  _DiagramEditorCanvasState createState() => _DiagramEditorCanvasState();
}

class _DiagramEditorCanvasState extends State<DiagramEditorCanvas>
    with TickerProviderStateMixin {
  PolicySet? withControlPolicy;

  @override
  void initState() {
    init();
    widget.policy.model.addListener(refresh);
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  void init() {
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

  List<Widget> showComponents() {
    var zOrderedComponents = policy.model.components.list;
    //zOrderedComponents.sort((a, b) => a.zOrder.compareTo(b.zOrder));

    return [
      ...zOrderedComponents.map((componentData) {
        //componentData.preload();
        return Component(
          componentData,
          key: componentData.widgetKey('canvas'),
        );
      }),
    ];
  }

  List<Widget> showLinks() => [
        for (final link in policy.model.links.list)
          if (link.linkPoints.length > 1)
            Link(
              link,
              key: link.widgetKey('canvas'),
            )
      ];

  List<Widget> showOtherWithComponentFractalUnder() {
    return policy.model.components.list.map((ComponentFractal componentData) {
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

  List<Widget> showOtherWithComponentFractalOver() {
    return policy.model.components.list.map((ComponentFractal componentData) {
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

  Widget stack() {
    return Listen(
      policy.model.components,
      (ctx, child) => Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          ...showBackgroundWidgets(),
          ...showOtherWithComponentFractalUnder(),
          ...showComponents(),
          ...showLinks(),
          ...showOtherWithComponentFractalOver(),
          ...showForegroundWidgets(),
          //if (app.position.x != 0 || app.position.y != 0) OptionsArea()
        ],
      ),
    );
  }

  Widget canvas() {
    if (withControlPolicy case CanvasControlPolicy cp) {
      return AnimatedBuilder(
        animation: cp.getAnimationController(),
        builder: (BuildContext context, Widget? child) {
          cp.canUpdateCanvasModel = true;

          return Transform(
            transform: Matrix4.identity()
              ..translate(cp.transformPosition.dx, cp.transformPosition.dy)
              ..scale(cp.transformScale),
            child: stack(),
          );

          //child: child,
        },
      );
    } else {
      return stack();
    }
  }

  static GlobalKey canvasGlobalKey = GlobalKey();

  PolicySet get policy => widget.policy;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      //key: canvasGlobalKey,
      child: AbsorbPointer(
        absorbing: false, //policy.state.shouldAbsorbPointer,
        child: Listener(
          onPointerSignal: (d) => policy.onCanvasPointerSignal(d),
          child: GestureDetector(
            child: Watch(
              policy,
              (ctx, ch) => ClipRect(
                child: canvas(),
              ),
            ),
            onScaleStart: (d) => policy.onCanvasScaleStart(d),
            onScaleUpdate: (d) => policy.onCanvasScaleUpdate(d),
            onScaleEnd: (d) => policy.onCanvasScaleEnd(d),
            onTap: () => policy.onCanvasTap(),
            onTapDown: (d) => policy.onCanvasTapDown(d),
            onTapUp: (d) => policy.onCanvasTapUp(d),
            onTapCancel: () => policy.onCanvasTapCancel(),
            onLongPress: () => policy.onCanvasLongPress(),
            onLongPressStart: (d) => policy.onCanvasLongPressStart(d),
            onLongPressMoveUpdate: (d) => policy.onCanvasLongPressMoveUpdate(d),
            onLongPressEnd: (d) => policy.onCanvasLongPressEnd(d),
            onLongPressUp: () => policy.onCanvasLongPressUp(),
          ),
        ),
      ),
    );
  }
}
