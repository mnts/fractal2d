import 'package:app_fractal/index.dart';
import 'package:fractal_layout/layout.dart';
import '../lib/policy/main/set.dart';
import '../lib/widgets/index.dart';
import 'package:flutter/material.dart' hide Color;

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
  static final name = 'mant.${FileF.host}';

  final app = await AppFractal.byDomain(name) ?? AppFractal.main;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    //policy.refer(ref);
    super.initState();
  }

  @override
  Widget build(context) {
    return FractalLayout<AppFractal>(
      app,
      actions: [
        /*
        Tooltip(
          message:
              """
Invest particular amount to 
further develop this system 
and you will be contacted
to discuss cooperation""",
          child: InkWell(
            onTap: () {
              launchUrl(
                Uri.parse('https://paypal.me/mntas/88'),
              );
            },
            child: const Text(
              'Invest',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
        ),
        */
      ],
    );
    /*
    return Scaffold(
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
        //shadowColor: Color.fromRGB(128, 128, 128, 128),
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
    );
    */
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
          icon: const Icon(
            Icons.all_inclusive,
          ),
          onPressed: () => myPolicySet.selectAll(),
        ),
        IconButton(
          tooltip: 'duplicate selected',
          icon: const Icon(
            Icons.copy,
          ),
          onPressed: () => myPolicySet.duplicateSelected(),
        ),
        IconButton(
          tooltip: 'remove selected',
          icon: const Icon(
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
