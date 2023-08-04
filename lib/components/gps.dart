//GPS stream data
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:provider/provider.dart';

class GpsModule extends StatefulWidget {
  @override
  _GpsModuleState createState() => _GpsModuleState();
}

class _GpsModuleState extends State<GpsModule> {
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 10,
  );

  @override
  void initState() {
    print('시작');
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

      print('업데이트');
      // 위치 업데이트를 받았을 때 실행되는 부분입니다.
      Provider.of<LatLngProv>(context, listen: false).message =
      '위도: ${position.latitude}, 경도: ${position.longitude}';
      Provider.of<LatLngProv>(context, listen: false).Lat = position.latitude;
      Provider.of<LatLngProv>(context, listen: false).Lng = position.longitude;
      Provider.of<LatLngProv>(context, listen: false).accuracy =
      '오차범위: ${position.accuracy}m';
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
          '${context.watch<LatLngProv>().message}\n${context.watch<LatLngProv>().accuracy}'),
    );
  }
}
