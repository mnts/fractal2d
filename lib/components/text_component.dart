import 'dart:typed_data';

import 'package:app_fractal/screen.dart';
import 'package:fractal/data.dart';
import 'package:fractal2d/diagram_editor.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/areas/screens.dart';
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
    checkImage();
    super.initState();
  }

  bool loading = false;
  checkImage() {
    if (component.dataHash is! String) return;
    EventFractal.map.request(component.dataHash!).then((d) {
      if (d case PostFractal _) {
        d.file?.load().then((bytes) {
          setState(() {
            image = DecorationImage(
              fit: BoxFit.cover,
              image: MemoryImage(bytes),
            );
          });
        });
      }
    });
  }

  EventFractal? get data => component.data;

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
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Watch<Rewritable?>(
        component,
        (ctx, child) => switch (data) {
          ScreenFractal d => d.build(context),
          NodeFractal nF => FractalSub(
              //[nF],
              buildView: (ev, exp) => switch (ev) {
                NodeFractal node => ScreensArea(
                    node: node,
                    expand: exp,
                    key: ev.widgetKey(
                      'nav',
                    ),
                  ),
                _ => Container(),
              },
            ),
          PostFractal f => Center(
              child: Text(f.content),
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
          _ => Center(
              child: data?.icon,
            ),
        },
      ),
    );
  }
}
