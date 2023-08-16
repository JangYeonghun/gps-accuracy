import 'package:flutter/cupertino.dart';

class CompProv with ChangeNotifier {
  double _Compass = 0;
  double get Compass => _Compass;
  set Compass(double newCompass) {
    _Compass = newCompass;
    notifyListeners();
  }

  String _CompassText = 'null';
  String get CompassText => _CompassText;
  set CompassText(String newCompassText) {
    _CompassText = newCompassText;
    notifyListeners();
  }

}
