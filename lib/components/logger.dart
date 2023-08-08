import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:gps/provider/LogProvider.dart'; // LogProvider를 import해야 합니다.
import 'package:gps/provider/accelerometer_provider/accelerometer_provider.dart';
import 'package:gps/provider/gyroscope_provider/gyroscope_provider.dart';
import 'package:gps/provider/magnetometer_provider/magnetometer_provider.dart';
import 'package:gps/provider/accelerometer_provider/useraccelerometer_provider.dart';

int num = 1;

class LogModule {
  static void logging(BuildContext context) {
    final DateTime now = DateTime.now();
    final gpsProv = Provider.of<LatLngProv>(context, listen: false);
    final accProv = Provider.of<AccelerometerProvider>(context, listen: false);
    final uaccProv = Provider.of<UserAccelerometerProvider>(context, listen: false);
    final gyProv = Provider.of<GyroscopeProvider>(context, listen: false);
    final mgProv = Provider.of<MagnetometerProvider>(context, listen: false);
    final logProv = Provider.of<LogProv>(context, listen: false);

    print('======================================================================================================');
    print('$now     [Log$num]');
    print('Coord: ${gpsProv.Lat}, ${gpsProv.Lng}');
    print('Accel: ${accProv.accelerometerValues?[0]}, ${accProv.accelerometerValues?[1]}, ${accProv.accelerometerValues?[2]}');
    print('U_Accel: ${uaccProv.userAccelerometerValues?[0]}, ${uaccProv.userAccelerometerValues?[1]}, ${uaccProv.userAccelerometerValues?[2]}');
    print('Gyro: ${gyProv.userGyroscopeValues?[0]}, ${gyProv.userGyroscopeValues?[1]}, ${gyProv.userGyroscopeValues?[2]}');
    print('Mag: ${mgProv.userMagnetometerValues?[0]}, ${mgProv.userMagnetometerValues?[1]}, ${mgProv.userMagnetometerValues?[2]}');
    print('======================================================================================================');

    logProv.Log += '===============================\n';
    logProv.Log += '$now     [Log$num]\n\n';
    logProv.Log += '[Location]\n${gpsProv.Lat}, ${gpsProv.Lng}\n\n';
    logProv.Log += '[Accelerometer]\n${accProv.accelerometerValues?[0]}\n${accProv.accelerometerValues?[1]}\n${accProv.accelerometerValues?[2]}\n\n';
    logProv.Log += '[Accelerometer_User]\n${uaccProv.userAccelerometerValues?[0]}\n${uaccProv.userAccelerometerValues?[1]}\n${uaccProv.userAccelerometerValues?[2]}\n\n';
    logProv.Log += '[Gyroscope]\n${gyProv.userGyroscopeValues?[0]}\n${gyProv.userGyroscopeValues?[1]}\n${gyProv.userGyroscopeValues?[2]}\n\n';
    logProv.Log += '[Magentometer]\n${mgProv.userMagnetometerValues?[0]}\n${mgProv.userMagnetometerValues?[1]}\n${mgProv.userMagnetometerValues?[2]}\n';
    logProv.Log += '===============================\n\n';

    num += 1;
  }
}
