import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:gps/provider/LogProvider.dart'; // LogProvider를 import해야 합니다.
import 'package:gps/provider/accelerometer_provider/accelerometer_provider.dart';
import 'package:gps/provider/gyroscope_provider/gyroscope_provider.dart';
import 'package:gps/provider/magnetometer_provider/magnetometer_provider.dart';
import 'package:gps/provider/accelerometer_provider/useraccelerometer_provider.dart';

int index = 1;

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
    print('$now     [Log$index]');
    print('Coord: ${gpsProv.Lat}, ${gpsProv.Lng}');
    print('Accel: ${accProv.accelerometerValues?[0]}, ${accProv.accelerometerValues?[1]}, ${accProv.accelerometerValues?[2]}');
    print('U_Accel: ${uaccProv.userAccelerometerValues?[0]}, ${uaccProv.userAccelerometerValues?[1]}, ${uaccProv.userAccelerometerValues?[2]}');
    print('Gyro: ${gyProv.userGyroscopeValues?[0]}, ${gyProv.userGyroscopeValues?[1]}, ${gyProv.userGyroscopeValues?[2]}');
    print('Mag: ${mgProv.userMagnetometerValues?[0]}, ${mgProv.userMagnetometerValues?[1]}, ${mgProv.userMagnetometerValues?[2]}');
    print('======================================================================================================');

    logProv.Log += '===============================\n';
    logProv.Log += '$now     [Log$index]\n\n';
    logProv.Log += '[Location]\nLat: ${gpsProv.Lat}, Lng: ${gpsProv.Lng}\n\n';
    logProv.Log += '[Accelerometer]\nX: ${accProv.accelerometerValues?[0]}\nY: ${accProv.accelerometerValues?[1]}\nZ: ${accProv.accelerometerValues?[2]}\n\n';
    logProv.Log += '[Accelerometer_User]\nX: ${uaccProv.userAccelerometerValues?[0]}\nY: ${uaccProv.userAccelerometerValues?[1]}\nZ: ${uaccProv.userAccelerometerValues?[2]}\n\n';
    logProv.Log += '[Gyroscope]\nX: ${gyProv.userGyroscopeValues?[0]}\nY: ${gyProv.userGyroscopeValues?[1]}\nZ: ${gyProv.userGyroscopeValues?[2]}\n\n';
    logProv.Log += '[Magentometer]\nX: ${mgProv.userMagnetometerValues?[0]}\nY: ${mgProv.userMagnetometerValues?[1]}\nZ: ${mgProv.userMagnetometerValues?[2]}\n';
    logProv.Log += '===============================\n\n';

    index += 1;
  }
}
