import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList, this.image});
  List<List<DrawingPoints>> pointsList;
  List<Offset> offsetPoints = List();
  ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(canvas: canvas, image: image, rect: Rect.fromLTWH(0, 0, size.width, size.height));
    for (int j = 0; j < pointsList.length; j++) {
      for (int i = 0; i < pointsList[j].length - 1; i++) {
        if (pointsList[j][i] != null && pointsList[j][i + 1] != null) {
          canvas.drawLine(pointsList[j][i].points, pointsList[j][i + 1].points, pointsList[j][i].paint);
        } else if (pointsList[j][i] != null && pointsList[j][i + 1] == null) {
          offsetPoints.clear();
          offsetPoints.add(pointsList[j][i].points);
          offsetPoints.add(Offset(pointsList[j][i].points.dx + 0.1, pointsList[j][i].points.dy + 0.1));
          canvas.drawPoints(ui.PointMode.points, offsetPoints, pointsList[j][i].paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
