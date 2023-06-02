import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/component.dart';
import '../providers/app.dart';
import '../providers/positioner.dart';
import '../simple_diagram_editor/data/custom_component_data.dart';

class PositionerArea extends ConsumerWidget {
  const PositionerArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positioner = ref.watch(Positioner.provider.notifier);
    final position = ref.watch(Positioner.provider);

    final app = ref.read(editorContextProvider);

    return Container(
      color: Colors.orange.withAlpha(200),
      child: Column(children: [
        IconButton(
          onPressed: () async {
            app.putImage(position);
            positioner.reset();
          },
          icon: const Icon(
            Icons.image,
          ),
        ),
      ]),
    );
  }
}
