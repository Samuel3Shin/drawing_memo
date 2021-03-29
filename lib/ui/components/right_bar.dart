import 'package:drawing_memo/providers/sheetnumber_provider.dart';
import 'package:drawing_memo/ui/constants/constants.dart';
import 'package:drawing_memo/ui/styles/icon_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RightBar extends StatefulWidget {
  @override
  _RightBarState createState() => _RightBarState();
}

class _RightBarState extends State<RightBar> {
  int z = 0;

  void undo() async {
    try {
      int c = 0;
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
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
    }
  }

  void redo() async {
    try {
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
    } catch (e) {
      if (z <= 1)
        await Fluttertoast.showToast(msg: e.toString());
      else
        Scaffold.of(context).setState(() {});
      z++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: 50,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Consumer<SheetNumberProvider>(
            //   builder: (context, nsheetProv, child) => TextButton(
            //     onPressed: () {},
            //     child: Text('${nsheetProv.sheetNumber + 1}'),
            //   ),
            // ),
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
    );
  }
}
