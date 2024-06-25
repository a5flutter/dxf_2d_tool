import 'dart:math';

import 'package:dxf_2d_tool/ui/rectangle_drawer.dart';
import 'package:dxf_2d_tool/ui/rectangle_element.dart';
import 'package:flutter/material.dart';

class CanvasDrawer extends CustomPainter {
  List<RectangleElement> elements;

  CanvasDrawer({required this.elements});

  double linesOffset = 5;

  Paint rectPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.square
    ..isAntiAlias = false
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
    for (RectangleElement element in elements) {
      RectangleDrawer(element: element).paint(canvas, size);
      if (element.heightExtra == 0) {
        //I-shape
        Rect rect = element!.dumpToDraw();
        drawMetaForRect(rect, canvas, size);
      } else {
        //L-shape
        RRect rect = element!.dumpToRDraw();
        drawMetaForRRect(rect, canvas, size, element);
      }
    }
  }

  void drawMetaForRRect(
      RRect rect, Canvas canvas, Size size, RectangleElement element) {
    //top
    canvas.drawLine(rect.outerRect.topLeft.translate(0, -2 * linesOffset),
        rect.outerRect.topRight.translate(0, -2 * linesOffset), linesPaint);

    var textSpan = TextSpan(
      text: rect.width.toStringAsFixed(2),
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
    final xCenter = rect.left + rect.width / 2 - 20;
    final yCenter = rect.top - 2 * linesOffset;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);

    //right
    canvas.drawLine(rect.outerRect.topRight.translate(2 * linesOffset, 0),
        rect.outerRect.bottomRight.translate(2 * linesOffset, 0), linesPaint);
    var textSpan2 = TextSpan(
      text: (element.height! + element.heightExtra).toStringAsFixed(2),
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

    final xCenter2 = rect.left - 40;
    final yCenter2 =
        rect.top + (element.height! + element.heightExtra!) / 2 - linesOffset;
    final offset2 = Offset(xCenter2, yCenter2);

    textPainter2.paint(
        canvas, offset2.translate(rect.width + 40 + 2 * linesOffset, 0));

    //left
    canvas.drawLine(
        rect.outerRect.topLeft.translate(-2 * linesOffset, 0),
        rect.outerRect.bottomLeft
            .translate(-2 * linesOffset, -element.heightExtra),
        linesPaint);

    var textSpan3 = TextSpan(
      text: element.height!.toStringAsFixed(2),
      style: textStyle,
    );
    final textPainter3 = TextPainter(
      text: textSpan3,
      textDirection: TextDirection.ltr,
    );
    textPainter3.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final xCenter3 = rect.left - 40;
    final yCenter3 = rect.top + element.height! / 2 - linesOffset;
    final offset3 = Offset(xCenter3, yCenter3);
    textPainter3.paint(canvas, offset3);

    //inner bottom
    canvas.drawLine(
        rect.outerRect.topLeft.translate(0, element.height! + 2 * linesOffset),
        rect.outerRect.topRight.translate(-element.height! - 2 * linesOffset,
            element.height! + 2 * linesOffset),
        linesPaint);

    var textSpan4 = TextSpan(
      text: (rect.width - element.height!).toStringAsFixed(2),
      style: textStyle,
    );
    final textPainter4 = TextPainter(
      text: textSpan4,
      textDirection: TextDirection.ltr,
    );
    textPainter4.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter4 = rect.left + (rect.width - element.height!) / 2 - 20;
    final yCenter4 = rect.top + element.height! + 2 * linesOffset;
    final offset4 = Offset(xCenter4, yCenter4);
    textPainter4.paint(canvas, offset4);

    //outer bottom
    canvas.drawLine(
        rect.outerRect.bottomRight
            .translate(-element.height! - 1 * linesOffset, 2 * linesOffset),
        rect.outerRect.bottomRight.translate(1 * linesOffset, 2 * linesOffset),
        linesPaint);

    var textSpan5 = TextSpan(
      text: element.height!.toStringAsFixed(2),
      style: textStyle,
    );
    final textPainter5 = TextPainter(
      text: textSpan5,
      textDirection: TextDirection.ltr,
    );
    textPainter5.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter5 = rect.right - element.height! / 2 - 10;
    final yCenter5 = rect.bottom + 2 * linesOffset;
    final offset5 = Offset(xCenter5, yCenter5);
    textPainter5.paint(canvas, offset5);

    //inner left

    canvas.drawLine(
        rect.outerRect.topRight.translate(-element.height! - 2 * linesOffset,
            element.height! + 10 + 2 * linesOffset),
        rect.outerRect.bottomRight
            .translate(-element.height! - 2 * linesOffset, 0),
        linesPaint);

    var textSpan6 = TextSpan(
      text: element.heightExtra!.toStringAsFixed(2),
      style: textStyle,
    );
    final textPainter6 = TextPainter(
      text: textSpan6,
      textDirection: TextDirection.ltr,
    );
    textPainter6.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final xCenter6 = rect.right - 40 - element.height! - linesOffset;
    final yCenter6 = rect.bottom - element.heightExtra! / 2 - linesOffset;
    final offset6 = Offset(xCenter6, yCenter6);
    textPainter6.paint(canvas, offset6);
  }

  void drawMetaForRect(Rect rect, Canvas canvas, Size size) {
    //top
    canvas.drawLine(rect.topLeft.translate(0, -2 * linesOffset),
        rect.topRight.translate(0, -2 * linesOffset), linesPaint);

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
      text: rect.width.toStringAsFixed(2),
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
    final xCenter = rect.left + rect.width / 2 - 20;
    final yCenter = rect.top - 2 * linesOffset;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);

    //bottom
    canvas.drawLine(rect.bottomLeft.translate(0, 2 * linesOffset),
        rect.bottomRight.translate(0, 2 * linesOffset), linesPaint);
    textPainter.paint(
        canvas, offset.translate(0, rect.height + 2 * linesOffset));

    //left
    var textSpan2 = TextSpan(
      text: rect.height.toStringAsFixed(2),
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

    canvas.drawLine(rect.topLeft.translate(-2 * linesOffset, 0),
        rect.bottomLeft.translate(-2 * linesOffset, 0), linesPaint);

    final xCenter2 = rect.left - 40;
    final yCenter2 = rect.top + rect.height / 2 - linesOffset;
    final offset2 = Offset(xCenter2, yCenter2);
    textPainter2.paint(canvas, offset2);

    //right
    canvas.drawLine(rect.topRight.translate(2 * linesOffset, 0),
        rect.bottomRight.translate(2 * linesOffset, 0), linesPaint);
    textPainter2.paint(
        canvas, offset2.translate(rect.width + 40 + 2 * linesOffset, 0));
  }

  @override
  bool shouldRepaint(covariant CanvasDrawer oldDelegate) => true;
}
