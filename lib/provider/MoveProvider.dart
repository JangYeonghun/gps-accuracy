import 'package:flutter/cupertino.dart';

class MoveProv with ChangeNotifier {
  String _MoveStat = 'null';

  String get MoveStat => _MoveStat;

  set MoveStat(String newMoveStat) {
    _MoveStat = newMoveStat;
    notifyListeners();
  }
}
