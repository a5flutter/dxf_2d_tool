import 'dart:math';

import 'package:dxf_2d_tool/ui/rectangle_element.dart';
import 'package:flutter/material.dart';

class CanvasDrawer extends CustomPainter {

  List<RectangleElement> elements;
  CanvasDrawer({required this.elements});
  double linesOffset = 5;

  Paint rectPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = true
    ..color = Colors.green
    ..strokeWidth = 1.0;

  Paint linesPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = true
    ..color = Colors.black26
    ..strokeWidth = 1.0;

  TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontSize: 10,
  );

  int arrowSize = 10;
  double arrowAngle = pi / 6;

  @override
  void paint(Canvas canvas, Size size) {

        for(RectangleElement element in elements) {

          Rect rect = element!.dumpToDraw();
          canvas.drawRect(rect, rectPaint);
          //top
          canvas.drawLine(rect.topLeft.translate(0, - 2*linesOffset), rect.topRight.translate(0, - 2*linesOffset), linesPaint);

          // arrow
          // Path path = Path();
          // double width = rect.topRight.translate(0, - 2*linesOffset).dx;
          // path.moveTo(width / 2, 0);
          // path.lineTo(width / 2 - arrowSize * cos(arrowAngle), arrowSize * sin(arrowAngle));
          // path.moveTo(width / 2, 0);
          // path.lineTo(width / 2 + arrowSize * cos(arrowAngle), arrowSize * sin(arrowAngle));
          // path.close();

          // canvas.drawPath(path, linesPaint);

          var textSpan = TextSpan(
            text: rect.width.toStringAsFixed(2) ,
            style: textStyle,
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout(
            minWidth: 0,
            maxWidth: size.width,
          );
          final xCenter = rect.left + rect.width/2 - 20;
          final yCenter = rect.top  - 2*linesOffset;
          final offset = Offset(xCenter, yCenter);
          textPainter.paint(canvas, offset);

          //bottom
          canvas.drawLine(rect.bottomLeft.translate(0, 2*linesOffset), rect.bottomRight.translate(0, 2*linesOffset), linesPaint);
          textPainter.paint(canvas, offset.translate(0, rect.height + 2*linesOffset));

          //left
          var textSpan2 = TextSpan(
            text: rect.height.toStringAsFixed(2) ,
            style: textStyle,
          );
          final textPainter2 = TextPainter(
            text: textSpan2,
            textDirection: TextDirection.ltr,
          );
          textPainter2.layout(
            minWidth: 0,
            maxWidth: size.width,
          );


          canvas.drawLine(rect.topLeft.translate(- 2*linesOffset, 0), rect.bottomLeft.translate(- 2*linesOffset, 0), linesPaint);

          final xCenter2 = rect.left - 40;
          final yCenter2 = rect.top + rect.height/2 - linesOffset;
          final offset2 = Offset(xCenter2, yCenter2);
          textPainter2.paint(canvas, offset2);

          //right
          canvas.drawLine(rect.topRight.translate(2*linesOffset, 0), rect.bottomRight.translate(2*linesOffset, 0), linesPaint);
          textPainter2.paint(canvas, offset2.translate(rect.width + 40 + 2*linesOffset, 0));
        }
  }
  @override
  bool shouldRepaint(covariant CanvasDrawer oldDelegate) => true;
}
