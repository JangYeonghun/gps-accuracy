import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:gps/provider/LogProvider.dart';
import 'package:gps/provider/accelerometer_provider/accelerometer_provider.dart';
import 'package:gps/provider/gyroscope_provider/gyroscope_provider.dart';
import 'package:gps/provider/magnetometer_provider/magnetometer_provider.dart';


class LoggerModule {

  Future<void> LatLngLogging(BuildContext context) async {
    final DateTime now = DateTime.now();
    final LatLngProv gpsProvider = Provider.of<LatLngProv>(context, listen: true);

    gpsProvider.addListener(() {
      Provider.of<LogProv>(context).LatLngLog += '시간: ${now} | 위도: ${gpsProvider.Lat} | 경도: ${gpsProvider.Lng}\n';
      print('a');
    });
  }

  Future<void> SensorLogging(BuildContext context) async {
    DateTime now = DateTime.now();
    final AccelerometerProvider accProvider = Provider.of<AccelerometerProvider>(context, listen: true);
    final MagnetometerProvider magProvider = Provider.of<MagnetometerProvider>(context, listen: true);
    final GyroscopeProvider gyProvider = Provider.of<GyroscopeProvider>(context, listen: true);

    accProvider.addListener(() {
      Provider.of<LogProv>(context).SensorLog += '시간 : ${now} | 가속도계: ${accProvider.userAccelerometerValues} | 자이로스코프: ${gyProvider.userGyroscopeValues} | 자기계: ${magProvider.userMagnetometerValues}\n';
      print('b');
    });
  }
}
