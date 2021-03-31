import 'package:drawing_memo/models/pen_stroke_model.dart';
import 'package:drawing_memo/models/sheets_model.dart';
import 'package:flutter/material.dart';

List<PenStroke> points = [];
List<PenStroke> deletedPoints = [];
List<SheetsModel> sheets = [];
double brushWidth = 3.0;
Color brushColor = Colors.black;
Color bgColor = Colors.white;
int count = 0;
StrokeCap strokeCap = StrokeCap.round;
double eraserWidth = 30.0;
