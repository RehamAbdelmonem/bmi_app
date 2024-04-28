import 'dart:math';
import 'package:flutter/material.dart';

class Model extends ChangeNotifier {
  double _bmi = 0;
  String _status = '';

  double get bmi => _bmi;
  String get status => _status;

  calculateBmi(double weight, double height) {
    _bmi = weight / pow(height / 100, 2);
    _bmi = double.parse((_bmi).toStringAsFixed(2));
    _status = _calculateStatus(_bmi);
    notifyListeners();
  }

  String _calculateStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25.0) {
      return 'Normal';
    } else if (bmi >= 25.0 && bmi < 30.0) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }
}
