import 'dart:typed_data';
import 'dart:ui';

import 'package:app_fractal/screen.dart';
import 'package:fractal/data.dart';
import 'package:fractal2d/diagram_editor.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/areas/screens.dart';
import 'package:fractal_layout/index.dart';
import 'package:fractal_layout/views/index.dart';
import 'package:fractal_layout/widgets/index.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:fractals2d/models/component.dart';
import 'package:flutter/material.dart';
import 'package:signed_fractal/models/event.dart';
import 'package:fractal_layout/builders/screen.dart';
import 'package:signed_fractal/signed_fractal.dart';

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

  @override
  void initState() {
    component.preload();
    checkImage();
    super.initState();
  }

  bool loading = false;
  checkImage() async {
    final d = await widget.component.data?.future;
    if (d case EventFractal post when post.kind == 3) {
      post.file?.load().then((bytes) {
        setState(() {
          image = DecorationImage(
            fit: BoxFit.cover,
            image: MemoryImage(bytes),
          );
        });
      });
    }
  }

  DecorationImage? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        image: image,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).canvasColor, spreadRadius: 1,
            blurRadius: 8, //component.borderWidth,
            offset: Offset(1, 1),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.symmetric(),
      child: Stack(children: [
        Watch<Rewritable?>(
          component,
          (ctx, child) => component.data != null
              ? FRL(component.data, displayData)
              : SizedBox(),
        ),
      ]),
    );
  }

  final pad = const EdgeInsets.only(
    top: 48,
  );

  Widget displayData(EventFractal data) {
    return switch (data) {
      EventFractal f => Center(
          child: Text(f.display),
        ),
      /*Column(
            children: [
              Container(
                height: 20,
                //color: Colors.grey.withOpacity(0.8),
                child: TextFormField(
                  decoration:
                      InputDecoration(fillColor: Colors.white.withOpacity(0.7)),
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
          ),*/
      NodeFractal node => FractalLayer(
          child: FractalThing(node),
        ),
      _ => Center(
          child: data.icon,
        ),
    };
  }
}
