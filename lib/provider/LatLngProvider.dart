import 'package:flutter/cupertino.dart';

class LatLngProv with ChangeNotifier {
  double _Lat = 0;
  double _Lng = 0;
  String _message = '위치 정보를 가져오는 중...';

  double get Lat => _Lat;
  double get Lng => _Lng;
  String get message => _message;

  set Lat(double newLat) {
    _Lat = newLat;
    notifyListeners();
  }

  set Lng(double newLng) {
    _Lng = newLng;
    notifyListeners();
  }

  set message(String newmessage) {
    _message = newmessage;
    notifyListeners();
  }
}
