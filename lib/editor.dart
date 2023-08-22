import 'dart:ui';
import 'package:fractal2d/apps/diagram.dart';
import 'package:fractal_flutter/fractal_flutter.dart';
import 'package:provider/provider.dart';
import 'widgets/editor.dart';
import 'policy/main/my_policy_set.dart';
import 'widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:fractal_flutter/fractal_flutter.dart';

class FractalDiagram extends StatefulWidget {
  const FractalDiagram({super.key});

  @override
  State<FractalDiagram> createState() => _FractalDiagramState();
}

class _FractalDiagramState extends State<FractalDiagram> {
  //late DiagramEditorContext diagramEditorContextMiniMap;

  //MiniMapPolicySet miniMapPolicySet = MiniMapPolicySet();

  //bool isMiniMapVisible = true;
  //bool isMenuVisible = true;
  //bool isOptionsVisible = true;

  late DiagramAppFractal app;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final policy = MyPolicySet();

  @override
  void initState() {
    //policy.refer(ref);
    app = DiagramAppFractal(
      policy: policy,
    );
    super.initState();
  }

  @override
  Widget build(context) {
    return MaterialApp(
      // showPerformanceOverlay: !kIsWeb,
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        canvasColor: Colors.white.withOpacity(0.7),
      ),
      home: Scaffold(
        key: _scaffoldKey,
        drawer: buildDrawer(policy),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Fractal 2D'),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.blue.withAlpha(130),
              ),
            ),
          ),
          shadowColor: const Color.fromARGB(128, 128, 128, 128),
          backgroundColor: Colors.transparent,
          actions: _actions(policy),
        ),
        body: Watch(
          app,
          (ctx, child) => DiagramEditor(),
        ),
        /*
            Positioned(
              right: 16,
              top: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible: isMiniMapVisible,
                    child: Container(
                      width: 320,
                      height: 240,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.black,
                          width: 2,
                        )),
                        child: DiagramEditor(
                          diagramEditorContext: diagramEditorContextMiniMap,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            */
      ),
    );
  }

  List<Widget> _actions(MyPolicySet myPolicySet) => [
        IconButton(
          tooltip: 'reset view',
          icon: const Icon(
            Icons.replay,
          ),
          onPressed: () => myPolicySet.resetView(),
        ),
        IconButton(
          tooltip: myPolicySet.isGridVisible ? 'hide grid' : 'show grid',
          icon: Icon(
            myPolicySet.isGridVisible ? Icons.grid_off : Icons.grid_on,
          ),
          onPressed: () {
            myPolicySet.isGridVisible = !myPolicySet.isGridVisible;
          },
        ),
        IconButton(
          tooltip: 'select all',
          icon: Icon(
            Icons.all_inclusive,
          ),
          onPressed: () => myPolicySet.selectAll(),
        ),
        IconButton(
          tooltip: 'duplicate selected',
          icon: Icon(
            Icons.copy,
          ),
          onPressed: () => myPolicySet.duplicateSelected(),
        ),
        IconButton(
          tooltip: 'remove selected',
          icon: Icon(
            Icons.delete,
          ),
          onPressed: () => myPolicySet.removeSelected(),
        ),
        IconButton(
          tooltip: myPolicySet.isMultipleSelectionOn
              ? 'cancel multiselection'
              : 'enable multiselection',
          icon: Icon(
            myPolicySet.isMultipleSelectionOn
                ? Icons.group_work
                : Icons.group_work_outlined,
          ),
          onPressed: () {
            //setState(() {
            if (myPolicySet.isMultipleSelectionOn) {
              myPolicySet.turnOffMultipleSelection();
            } else {
              myPolicySet.turnOnMultipleSelection();
            }
            //});
          },
        ),
        /*
        IconButton(
          onPressed: () {
            setState(() {
              isMiniMapVisible = !isMiniMapVisible;
            });
          },
          icon: Icon(isMiniMapVisible ? Icons.map_outlined : Icons.map),
        ),
        */
      ];

  bool pressDrawer = false;
  Widget buildDrawer(MyPolicySet myPolicySet) {
    return Drawer(
      child: Listener(
        onPointerDown: (_) {
          pressDrawer = true;
        },
        onPointerMove: (_) {
          if (pressDrawer == false) return;
          _scaffoldKey.currentState?.closeDrawer();
          pressDrawer = false;
        },
        child: DraggableMenu(myPolicySet: myPolicySet),
      ),
    );
  }
}
