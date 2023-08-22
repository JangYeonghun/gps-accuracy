import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/magnetometer_provider/magnetometer_provider.dart';

class DeadReckoningApp extends StatelessWidget {
  const DeadReckoningApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DeadReckoningAppState();
  }
}

class _DeadReckoningAppState extends StatefulWidget {
  @override
  __DeadReckoningAppStateState createState() => __DeadReckoningAppStateState();
}

class __DeadReckoningAppStateState extends State<_DeadReckoningAppState> {
  double _currentDirection = 0.0; // 현재 방향 (각도)

  @override
  void initState() {
    super.initState();
    // MagnetometerProvider를 Provider로부터 가져옴
    final magnetometerProvider = Provider.of<MagnetometerProvider>(context, listen: false);

    // 센서 데이터 수집 및 계산 로직
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      List<double>? magnetometerValues = magnetometerProvider.userMagnetometerValues;

      if (magnetometerValues != null) {
        // 자기센서의 Z 축 값을 방향으로 설정
        _currentDirection = _calculateDirection(magnetometerValues);
      }

      // 방향값을 갱신하려면 setState를 호출하여 변경된 값을 UI에 반영합니다.
      setState(() {
        _currentDirection = _currentDirection;
      });
    });
  }

  // 자기센서 값으로 방향 계산하는 메서드
  double _calculateDirection(List<double> magnetometerValues) {
    double x = magnetometerValues[0];
    double y = magnetometerValues[1];

    // x, y 값으로부터 방향(각도) 계산 (예시로 단순 계산)
    // 실제로는 센서 퓨전 알고리즘을 사용하는 것이 더 정확합니다.
    double direction = -180 * atan2(y, x) / pi;

    return direction;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          '현재 방향: $_currentDirection',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
