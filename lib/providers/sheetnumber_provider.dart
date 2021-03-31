import 'package:drawing_memo/models/sheets_model.dart';
import 'package:drawing_memo/ui/constants/constants.dart';
import 'package:flutter/widgets.dart';

class SheetNumberProvider extends ChangeNotifier {
  int _sheetNumber = 0;
  int get sheetNumber => _sheetNumber;
  set sheetNumber(int val) {
    if (val < 0) {
    } else if (val < _sheetNumber) {
      if (_sheetNumber >= sheets.length) {
        try {
          SheetsModel _sheetsModel = SheetsModel();
          _sheetsModel.points = points;
          _sheetsModel.deletedPoints = deletedPoints;
          sheets.add(_sheetsModel);
          SheetsModel _smodel = sheets[sheets.length - 2];
          points = _smodel.points;
          deletedPoints = _smodel.deletedPoints;
          _sheetNumber = val;
          notifyListeners();
        } catch (e) {
          print('11111111: ${e.toString()}');
        }
      } else {
        print('222222222: Sheets Length ${sheets.length}');
        try {
          SheetsModel _sheetsmodel = sheets[_sheetNumber];
          _sheetsmodel.points = points;
          _sheetsmodel.deletedPoints = deletedPoints;
          SheetsModel _smodel = sheets[_sheetNumber - 1];
          points = _smodel.points;
          deletedPoints = _smodel.deletedPoints;
          _sheetNumber = val;
          notifyListeners();
        } catch (e) {
          print('2222222: ${e.toString()}');
        }
      }
    } else {
      if (val > sheets.length) {
        print('MAYBE NEW');
        try {
          SheetsModel _sheetsModel = SheetsModel();
          _sheetsModel.points = points;
          _sheetsModel.deletedPoints = deletedPoints;
          sheets.add(_sheetsModel);
          points = [];
          deletedPoints = [];
          _sheetNumber = val;
          notifyListeners();
        } catch (e) {
          print('33333333: ${e.toString()}');
        }
      } else {
        try {
          SheetsModel _smodel = sheets[_sheetNumber];
          _smodel.points = points;
          _smodel.deletedPoints = deletedPoints;
          SheetsModel _sheetsmodel = sheets[val];
          points = _sheetsmodel.points;
          deletedPoints = _sheetsmodel.deletedPoints;
          _sheetNumber = val;
          notifyListeners();
        } catch (e) {
          print('44444444: ${e.toString()}');
        }
      }
    }
  }
}
