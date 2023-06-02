import '/diagram_editor.dart';
import 'package:flutter/material.dart';

class ImageBody extends StatefulWidget {
  final ComponentData componentData;

  const ImageBody({
    super.key,
    required this.componentData,
  });

  @override
  _ImageBodyState createState() => _ImageBodyState();
}

class _ImageBodyState extends State<ImageBody> {
  ComponentData get componentData => widget.componentData;

  //final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: componentData.data.color,
        image: componentData.data.image != null
            ? DecorationImage(
                image: componentData.data.image,
                fit: BoxFit.cover,
              )
            : null,
        /*
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: componentData.data.borderColor,
            spreadRadius: 2,
            blurRadius: componentData.data.borderWidth,
            offset: const Offset(2, 2),
          ),
        ],
        */
      ),
    );
  }
}
