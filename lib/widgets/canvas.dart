import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider, Consumer, Provider;
import 'package:fractal2d/simple_diagram_editor/widget/options.dart';
import '../providers/app.dart';
import '../providers/positioner.dart';
import '/abstraction_layer/policy/base/policy_set.dart';
import '/abstraction_layer/policy/defaults/canvas_control_policy.dart';
import '/canvas_context/canvas_model.dart';
import '/canvas_context/canvas_state.dart';
import '../models/component.dart';
import '/models/link_data.dart';
import 'component.dart';
import 'link.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fractal_flutter/fractal_flutter.dart';

class DiagramEditorCanvas extends ConsumerStatefulWidget {
  /// The canvas where all components and links are shown on.
  const DiagramEditorCanvas({
    Key? key,
  });

  @override
  _DiagramEditorCanvasState createState() => _DiagramEditorCanvasState();
}

class _DiagramEditorCanvasState extends ConsumerState<DiagramEditorCanvas>
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
        (componentData) => FChangeNotifierProvider<ComponentData>.value(
          value: componentData,
          child: Component(),
        ),
      ),
    ];
  }

  List<Widget> showLinks(CanvasModel canvasModel) {
    return canvasModel.links.values.map((LinkData linkData) {
      return ChangeNotifierProvider<LinkData>.value(
        value: linkData,
        child: Link(),
      );
    }).toList();
  }

  List<Widget> showOtherWithComponentDataUnder(CanvasModel canvasModel) {
    return canvasModel.components.values.map((ComponentData componentData) {
      return FChangeNotifierProvider<ComponentData>.value(
        value: componentData,
        builder: (context, child) {
          return Consumer<ComponentData>(
            builder: (context, data, child) {
              return policy.showCustomWidgetWithComponentDataUnder(
                  context, data);
            },
          );
        },
      );
    }).toList();
  }

  List<Widget> showOtherWithComponentDataOver(CanvasModel canvasModel) {
    return canvasModel.components.values.map((ComponentData componentData) {
      return FChangeNotifierProvider<ComponentData>.value(
        value: componentData,
        builder: (context, child) {
          return Consumer<ComponentData>(
            builder: (context, data, child) {
              return policy.showCustomWidgetWithComponentDataOver(
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
    final position = ref.watch(Positioner.provider);

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        ...showBackgroundWidgets(),
        ...showOtherWithComponentDataUnder(canvasModel),
        ...showComponents(canvasModel),
        ...showLinks(canvasModel),
        ...showOtherWithComponentDataOver(canvasModel),
        ...showForegroundWidgets(),
        if (position.x != 0 || position.y != 0) const OptionsArea()
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

  late PolicySet policy;
  @override
  Widget build(BuildContext context) {
    final ctx = ref.read(editorContextProvider);
    policy = ctx.policySet;
    init();
    final canvasModel = Provider.of<CanvasModel>(context);
    final canvasState = Provider.of<CanvasState>(context);

    return RepaintBoundary(
      key: canvasState.canvasGlobalKey,
      child: AbsorbPointer(
        absorbing: canvasState.shouldAbsorbPointer,
        child: Listener(
          onPointerSignal: (PointerSignalEvent event) =>
              policy.onCanvasPointerSignal(event),
          child: GestureDetector(
            child: Container(
              color: canvasState.color,
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
            onTapDown: (TapDownDetails details) =>
                policy.onCanvasTapDown(details),
            onTapUp: (TapUpDetails details) => policy.onCanvasTapUp(details),
            onTapCancel: () => policy.onCanvasTapCancel(),
            onLongPress: () => policy.onCanvasLongPress(),
            onLongPressStart: (LongPressStartDetails details) =>
                policy.onCanvasLongPressStart(details),
            onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) =>
                policy.onCanvasLongPressMoveUpdate(details),
            onLongPressEnd: (LongPressEndDetails details) =>
                policy.onCanvasLongPressEnd(details),
            onLongPressUp: () => policy.onCanvasLongPressUp(),
          ),
        ),
      ),
    );
  }
}
