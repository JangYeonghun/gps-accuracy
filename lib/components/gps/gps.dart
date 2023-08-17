import 'package:gps/components/gps/gpsdirection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:collection';
import 'package:latlong2/latlong.dart';
import 'package:gps/components/log/logger.dart';
import 'package:gps/components/compass.dart';

double Lat = 0;
double Lng = 0;
double accuracy = 0;
double gSpeed = 0;
double gDirect = 0;
String gD2T = 'null';


class GpsModule extends StatefulWidget {
  @override
  _GpsModuleState createState() => _GpsModuleState();
}

class _GpsModuleState extends State<GpsModule> {
  Queue<double> GpsQueue = ListQueue<double>(3);
  double tick = 0;

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 5,
  );

  @override
  void initState() {
    super.initState();
    // 위치 업데이트를 받기 위해 위치 서비스를 시작합니다.
    _startListeningToLocation();
  }

  @override
  void dispose() {
    // 위치 서비스를 중지합니다.
    _stopListeningToLocation();
    super.dispose();
  }

  void _startListeningToLocation() {
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {

      // 위치 업데이트를 받았을 때 실행되는 부분입니다.
      DateTime now = DateTime.now();
      Lat = position.latitude;
      Lng = position.longitude;
      accuracy = position.accuracy;
      tick = now.hour * 1 + now.minute / 60 + now.second / 3600;

      // Gps 기반 속도, 방향 측정
      if (GpsQueue.isNotEmpty) {
        final Distance distance = Distance();
        double oldLat = GpsQueue.removeFirst();
        double oldLng = GpsQueue.removeFirst();
        double oldTick = GpsQueue.removeFirst();
        final double meter = distance(LatLng(oldLat, oldLng), LatLng(Lat, Lng));
        double t_t = tick - oldTick;
        gSpeed = meter/t_t/1000;
        gDirect = GpsDirectionModule().calculateDirection(LatLng(oldLat, oldLng), LatLng(Lat, Lng));
        gD2T = GpsDirectionModule().D2T(gDirect);
      } else {
        gSpeed = 0;
      }
      GpsQueue.addAll([Lat, Lng, tick]);
      LogModule.logging(context);
    });
  }

  void _stopListeningToLocation() {
    print('리스너 종료');
    // 위치 업데이트 리스너를 취소합니다.
    Geolocator.getPositionStream().listen(null).cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      child: Text(
              '위도: $Lat, 경도: $Lng\n오차범위: $accuracy\n위치기반 속도: $gSpeed/h\n위치기반 이동 방향: $gDirect, $gD2T\n방향: $compDegree, $compText'),
    );
  }
}
