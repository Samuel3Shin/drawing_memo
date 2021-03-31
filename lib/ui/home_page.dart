import 'package:drawing_memo/models/pen_stroke_model.dart';
import 'package:drawing_memo/providers/eraser_provider.dart';
import 'package:drawing_memo/providers/sheetnumber_provider.dart';
import 'package:drawing_memo/ui/constants/constants.dart';
import 'package:drawing_memo/ui/painters/draw.dart';
import 'package:drawing_memo/ui/components/left_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) => SafeArea(
          child: Stack(
            children: [
              Consumer<SheetNumberProvider>(
                builder: (context, sheetNProv, child) {
                  return Consumer<EraserProvider>(
                    builder: (context, eraseProv, child) => MouseRegion(
                      cursor: eraseProv.isEraser
                          ? SystemMouseCursors.disappearing
                          : SystemMouseCursors.basic,
                      child: GestureDetector(
                        onPanUpdate: (DragUpdateDetails details) {
                          setState(
                            () {
                              RenderBox object = context.findRenderObject();
                              Offset _localPosition =
                                  object.globalToLocal(details.globalPosition);
                              PenStroke _localPoint = PenStroke();
                              _localPoint.color =
                                  eraseProv.isEraser ? bgColor : brushColor;
                              _localPoint.offset = _localPosition;
                              _localPoint.brushWidth =
                                  eraseProv.isEraser ? eraserWidth : brushWidth;
                              _localPoint.strokeCap = strokeCap;
                              points = List.from(points)..add(_localPoint);
                            },
                          );
                        },
                        onPanEnd: (DragEndDetails details) => {
                          deletedPoints.clear(),
                          points.add(null),
                        },
                        child: CustomPaint(
                          painter: DrawPen(points: points),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  );
                },
              ),
              LeftAppBar(),
            ],
          ),
        ),
      ),
    );
  }
}
