import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'simple_kalman_filter.dart';
import 'package:gps/provider/accelerometer_provider/accelerometer_provider.dart';
import 'package:gps/provider/gyroscope_provider/gyroscope_provider.dart';
import 'package:gps/provider/LatLngProvider.dart';

class DeadReckoningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccelerometerProvider>(
          create: (_) => AccelerometerProvider(),
        ),
        ChangeNotifierProvider<GyroscopeProvider>(
          create: (_) => GyroscopeProvider(),
        ),
        ChangeNotifierProvider<LatLngProv>(
          create: (_) => LatLngProv(),
        ),
      ],
      child: MaterialApp(
        home: _DeadReckoningAppState(),
      ),
    );
  }
}

class _DeadReckoningAppState extends StatefulWidget {
  @override
  __DeadReckoningAppStateState createState() => __DeadReckoningAppStateState();
}

class __DeadReckoningAppStateState extends State<_DeadReckoningAppState> {
  double speed = 0.0;
  double distance = 0.0;

  // Kalman 필터 변수 추가
  SimpleKalmanFilter latKalmanFilter = SimpleKalmanFilter(0.01, 0.1);
  SimpleKalmanFilter lonKalmanFilter = SimpleKalmanFilter(0.01, 0.1);

  @override
  Widget build(BuildContext context) {
    final accelerometerProvider = Provider.of<AccelerometerProvider>(context);
    final gyroscopeProvider = Provider.of<GyroscopeProvider>(context);
    final latLngProvider = Provider.of<LatLngProv>(context); // LatLngProv 인스턴스 가져오기

    // 가속도계와 자이로스코프 데이터 가져오기
    final accelerometerValues = accelerometerProvider.userAccelerometerValues;
    final gyroscopeValues = gyroscopeProvider.userGyroscopeValues;

    // LatLngProv 인스턴스의 멤버 변수인 Lat와 Lng를 사용하여 위도와 경도 정보 가져오기
    double latitude = latLngProvider.Lat;
    double longitude = latLngProvider.Lng;

    // 가속도계와 자이로스코프 데이터를 이용하여 위치 추정 등 로직을 수행
    if (accelerometerValues != null && gyroscopeValues != null) {
      // 가속도계와 자이로스코프 데이터를 이용하여 속도 및 이동 거리 추정
      double timeInterval = 0.1; // 샘플링 간격 (예: 0.1초)
      double accelerationX = accelerometerValues[0]; // X축 가속도 데이터 사용
      double accelerationY = accelerometerValues[1]; // Y축 가속도 데이터 사용
      double accelerationZ = accelerometerValues[2]; // Z축 가속도 데이터 사용
      double angularSpeedX = gyroscopeValues[0]; // X축 자이로스코프 데이터 사용
      double angularSpeedY = gyroscopeValues[1]; // Y축 자이로스코프 데이터 사용
      double angularSpeedZ = gyroscopeValues[2]; // Z축 자이로스코프 데이터 사용

      // 속도 추정 (적분)
      speed += (accelerationX * timeInterval);
      speed += (accelerationY * timeInterval);
      speed += (accelerationZ * timeInterval);

      // 이동 거리 추정 (적분)
      distance += (speed * timeInterval);

      // 위치 갱신 (이동 거리를 현재 위치에 반영)
      latitude += (distance / 111000.0); // 1도는 약 111km

      // Kalman 필터를 사용하여 위치 추정 보정
      latitude = latKalmanFilter.filter(latitude);
      longitude = lonKalmanFilter.filter(longitude);

      // LatLngProv에 위치 정보 업데이트
      // setState() 호출을 빌드가 완료된 후로 미룸
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        latLngProvider.Lat = latitude;
        latLngProvider.Lng = longitude;
      });
    }

    // 정수로 변환하여 출력
    int roundedSpeed = speed.toInt();
    int roundedDistance = distance.toInt();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('현재 위도: $latitude', style: TextStyle(fontSize: 14)),
          Text('현재 경도: $longitude', style: TextStyle(fontSize: 14)),
          Text('현재 속도: $roundedSpeed m/s', style: TextStyle(fontSize: 14)),
          Text('이동 거리: $roundedDistance m', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
