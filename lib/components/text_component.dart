import 'dart:typed_data';
import 'dart:ui';

import 'package:app_fractal/screen.dart';
import 'package:fractal/data.dart';
import 'package:fractal2d/diagram_editor.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/areas/screens.dart';
import 'package:fractal_layout/index.dart';
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
    NetworkFractal.request(component.dataHash!).then((d) {
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
    final pad = EdgeInsets.only(
      top: 48,
    );
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
      child: Stack(
        children: [
          Watch<Rewritable?>(
            component,
            (ctx, child) => switch (data) {
              ScreenFractal d => DocumentArea(
                  d,
                  padding: const EdgeInsets.only(
                    top: 48,
                    left: 8,
                    right: 8,
                    bottom: 48,
                  ),
                ),
              CatalogFractal f => FGridArea(f, padding: pad),
              NodeFractal nF => ScreensArea(
                  node: nF,
                  key: nF.widgetKey(
                    'nav',
                  ),
                  padding: pad,
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
          if (data case NodeFractal node)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: FractalScaffoldState.active.color,
                height: 48,
                //backgroundColor: widget.fractal.skin.color.toMaterial,

                //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 2),
                    child: Row(children: [
                      SizedBox.square(
                        dimension: 42,
                        child: FIcon(node, color: Colors.white),
                      ),
                      Expanded(
                        child: FTitle(node,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      )
                    ]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
