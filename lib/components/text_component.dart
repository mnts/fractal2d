import 'dart:typed_data';

import 'package:fractal/data.dart';
import 'package:fractals2d/models/component.dart';
import 'package:flutter/material.dart';
import 'package:signed_fractal/models/event.dart';

class TextBody extends StatefulWidget {
  final ComponentFractal component;

  const TextBody({
    super.key,
    required this.component,
  });

  @override
  _TextBodyState createState() => _TextBodyState();
}

class _TextBodyState extends State<TextBody> {
  ComponentFractal get component => widget.component;

  final _ctrl = TextEditingController();
  @override
  void initState() {
    _ctrl.text = content;
    checkImage();
    super.initState();
  }

  bool loading = false;
  checkImage() {
    if (component.dataHash is! String) return;
    EventFractal.request(component.dataHash!).then((d) {
      d.file?.load().then((bytes) {
        setState(() {
          image = DecorationImage(
            fit: BoxFit.cover,
            image: MemoryImage(bytes),
          );
        });
      });
    });
  }

  EventFractal? get data => component.data;
  String get content => data?.content ?? '';

  DecorationImage? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            Colors.grey.shade500.withOpacity(0.5), //component.color.toMaterial,
        borderRadius: BorderRadius.circular(8),
        image: image,

        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .canvasColor, //component.borderColor.toMaterial,
            spreadRadius: 1,
            blurRadius: 8, //component.borderWidth,
            offset: Offset(1, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      child: true
          ? null
          : Column(
              children: [
                Container(
                  height: 20,
                  //color: Colors.grey.withOpacity(0.8),
                  child: TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.7)),
                    /*'${data?.toMap()}' ?? */ initialValue:
                        data?.file?.name ?? '',
                  ),
                ),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    scrollPadding: EdgeInsets.all(8),
                    expands: true,
                    maxLines: null,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
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
