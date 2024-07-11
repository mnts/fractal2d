import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_app_flutter/dialogs/create/app.dart';
import 'package:fractal_app_flutter/index.dart';
import 'package:fractal_flutter/index.dart';
import 'package:fractal_layout/screens/app.dart';

class Fractal2dHome extends StatefulWidget {
  const Fractal2dHome({super.key});

  @override
  State<Fractal2dHome> createState() => _Fractal2dHomeState();
}

class _Fractal2dHomeState extends State<Fractal2dHome> {
  @override
  Widget build(BuildContext context) {
    final app = context.read<AppFractal>();
    return app.to == null
        ? Container(
            padding: EdgeInsets.all(8),
            child: ListView(children: [
              SizedBox(
                height: 40,
                child: Row(children: [
                  const Expanded(
                    child: Text(
                      'Sub',
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AppFCreateDialog(app),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ]),
              ),
              SizedBox(
                height: 300,
                child: AppsFAreas(app),
              ),
            ]),
          )
        : AppFHome();
  }
}
