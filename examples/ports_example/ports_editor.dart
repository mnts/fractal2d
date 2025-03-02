import '/diagram_editor.dart';
import '/ports_example/policy/policy_set.dart';
import '/ports_example/widget/port_switch.dart';
import 'package:flutter/material.dart';

class PortsDiagramEditor extends StatefulWidget {
  @override
  _PortsDiagramEditorState createState() => _PortsDiagramEditorState();
}

class _PortsDiagramEditorState extends State<PortsDiagramEditor> {
  MyPolicySet myPolicySet = MyPolicySet();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Padding(
                padding: EdgeInsets.all(16),
                child: DiagramEditor(
                  diagramEditorContext: DiagramEditorContext(
                    policySet: myPolicySet,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () => myPolicySet.deleteAllComponents(),
                  child: Container(
                    width: 80,
                    height: 32,
                    color: Colors.red,
                    child: Center(child: Text('delete all')),
                  ),
                ),
              ),
              PortSwitch(policySet: myPolicySet),
              Positioned(
                bottom: 8,
                left: 8,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      SizedBox(width: 8),
                      Text('BACK TO MENU'),
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
