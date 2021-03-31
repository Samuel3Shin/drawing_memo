import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:drawing_memo/ui/components/eraser_button.dart';
import 'package:drawing_memo/ui/components/pen_properties_button.dart';
import 'package:drawing_memo/providers/sheetnumber_provider.dart';
import 'package:drawing_memo/ui/constants/constants.dart';
import 'package:drawing_memo/ui/styles/icon_styles.dart';
import 'package:drawing_memo/providers/eraser_provider.dart';

//TODO: sheet number 바꾸는 거 제대로 구현하면 작은 폰 이용자들이 많은 sheet를 위 아래로 이동하면서 이용할 수 있으니까 좋을듯!

class LeftAppBar extends StatefulWidget {
  @override
  _LeftAppBarState createState() => _LeftAppBarState();
}

class _LeftAppBarState extends State<LeftAppBar> {
  void undo() async {
    Scaffold.of(context).setState(
      () {
        int i;
        if (points.length == 0) return;
        for (i = points.length - 2; i >= 0; --i) {
          if (points[i] == null) break;
        }
        for (int k = i + 1; k < points.length; ++k) {
          deletedPoints.add(points[k]);
          print('DEBUG::${points[k]}');
        }
        points.removeRange(i + 1, points.length);
      },
    );
  }

  void redo() async {
    Scaffold.of(context).setState(
      () {
        int i;
        if (deletedPoints.length == 0) return;

        for (i = deletedPoints.length - 2; i >= 0; --i) {
          if (deletedPoints[i] == null) break;
        }
        for (int k = i + 1; k < deletedPoints.length; ++k) {
          points.add(deletedPoints[k]);
          print('DEBUG::${deletedPoints[k]}');
        }
        deletedPoints.removeRange(i + 1, deletedPoints.length);
      },
    );
    print(points.toList());
  }

  @override
  Widget build(BuildContext context) {
    var _eraserProv = Provider.of<EraserProvider>(context, listen: false);
    // var sheetnProv = Provider.of<SheetNumberProvider>(context, listen: false);
    return Builder(
      builder: (BuildContext context) => Container(
        color: Colors.black,
        width: 50,
        // height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  PenProperties(),
                  EraserButton(),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.undo,
                      color: iconColor,
                      size: iconSize,
                    ),
                    onPressed: () => undo(),
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.redo,
                      color: iconColor,
                      size: iconSize,
                    ),
                    onPressed: () => redo(),
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.trashAlt,
                      color: iconColor,
                      size: iconSize,
                    ),
                    onPressed: () {
                      Scaffold.of(context).setState(() {
                        for (int k = 0; k < points.length; ++k) {
                          deletedPoints.add(points[k]);
                          print('DEBUG::${points[k]}');
                        }
                        // deletedPoints = points;
                        points.clear();
                        // deletedPoints.clear();
                      });
                    },
                  ),
                  // IconButton(
                  //   padding: EdgeInsets.all(8),
                  //   icon: Icon(
                  //     FontAwesomeIcons.arrowUp,
                  //     color: iconColor,
                  //     size: iconSize,
                  //   ),
                  //   onPressed: () {
                  //     int n = sheetnProv.sheetNumber;
                  //     sheetnProv.sheetNumber = --n;
                  //     print('BOTTOM APPBAR: $n');
                  //   },
                  // ),
                  // IconButton(
                  //   padding: EdgeInsets.all(8),
                  //   icon: Icon(
                  //     FontAwesomeIcons.arrowDown,
                  //     color: iconColor,
                  //     size: iconSize,
                  //   ),
                  //   onPressed: () {
                  //     int n = sheetnProv.sheetNumber;
                  //     sheetnProv.sheetNumber = ++n;
                  //     print('BOTTOM APPBAR: $n');
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
