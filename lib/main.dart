import 'package:flutter/material.dart';
import 'package:gps/components/gps.dart';
import 'package:gps/components/permission.dart';
import 'package:gps/provider/gyroscope_provider/gyroscope_provider.dart';
import 'package:gps/provider/magnetometer_provider/magnetometer_provider.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:gps/components/map.dart';
import 'package:gps/provider/accelerometer_provider/accelerometer_provider.dart';
import 'package:gps/class/sensorfusion/simple_kalman_filter.dart';
import 'components/accelerometer_frame/accelerometer_frame.dart';
import 'components/gyroscope_frame/gyroscope_frame.dart';
import 'components/magnetometer_frame/magnetometer_frame.dart';

import 'package:gps/class/sensorfusion/simple_kalman_filter.dart'; // Kalman 필터를 정의한 파일 임포트
import 'package:gps/class/sensorfusion/dead_reckoning.dart'; // 클래스 파일로 로직 이동

// home: DeadReckoningApp(), 이렇게 부르면 됌

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LatLngProv()),
        ChangeNotifierProvider(create: (_) => AccelerometerProvider()),
        ChangeNotifierProvider(create: (_) => GyroscopeProvider()),
        ChangeNotifierProvider(create: (_) => MagnetometerProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    PermissionModule.checkPermission();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
            MapModule(),
            Positioned.fill(
              top: 0,
              child: AccelerometerFrame(),
            ),
            Positioned.fill(
              top: 40,
              child: GyroscopeFrame(),
            ),
            Positioned.fill(
              top: 80,
              child: MagnetometerFrame(),
            ),
            DeadReckoningApp(), // 위치 추정과 Kalman 필터를 담당하는 DeadReckoningApp 추가
            Positioned.fill(
              top: 100,
              child: AccelerometerFrame(),
            ),
          ],
        ),
        
        bottomNavigationBar: GpsModule(),
      ),
    );
  }
}
