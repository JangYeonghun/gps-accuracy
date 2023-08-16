import 'package:flutter/cupertino.dart';

class LatLngProv with ChangeNotifier {
  double _Lat = 0;
  double _Lng = 0;
  String _message = '위치 정보를 가져오는 중...';
  double _accuracy = 0;
  double _GpsSpeed = 0;
  double _Tick = 0;
  double _GpsDirect = 0;
  String _GpsD2T = 'null';

  double get Lat => _Lat;
  double get Lng => _Lng;
  String get message => _message;
  double get accuracy => _accuracy;
  double get GpsSpeed => _GpsSpeed;
  double get Tick => _Tick;
  double get GpsDirect => _GpsDirect;
  String get GpsD2T => _GpsD2T;

  set Lat(double newLat) {
    _Lat = newLat;
    notifyListeners();
  }

  set Lng(double newLng) {
    _Lng = newLng;
    notifyListeners();
  }

  set message(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }

  set accuracy(double newAccuracy){
    _accuracy = newAccuracy;
    notifyListeners();
  }

  set GpsSpeed(double newGpsSpeed){
    _GpsSpeed = newGpsSpeed;
    notifyListeners();
  }

  set Tick(double newTick) {
    _Tick = newTick;
    notifyListeners();
  }

  set GpsDirect(double newGpsDirect) {
    _GpsDirect = newGpsDirect;
    notifyListeners();
  }

  set GpsD2T(String newGpsD2T) {
    _GpsD2T = newGpsD2T;
    notifyListeners();
  }
}
