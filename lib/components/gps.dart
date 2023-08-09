import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:provider/provider.dart';
import 'dart:collection';
import 'package:latlong2/latlong.dart';
import 'package:gps/components/logger.dart';

class GpsModule extends StatefulWidget {
  @override
  _GpsModuleState createState() => _GpsModuleState();
}

class _GpsModuleState extends State<GpsModule> {
  Queue<double> GpsQueue = ListQueue<double>(3);

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
      final gpsProvider = Provider.of<LatLngProv>(context, listen: false);

      // 위치 업데이트를 받았을 때 실행되는 부분입니다.
      gpsProvider.message = '위도: ${position.latitude}, 경도: ${position.longitude}';
      gpsProvider.Lat = position.latitude;
      gpsProvider.Lng = position.longitude;
      gpsProvider.accuracy = position.accuracy;
      DateTime now = DateTime.now();
      gpsProvider.Tick = now.hour * 1 + now.minute / 60 + now.second / 3600;

      // Gps 기반 속도 측정
      if (GpsQueue.isNotEmpty) {
        final Distance distance = Distance();
        double OldLat = GpsQueue.removeFirst();
        double OldLng = GpsQueue.removeFirst();
        double OldTm = GpsQueue.removeFirst();
        final double meter = distance(LatLng(OldLat, OldLng), LatLng(gpsProvider.Lat, gpsProvider.Lng));
        double t_t = gpsProvider.Tick - OldTm;
        gpsProvider.GpsSpeed = meter/t_t/1000;
      } else {
        gpsProvider.GpsSpeed = 0;
      }
      GpsQueue.addAll([gpsProvider.Lat, gpsProvider.Lng, gpsProvider.Tick]);
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
              '${context.watch<LatLngProv>().message}\n오차범위: ${context.watch<LatLngProv>().accuracy}m\n위치기반 속도: ${context.watch<LatLngProv>().GpsSpeed}km/h'),
    );
  }
}
