//import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider, Consumer, Provider;
import 'package:flutter_map/flutter_map.dart';
import 'package:fractal2d/init.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:provider/provider.dart' show Provider, Consumer;
import '../policy/base/policy_set.dart';
import '../policy/defaults/canvas_control_policy.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DiagramEditorCanvas extends StatefulWidget {
  /// The canvas where all components and links are shown on.
  final CanvasMix fractal;

  /// Map configuration
  final bool showMap;
  final String? mapTileProvider;
  final LatLng mapCenter;
  final double mapZoom;

  ///
  const DiagramEditorCanvas(
    this.fractal, {
    super.key,
    this.showMap = false,
    this.mapTileProvider,
    this.mapCenter = const LatLng(0, 0),
    this.mapZoom = 1,
  });

  @override
  _DiagramEditorCanvasState createState() => _DiagramEditorCanvasState();
}

class _DiagramEditorCanvasState extends State<DiagramEditorCanvas>
    with TickerProviderStateMixin {
  late final PolicySet policy = MyPolicySet(
    model: widget.fractal,
    ticker: this,
  );

  @override
  void initState() {
    //widget.policy.model.addListener(refresh);
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    //widget.policy.model.removeListener(refresh);
    //(withControlPolicy as CanvasControlPolicy?)?.disposeAnimationController();
    super.dispose();
  }

  List<Widget> showComponents(Iterable<ComponentFractal> list) {
    var zOrderedComponents = list.whereType<ComponentFractal>();
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

  List<Widget> showLinks(Iterable<LinkFractal> list) => [
        for (final link in list)
          if (link.linkPoints.length > 1)
            Provide(
              link,
              (ctx, ch) => Link(
                link,
                key: link.widgetKey('canvas'),
              ),
            ),
      ];

  List<Widget> showOtherWithComponentFractalUnder(
    Iterable<ComponentFractal> list,
  ) {
    return list
        .map(
          (data) => policy.showCustomWidgetWithComponentFractalUnder(
            context,
            data,
          ),
        )
        .toList();
  }

  List<Widget> showOtherWithComponentFractalOver(
    Iterable<ComponentFractal> list,
  ) {
    return list
        .map(
          (data) => Provide(
            data,
            (ctx, ch) => policy.showCustomWidgetWithComponentFractalOver(
              context,
              data,
            ),
          ),
        )
        .toList();
  }

  List<Widget> showBackgroundWidgets() {
    return [
      ...policy.showCustomWidgetsOnCanvasBackground(context),
    ];
  }

  List<Widget> showForegroundWidgets() {
    return policy.showCustomWidgetsOnCanvasForeground(context);
  }

  Widget stack() {
    return Listen(policy.model, (ctx, child) {
      final links = <LinkFractal>[];
      final components = <ComponentFractal>[];
      for (var f in policy.model.list) {
        switch (f) {
          case ComponentFractal f:
            components.add(f);
          case LinkFractal f:
            links.add(f);
        }
      }
      return Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          ...showBackgroundWidgets(),
          ...showOtherWithComponentFractalUnder(components),
          ...showComponents(components),
          ...showLinks(links),
          ...showOtherWithComponentFractalOver(components),
          ...showForegroundWidgets(),
          //if (app.position.x != 0 || app.position.y != 0) OptionsArea()
        ],
      );
    });
  }

  Widget canvas() {
    if (policy case CanvasControlPolicy cp) {
      return Listen(
        policy.state,
        (ctx, ch) => AnimatedBuilder(
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
        ),
      );
    } else {
      return stack();
    }
  }

  Offset? taped;
  onTap(TapUpDetails details) {
    setState(() {
      taped = taped == null ? details.localPosition : null;
    });
  }

  unTap() {
    if (taped != null) {
      setState(() {
        taped = null;
      });
    }
  }

  Widget displayTap() {
    /*
    policy.state.fromCanvasCoordinates(
      details.localPosition.f,
    );
    */
    final o = taped!;

    return Positioned(
      top: o.dy - 64,
      left: o.dx - 64,
      child: Container(
        height: 128,
        width: 128,
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(128),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(4),
        child: ListView(
          children: [
            Text(
              '${o.dx.ceil()} x ${o.dy.ceil()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              //scrollDirection: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: () {
                    if (policy case MyCanvasPolicy myPolicy) {
                      myPolicy.putImage(o);
                      unTap();
                    }
                  },
                  icon: const Icon(
                    Icons.image,
                  ),
                ),
                IconButton.filled(
                  onPressed: () {
                    if (policy case MyCanvasPolicy myPolicy) {
                      myPolicy.putComponent(
                        position: o,
                      );
                      unTap();
                    }
                  },
                  icon: const Icon(
                    Icons.square_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //static GlobalKey canvasGlobalKey = GlobalKey();

  final mapCtrl = MapController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: Stack(
            children: [
              InteractiveViewer(
                child: AbsorbPointer(
                  absorbing: false, //policy.state.shouldAbsorbPointer,
                  child: Listener(
                    onPointerSignal: (d) => policy.onCanvasPointerSignal(d),
                    child: GestureDetector(
                      child: Container(
                        color: Colors.grey.shade100.withAlpha(256),
                        child: Watch(
                          widget.fractal,
                          (ctx, child) => Watch(
                            policy,
                            (ctx, ch) => canvas(),
                          ),
                        ),
                      ),
                      onScaleStart: (d) {
                        unTap();
                        policy.onCanvasScaleStart(d);
                      },
                      onScaleUpdate: (d) => policy.onCanvasScaleUpdate(d),
                      onScaleEnd: (d) => policy.onCanvasScaleEnd(d),
                      onTap: () {
                        policy.onCanvasTap();
                      },
                      onTapDown: (d) {
                        policy.onCanvasTapDown(d);
                      },
                      onTapUp: (d) => onTap(d),
                      onTapCancel: () => policy.onCanvasTapCancel(),
                      onLongPress: () => policy.onCanvasLongPress(),
                      onLongPressStart: (d) => policy.onCanvasLongPressStart(d),
                      onLongPressMoveUpdate: (d) =>
                          policy.onCanvasLongPressMoveUpdate(d),
                      onLongPressEnd: (d) => policy.onCanvasLongPressEnd(d),
                      onLongPressUp: () => policy.onCanvasLongPressUp(),
                    ),
                  ),
                ),
              ),
              if (taped != null) displayTap(),
            ],
          ),
        );
      },
    );
  }
}
