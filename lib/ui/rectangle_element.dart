import 'dart:ui';

import 'package:dxf/dxf.dart';

//representing UI element
class RectangleElement {
  double _top = 0.0;
  double _left = 0.0;
  double? _right = 0.0;
  double? _bottom = 0.0;

  double? _width = 0.0;
  double? _height = 0.0;
  double _heightExtra = 0.0;

  RectangleElement(
      {required double top,
      double? bottom,
      required double left,
      double? right,
      double? width,
      double? height,
      double? heightExtra}) {
    this.top = top;
    this.bottom = bottom;
    this.left = left;
    this.right = right;
    this.height = height;
    this.width = width;
    this.heightExtra = heightExtra ?? 0.0;
  }

  Rect dumpToDraw() {
    // return width != null && height != null ? Rect.fromLTWH(
    //     left, top, width!, height! + heightExtra) :
    return Rect.fromLTRB(
        left, top, right ?? left, bottom ?? top); //degenerate rectangle
  }

  RRect dumpToRDraw() {
    return RRect.fromRectAndCorners(dumpToDraw()); //degenerate rectangle
  }

  RRect dumpToInnerRDraw() {
    if(right == null && width != null) right = left + width!;
    if (height != null)
      return RRect.fromLTRBR(
          left, top + height!, right! - height!, bottom!, Radius.zero);
    else
      return RRect.zero; //degenerate rectangle
  }

  AcDbPolyline dumpToCad() {
    var vertices = <List<double>>[];
    if (heightExtra == 0) {
      //L-shape
      vertices.addAll([
        [top, left],
        [top, width != null ? left + width! : right ?? left],
        [
          height != null ? top + height! : bottom ?? top,
          width != null ? left + width! : right ?? left
        ],
        [
          (height != null ? top + height! : bottom ?? top) - height!,
          width != null ? left + width! : right ?? left
        ],
        [
          (height != null ? top + height! : bottom ?? top) - height!,
          (width != null ? left + width! : right ?? left) - heightExtra
        ],
        [top - height!, left],
      ]);
    } else {
      //I-shape

      vertices.addAll([
        [top, left],
        [top, width != null ? left + width! : right ?? left],
        [
          height != null ? top + height! : bottom ?? top,
          width != null ? left + width! : right ?? left
        ],
        [height != null ? top + height! : bottom ?? top, left]
      ]);
    }

    return AcDbPolyline(vertices: vertices, isClosed: true);
  }

  double get top => _top;

  set top(double value) {
    _top = value;
  }

  double get left => _left;

  set left(double value) {
    _left = value;
  }

  double? get right => _right;

  set right(double? value) {
    _right = value;
  }

  double? get bottom => _bottom;

  set bottom(double? value) {
    _bottom = value;
  }

  double? get width => _width;

  set width(double? value) {
    _width = value;
  }

  double? get height => _height;

  set height(double? value) {
    //print('Called height setter with ${value}');
    _height = value;
  }

  double get heightExtra => _heightExtra;

  set heightExtra(double value) {
    //print('Called heightExtra setter with ${value}');
    _heightExtra = value;
  }
}
