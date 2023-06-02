import 'package:flutter/material.dart';

class MyComponentData {
  Color color;
  Color borderColor;
  double borderWidth;

  String text;
  Alignment textAlignment;
  double textSize;

  MemoryImage? image;

  bool isHighlightVisible = false;

  MyComponentData({
    this.image,
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 0.0,
    this.text = '',
    this.textAlignment = Alignment.center,
    this.textSize = 20,
  });

  MyComponentData.copy(MyComponentData customData)
      : this(
          color: customData.color,
          borderColor: customData.borderColor,
          borderWidth: customData.borderWidth,
          text: customData.text,
          textAlignment: customData.textAlignment,
          textSize: customData.textSize,
        );

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }
}
