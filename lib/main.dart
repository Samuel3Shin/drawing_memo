import 'dart:typed_data';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CanvasPainting(),
    );
  }
}

class CanvasPainting extends StatefulWidget {
  @override
  _CanvasPaintingState createState() => _CanvasPaintingState();
}

class _CanvasPaintingState extends State<CanvasPainting> {
  final globalKey = GlobalKey();
  List<TouchPoints> points = List();

  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 3.0;
  Color selectedColor = Colors.black;

  List<Widget> fabOption() {
    return <Widget>[
      FloatingActionButton(
          heroTag: 'paint_save',
          child: Icon(Icons.save),
          tooltip: 'Save',
          onPressed: () {
            setState(() {
              _save();
            });
          }),
      FloatingActionButton(
        heroTag: "pinat_stroke",
        child: Icon(Icons.brush),
        tooltip: 'Stroke',
        onPressed: () {
          setState(() {
            _pickStroke();
          });
        },
      ),
      FloatingActionButton(
        heroTag: 'Pinat_opacity',
        child: Icon(Icons.opacity),
        tooltip: 'Opacity',
        onPressed: () {
          setState(() {
            _opacity();
          });
        },
      ),
      FloatingActionButton(
        heroTag: 'erase',
        child: Icon(Icons.clear),
        tooltip: 'Erase',
        onPressed: () {
          setState(() {
            points.clear();
          });
        },
      ),
      //FAB for picking red color
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_red",
        child: colorMenuItem(Colors.red),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.red;
          });
        },
      ),

      //FAB for picking green color
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_green",
        child: colorMenuItem(Colors.green),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.green;
          });
        },
      ),

      //FAB for picking pink color
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_pink",
        child: colorMenuItem(Colors.pink),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.pink;
          });
        },
      ),

      //FAB for picking blue color
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_blue",
        child: colorMenuItem(Colors.blue),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.blue;
          });
        },
      ),
    ];
  }

  //TODO: _save 기능에 버그가 있다...
  // globalKey.currentContext 가 Null 인 것이 문제이다.

  Future<void> _save() async {
    print('1');
    print(globalKey);
    print(globalKey.currentContext);
    print(globalKey.currentWidget);
    print(globalKey.currentState);
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    print('2');
    ui.Image image = await boundary.toImage();
    print('3');
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    print('4');
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print('5');

    if (!(await Permission.storage.status.isGranted)) {
      print('6');
      await Permission.storage.request();
    }
    print('7');

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 100,
        name: 'canvas_image');
    print('8');
    print(result);
  }

  Future<void> _pickStroke() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ClipOval(
            child: AlertDialog(
              actions: <Widget>[
                //Resetting to default stroke value
                FlatButton(
                  child: Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    strokeWidth = 3.0;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Icon(
                    Icons.brush,
                    size: 24,
                  ),
                  onPressed: () {
                    strokeWidth = 10.0;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Icon(
                    Icons.brush,
                    size: 40,
                  ),
                  onPressed: () {
                    strokeWidth = 30.0;
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Icon(
                    Icons.brush,
                    size: 60,
                  ),
                  onPressed: () {
                    strokeWidth = 50.0;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _opacity() async {
    //Shows AlertDialog
    return showDialog<void>(
      context: context,

      //Dismiss alert dialog when set true
      barrierDismissible: true,

      builder: (BuildContext context) {
        //Clips its child in a oval shape
        return ClipOval(
          child: AlertDialog(
            //Creates three buttons to pick opacity value.
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.opacity,
                  size: 24,
                ),
                onPressed: () {
                  //most transparent
                  opacity = 0.1;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.opacity,
                  size: 40,
                ),
                onPressed: () {
                  opacity = 0.5;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.opacity,
                  size: 60,
                ),
                onPressed: () {
                  //not transparent at all.
                  opacity = 1.0;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget colorMenuItem(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GestureDetector(
          onPanStart: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject();
              points.add(TouchPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeType
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth));
            });
          },
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject();
              points.add(TouchPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeType
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth));
            });
          },
          onPanEnd: (details) {
            setState(() {
              points.add(null);
            });
          },
          child: Stack(
            children: <Widget>[
              Center(
                  // child: Image.asset("assets/images/hut.png"),
                  ),
              CustomPaint(
                size: Size.infinite,
                painter: MyPainter(
                  pointsList: points,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: AnimatedFloatingActionButton(
          fabButtons: fabOption(),
          colorStartAnimation: Colors.blue,
          colorEndAnimation: Colors.cyan,
          animatedIconData: AnimatedIcons.menu_close,
        ),
      ),
    );
  }
}

class TouchPoints {
  Paint paint;
  Offset points;
  TouchPoints({this.points, this.paint});
}

class MyPainter extends CustomPainter {
  MyPainter({this.pointsList});

  List<TouchPoints> pointsList;
  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; ++i) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));

        canvas.drawPoints(
            ui.PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
