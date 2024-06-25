import 'package:dxf_2d_tool/ui/rectangle_element.dart';
import 'package:flutter/material.dart';

class RectangleDrawer extends CustomPainter {

  RectangleElement? element;
  RectangleDrawer({this.element});

  @override
  void paint(Canvas canvas, Size size) {
        if(element != null) canvas.drawDRRect(element!.dumpToRDraw(), element!.dumpToInnerRDraw(), Paint()
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.square
          ..isAntiAlias = true
          ..color = Colors.green.withAlpha(50)
          ..strokeWidth = 1.0
        );
  }
  @override
  bool shouldRepaint(covariant RectangleDrawer oldDelegate) => true;
}
