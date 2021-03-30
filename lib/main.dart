import 'package:drawing_memo/providers/bg_color_provider.dart';
import 'package:drawing_memo/providers/eraser_provider.dart';
import 'package:drawing_memo/providers/pen_type_provider.dart';
import 'package:drawing_memo/providers/sheetnumber_provider.dart';
import 'package:drawing_memo/providers/sheets_provider.dart';
import 'package:drawing_memo/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (
        BuildContext context,
        AsyncSnapshot<dynamic> snapshot,
      ) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: SheetsViewProvider(),
            ),
            ChangeNotifierProvider.value(
              value: BgColorProvider(),
            ),
            ChangeNotifierProvider.value(
              value: PenEraserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: SheetNumberProvider(),
            ),
            ChangeNotifierProvider.value(
              value: EraserProvider(),
            ),
          ],
          child: MaterialApp(
            title: 'DrawingBoard',
            home: DrawScreen(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
