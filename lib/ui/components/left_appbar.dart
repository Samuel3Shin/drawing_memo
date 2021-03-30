import 'package:drawing_memo/providers/bg_color_provider.dart';
import 'package:drawing_memo/providers/eraser_provider.dart';
import 'package:drawing_memo/providers/sheets_provider.dart';
import 'package:drawing_memo/ui/components/eraser_button.dart';
import 'package:drawing_memo/ui/components/pen_properties_button.dart';
import 'package:drawing_memo/ui/constants/constants.dart';
import 'package:drawing_memo/ui/styles/icon_styles.dart';
import 'package:drawing_memo/ui/styles/popup_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TopAppBar extends StatefulWidget {
  @override
  _TopAppBarState createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  void createNewFunction(bool isgrid) {
    Navigator.of(context).pop();
    var _sheetView = Provider.of<SheetsViewProvider>(context, listen: false);
    _sheetView.isGrid = isgrid;
    Scaffold.of(context).setState(() {
      points.clear();
      deletedPoints.clear();
      revPoints.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var _bgColorProvider = Provider.of<BgColorProvider>(context);
    return Builder(
      builder: (BuildContext context) => Container(
        color: Colors.black,
        width: 50,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  PenProperties(),
                  // BackGroundColorButton(bgColorProvider: _bgColorProvider),
                  EraserButton(),
                  PopupMenuButton<String>(
                    color: popupMenuColor,
                    tooltip: 'Sheet View',
                    icon: Icon(
                      Icons.add,
                      color: iconColor,
                      size: iconSize + 7,
                    ),
                    onSelected: (String value) {},
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'normalpaper',
                        child: ListTile(
                          title: Text(
                            'Normal',
                            style: popupTextStyle,
                          ),
                          onTap: () {
                            createNewFunction(false);
                          },
                        ),
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'gridpaper',
                        child: ListTile(
                          title: Text(
                            'Grid Paper',
                            style: popupTextStyle,
                          ),
                          onTap: () {
                            createNewFunction(true);
                          },
                        ),
                      ),
                    ],
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
