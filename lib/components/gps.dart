import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class GpsModule extends StatefulWidget {
  @override
  _GpsModule createState() => _GpsModule();
}

class _GpsModule extends State<GpsModule> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _getGps();
    });
  }


  @override
  void dispose() {
    // 위젯이 dispose 될 때 타이머 중지
    _timer?.cancel();
    super.dispose();
  }


  Future<void> _getGps() async {
    try {
      // 권한이 승인되면 위치 정보 가져오기
      Geolocator geolocator = Geolocator();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // 위도와 경도를 문자열로 변환하여 출력
      setState(() {
        Provider.of<LatLngProv>(context, listen: false).message = '위도: ${position.latitude}, 경도: ${position.longitude}';
        Provider.of<LatLngProv>(context, listen: false).Lat = position.latitude;
        Provider.of<LatLngProv>(context, listen: false).Lng = position.longitude;
        Provider.of<LatLngProv>(context, listen: false).accuracy = '오차범위: ${position.accuracy}m';
      });
    } catch (e) {
      setState(() {
        Provider.of<LatLngProv>(context, listen: false).message = '위치 정보를 가져오는데 실패했습니다: $e';
      });
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
        child: Text('${context.watch<LatLngProv>().message}\n${context.watch<LatLngProv>().accuracy}'),
    );
  }
}
