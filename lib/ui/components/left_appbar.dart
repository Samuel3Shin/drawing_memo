import 'package:drawing_memo/ui/components/eraser_button.dart';
import 'package:drawing_memo/ui/components/pen_properties_button.dart';
import 'package:flutter/material.dart';

import 'package:drawing_memo/ui/constants/constants.dart';
import 'package:drawing_memo/ui/styles/icon_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopAppBar extends StatefulWidget {
  @override
  _TopAppBarState createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
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
                      Icons.cancel_outlined,
                      color: iconColor,
                      size: iconSize,
                    ),
                    onPressed: () {
                      Scaffold.of(context).setState(() {
                        points.clear();
                        revPoints.clear();
                        deletedPoints.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
