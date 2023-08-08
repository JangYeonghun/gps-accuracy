import 'package:flutter/cupertino.dart';

class LogProv with ChangeNotifier {
  String _LatLngLog = '';
  String _SensorLog = '';

  String get LatLngLog => _LatLngLog;
  String get SensorLog => _SensorLog;

  set LatLngLog(String newLatLngLog) {
    _LatLngLog = newLatLngLog;
    notifyListeners();
  }

  set SensorLog(String newSensorLog) {
    _SensorLog = newSensorLog;
    notifyListeners();
  }
}
