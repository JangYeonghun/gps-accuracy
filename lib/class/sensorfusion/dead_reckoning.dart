import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gps/class/sensorfusion/simple_kalman_filter.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/accelerometer_provider/useraccelerometer_provider.dart';
import 'package:gps/provider/gyroscope_provider/gyroscope_provider.dart';

class DeadReckoningApp extends StatelessWidget {
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
  double _currentSpeed = 0.0; // 현재 속도
  double _currentDirection = 0.0; // 현재 방향 (각도)

  @override
  void initState() {
    super.initState();
    // GyroscopeProvider와 UserAccelerometerProvider를 Provider로부터 가져옴
    final gyroscopeProvider = Provider.of<GyroscopeProvider>(context, listen: false);
    final useraccelerometerProvider = Provider.of<UserAccelerometerProvider>(context, listen: false);

    // 센서 데이터 수집 및 계산 로직
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      List<double>? gyroscopeValues = gyroscopeProvider.userGyroscopeValues;
      List<double>? useraccelerometerValues = useraccelerometerProvider.userAccelerometerValues;

      double someConversionFactor = 0.1;

      if (gyroscopeValues != null && useraccelerometerValues != null) {
        // 가속도 센서 값
        double useraccelerationX = useraccelerometerValues[0];
        double useraccelerationY = useraccelerometerValues[1];
        double useraccelerationZ = useraccelerometerValues[2];

        // 가속도 센서 xyz 좌표가 0.1 ~ -0.1 사이면 정지로 판단
        if (useraccelerationX > -0.1 && useraccelerationX < 0.1 &&
            useraccelerationY > -0.1 && useraccelerationY < 0.1 &&
            useraccelerationZ > -0.1 && useraccelerationZ < 0.1) {
          _currentSpeed = 0.0;
          _currentDirection = gyroscopeValues[0]; // 자이로스코프의 x축 각도를 방향으로 설정
        } else if (useraccelerationX >= 0.1) {
          // 0.1 이상이면 직진
          _currentSpeed = useraccelerationX * someConversionFactor; // 가속도 값을 속도로 변환 (변환 계수 필요)
          _currentDirection = gyroscopeValues[0];
        } else if (useraccelerationX <= -0.1) {
          // -0.1 이하이면 후진
          _currentSpeed = -useraccelerationX * someConversionFactor; // 가속도 값을 속도로 변환 (변환 계수 필요)
          _currentDirection = gyroscopeValues[0];
        }
      }
    });
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
          'Current Speed: $_currentSpeed\n'
          'Current Direction: $_currentDirection',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}