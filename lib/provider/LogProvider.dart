import 'package:flutter/cupertino.dart';

class LogProv with ChangeNotifier {
  String _Log = '';

  String get Log => _Log;

  set Log(String newLog) {
    _Log = newLog;
    notifyListeners();
  }
}
