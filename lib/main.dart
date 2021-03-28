import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_icons/flutter_icons.dart';

void main() => runApp(MyApp());

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
  List<Path> _paths = <Path>[];
  List<Paint> _paint = <Paint>[];

  Path _path = new Path();
  bool _repaint = false;
  int back = 0;
  double _strokeWidth = 20;

  GlobalKey globalKey = GlobalKey();
  Color selectedColor = Colors.black;

  _CanvasPaintingState() {
    _paths = [new Path()];

    Paint paint = new Paint()
      ..color = selectedColor
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;
    _paint.add(paint);
  }
  _panDown(DragDownDetails details) {
    setState(() {
      _path = new Path();
      _paths.add(_path);
      RenderBox object = context.findRenderObject();
      Offset _localPosition = object.globalToLocal(details.globalPosition);
      _paths.last.moveTo(_localPosition.dx - 10, _localPosition.dy - 5);
      _paths.last.lineTo(_localPosition.dx - 10, _localPosition.dy - 5);

      Paint paint = new Paint()
        ..color = selectedColor
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..strokeWidth = _strokeWidth;
      _paint.add(paint);

      _repaint = true;
    });
  }

  var fingerPostionY = 0.0, fingerPostionX = 0.0;
  double _distanceBetweenTwoPoints(double x1, double y1, double x2, double y2) {
    double x = x1 - x2;
    x = x * x;
    double y = y1 - y2;
    y = y * y;

    double result = x + y;
    return sqrt(result);
  }

  _panUpdate(DragUpdateDetails details) {
    RenderBox object = context.findRenderObject();
    Offset _localPosition = object.globalToLocal(details.globalPosition);

    if (fingerPostionY < 1.0) {
      // assigen for the first time to compare
      fingerPostionY = _localPosition.dy;
      fingerPostionX = _localPosition.dx;
    } else {
      // they use a lot of fingers
      double distance = _distanceBetweenTwoPoints(
          _localPosition.dx, _localPosition.dy, fingerPostionX, fingerPostionY);

      // the distance between two fingers must be above 50
      // to disable multi touch
      if (distance > 100) {
        return;
      }
    }

    // update to use it in comparison
    fingerPostionY = _localPosition.dy;
    fingerPostionX = _localPosition.dx;

    setState(() {
      _paths.last.lineTo(fingerPostionX - 10.0, fingerPostionY - 5.0);
    });
  }

  _panEnd(DragEndDetails details) {
    setState(() {
      fingerPostionY = 0.0;
//      _repaint = true;
    });
  }

  _boardReset() {
    setState(() {
      _path = new Path();
      _paths = [new Path()];
      _paint = [new Paint()];
      _repaint = true;
    });
  }

  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;

  Future<void> _pickStroke() async {
    //Shows AlertDialog
    return showDialog<void>(
      context: context,

      //Dismiss alert dialog when set true
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        //Clips its child in a oval shape
        return ClipOval(
          child: AlertDialog(
            //Creates three buttons to pick stroke value.
            actions: <Widget>[
              //Resetting to default stroke value
              FlatButton(
                child: Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  _strokeWidth = 3.0;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.brush,
                  size: 24,
                ),
                onPressed: () {
                  _strokeWidth = 10.0;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.brush,
                  size: 40,
                ),
                onPressed: () {
                  _strokeWidth = 30.0;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.brush,
                  size: 60,
                ),
                onPressed: () {
                  _strokeWidth = 50.0;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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

  // Android 에서는 검은 화면만 저장된다. issue 해결해야한다.
  // 일단 아이폰, 안드로이드 모두에서 뺀다.
  _saveScreen() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    //Request permissions if not already granted
    if (!(await Permission.storage.status.isGranted))
      await Permission.storage.request();
    final result =
        await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
    print(result);
    // _toastInfo(result.toString());
  }

  List<Widget> fabOption() {
    return <Widget>[
      // FloatingActionButton(
      //   heroTag: "paint_save",
      //   child: Icon(Icons.save),
      //   tooltip: 'Save',
      //   onPressed: () {
      //     //min: 0, max: 50
      //     setState(() {
      //       _saveScreen();
      //     });
      //   },
      // ),
      FloatingActionButton(
        heroTag: "paint_stroke",
        child: Icon(Icons.brush),
        tooltip: 'Stroke',
        onPressed: () {
          //min: 0, max: 50
          setState(() {
            _pickStroke();
          });
        },
      ),
      FloatingActionButton(
        heroTag: "paint_opacity",
        child: Icon(Icons.opacity),
        tooltip: 'Opacity',
        onPressed: () {
          //min:0, max:1
          setState(() {
            _opacity();
          });
        },
      ),
      FloatingActionButton(
          heroTag: "erase",
          child: Icon(Icons.delete),
          tooltip: "Erase",
          onPressed: () {
            _boardReset();
          }),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GestureDetector(
          onPanDown: (DragDownDetails details) {
            _panDown(details);
          },
          onPanUpdate: (DragUpdateDetails details) {
            _panUpdate(details);
          },
          onPanEnd: (DragEndDetails details) {
            _panEnd(details);
          },
          child: RepaintBoundary(
            key: globalKey,
            child: CustomPaint(
              size: Size.infinite,
              painter: new PathPainter(
                  paths: _paths, repaint: _repaint, paints: _paint),
            ),
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
}

class PathPainter extends CustomPainter {
  List<Path> paths;
  List<Paint> paints;
  bool repaint;
  int i = 0;
  PathPainter({this.paths, this.repaint, this.paints});
  @override
  void paint(Canvas canvas, Size size) {
    paths.forEach((path) {
      canvas.drawPath(path, paints[i]);
      ++i;
    });

    i = 0;
    repaint = false;
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => repaint;
}
