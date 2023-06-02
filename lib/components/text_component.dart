import '/diagram_editor.dart';
import 'package:flutter/material.dart';

class TextBody extends StatefulWidget {
  final ComponentData componentData;

  const TextBody({
    super.key,
    required this.componentData,
  });

  @override
  _TextBodyState createState() => _TextBodyState();
}

class _TextBodyState extends State<TextBody> {
  ComponentData get componentData => widget.componentData;

  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: componentData.data.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: componentData.data.borderColor,
            spreadRadius: 1,
            blurRadius: componentData.data.borderWidth,
            offset: Offset(1, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _ctrl,
              expands: true,
              maxLines: null,
              style: TextStyle(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter text',
                hintStyle: TextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
