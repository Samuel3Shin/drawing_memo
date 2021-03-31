import 'package:drawing_memo/providers/eraser_provider.dart';
import 'package:drawing_memo/ui/constants/constants.dart';
import 'package:drawing_memo/ui/styles/icon_styles.dart';
import 'package:drawing_memo/ui/styles/popup_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class PenProperties extends StatefulWidget {
  const PenProperties({
    Key key,
  }) : super(key: key);
  @override
  _PenPropertiesState createState() => _PenPropertiesState();
}

class _PenPropertiesState extends State<PenProperties> {
  @override
  Widget build(BuildContext context) {
    var _eraserProv = Provider.of<EraserProvider>(context, listen: false);

    void eraserToPen() {
      var _eraserProv = Provider.of<EraserProvider>(context, listen: false);
      if (_eraserProv.isEraser) {
        _eraserProv.isEraser = false;
      }
    }

    return PopupMenuButton<String>(
      color: popupMenuColor,
      icon: Icon(
        FontAwesomeIcons.pen,
        color: Colors.white,
        size: iconSize,
      ),
      onCanceled: () {
        _eraserProv.isEraser = false;
      },
      onSelected: (String value) {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'pentype',
          child: ListTile(
            leading: Icon(
              FontAwesomeIcons.pen,
              color: popupTextStyle.color,
              size: iconSize,
            ),
            onTap: () {
              _eraserProv.isEraser = false;
              Navigator.of(context).pop();
            },
            tileColor: popupMenuColor,
            title: Text(
              'Pen',
              style: popupTextStyle,
            ),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'color',
          child: ListTile(
            tileColor: popupMenuColor,
            leading: Icon(
              FontAwesomeIcons.solidCircle,
              color: brushColor,
            ),
            title: Text(
              'Color',
              style: popupTextStyle,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(3.0),
                    title: Text(
                      "Pallete",
                    ),
                    content: MaterialColorPicker(
                      colors: fullMaterialColors,
                      selectedColor: brushColor,
                      allowShades: false,
                      onMainColorChange: (value) {
                        eraserToPen();
                        brushColor = value;
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    // actions: [
                    //   FlatButton(
                    //     child: Text('CANCEL'),
                    //     onPressed: Navigator.of(context).pop,
                    //   ),
                    //   FlatButton(
                    //     child: Text('SUBMIT'),
                    //     onPressed: () {
                    //       Navigator.of(context).pop();
                    //       setState(() => mainColor = tempMainColor);
                    //       setState(() => shadeColor = tempShadeColor);
                    //     },
                    //   ),
                    // ],
                  );
                },
              );

              // return showDialog(
              //   context: context,
              //   builder: (context) {
              //     return AlertDialog(
              //       content: MaterialColorPicker(
              //         colors: fullMaterialColors,
              //         selectedColor: brushColor,

              //         // shrinkWrap: true,
              //         elevation: 0.0,
              //         allowShades: false,

              //         onMainColorChange: (value) {
              //           eraserToPen();
              //           brushColor = value;
              //           Navigator.of(context).pop();
              //           Navigator.of(context).pop();
              //         },
              //       ),
              //     );
              //   },
              // );
            },
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'strokeWidth',
          child: StatefulBuilder(builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Row(
              children: [
                Slider(
                  value: brushWidth,
                  min: 3,
                  max: 40,
                  label: '$brushWidth',
                  onChanged: (value) {
                    setState(() {
                      // eraserToPen();
                      brushWidth = value;
                      _eraserProv.isEraser = false;
                    });
                  },

                  // onChanged: (value) {},
                  // onChangeEnd: (value) {
                  //   setState(() {
                  //     eraserToPen();
                  //     brushWidth = value;
                  //   });
                  // },
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

// class PenProperties extends StatelessWidget {
//   const PenProperties({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     void eraserToPen() {
//       var _eraserProv = Provider.of<EraserProvider>(context, listen: false);
//       if (_eraserProv.isEraser) {
//         _eraserProv.isEraser = false;
//       }
//     }

//     return PopupMenuButton<String>(
//       color: popupMenuColor,
//       icon: Icon(
//         FontAwesomeIcons.pen,
//         color: Colors.white,
//         size: iconSize,
//       ),
//       onSelected: (String value) {},
//       itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//         PopupMenuItem<String>(
//           value: 'pentype',
//           child: ListTile(
//             onTap: () {
//               eraserToPen();
//               Navigator.of(context).pop();
//             },
//             tileColor: popupMenuColor,
//             title: Text(
//               'Pen',
//               style: popupTextStyle,
//             ),
//           ),
//         ),
//         PopupMenuDivider(),
//         PopupMenuItem<String>(
//           value: 'color',
//           child: ListTile(
//             tileColor: popupMenuColor,
//             leading: Icon(
//               FontAwesomeIcons.solidCircle,
//               color: brushColor,
//             ),
//             title: Text(
//               'Colors',
//               style: popupTextStyle,
//             ),
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (_) {
//                   return AlertDialog(
//                     contentPadding: const EdgeInsets.all(6.0),
//                     title: Text(
//                       "Full Material Color picker",
//                     ),
//                     content: MaterialColorPicker(
//                       colors: fullMaterialColors,
//                       selectedColor: brushColor,
//                       onMainColorChange: (value) {
//                         eraserToPen();
//                         brushColor = value;
//                         Navigator.of(context).pop();
//                         // Navigator.of(context).pop();
//                       },
//                     ),
//                     // actions: [
//                     //   FlatButton(
//                     //     child: Text('CANCEL'),
//                     //     onPressed: Navigator.of(context).pop,
//                     //   ),
//                     //   FlatButton(
//                     //     child: Text('SUBMIT'),
//                     //     onPressed: () {
//                     //       Navigator.of(context).pop();
//                     //       mainColor = tempMainColor;
//                     //       shadeColor = tempShadeColor;
//                     //     },
//                     //   ),
//                     // ],
//                   );
//                 },
//               );

//               // return showDialog(
//               //   context: context,
//               //   builder: (context) {
//               //     return AlertDialog(
//               //       content: MaterialColorPicker(
//               //         colors: fullMaterialColors,
//               //         selectedColor: brushColor,

//               //         // shrinkWrap: true,
//               //         elevation: 0.0,
//               //         allowShades: false,

//               //         onMainColorChange: (value) {
//               //           eraserToPen();
//               //           brushColor = value;
//               //           Navigator.of(context).pop();
//               //           Navigator.of(context).pop();
//               //         },
//               //       ),
//               //     );
//               //   },
//               // );
//             },
//           ),
//         ),
//         PopupMenuDivider(),
//         PopupMenuItem<String>(
//           value: 'strokeWidth',
//           child: StatefulBuilder(builder:
//               (BuildContext context, void Function(void Function()) setState) {
//             return Row(
//               children: [
//                 Slider(
//                   value: brushWidth,
//                   min: 3,
//                   max: 40,
//                   label: '$brushWidth',
//                   onChanged: (value) {},
//                   onChangeEnd: (value) {
//                     setState(() {
//                       eraserToPen();
//                       brushWidth = value;
//                     });
//                   },
//                 ),
//               ],
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }
