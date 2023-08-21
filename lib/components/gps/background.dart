import 'package:flutter_compass/flutter_compass.dart';
import 'package:gps/components/gps/gpsdirection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:collection';
import 'package:latlong2/latlong.dart';
import 'package:gps/components/log/logger.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

double Lat = 0;
double Lng = 0;
double accuracy = 0;
double gSpeed = 0;
double gDirect = 0;
String gD2T = 'null';

double compDegree = 0;
String compText = 'null';

class BackgroundModule extends StatefulWidget {
  @override
  _BackgroundModuleState createState() => _BackgroundModuleState();
}

class _BackgroundModuleState extends State<BackgroundModule> {

  @override
  void initState() {
    print('================================================check');
    super.initState();
    initializeService();
    FlutterBackgroundService().on('update_gps').listen((event) {
      setState(() {
        Lat = event!['Lat'];
        Lng = event!['Lng'];
        accuracy = event!['accuracy'];
        gSpeed = event!['gSpeed'];
        gDirect = event!['gDirect'];
        gD2T = event!['gD2T'];
      });
    });

    FlutterBackgroundService().on('update_compass').listen((event) {
      setState(() {
        compDegree = event!['compDegree'];
        compText = event!['compText'];
      });
    });
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    print('================================================check2');

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
    print('================================================check3');

    service.startService();
  }

  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final log = preferences.getStringList('log') ?? <String>[];
    log.add(DateTime.now().toIso8601String());
    await preferences.setStringList('log', log);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      child: Text(
          '위도: $Lat, 경도: $Lng\n오차범위: ${accuracy}m\n위치기반 속도: ${gSpeed}km/h\n위치기반 이동 방향: $gDirect, $gD2T\n방향: $compDegree, $compText'),
    );
  }
}

Queue<double> GpsQueue = ListQueue<double>(3);
double tick = 0;

final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.bestForNavigation,
  distanceFilter: 1,
);

void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences.getInstance().then((preferences) {
    preferences.setString('hello', 'world');
  });

  StreamSubscription<Position> _positionStream =
  Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position position) {
    DateTime now = DateTime.now();
    Lat = position.latitude;
    Lng = position.longitude;
    accuracy = position.accuracy;
    tick = now.hour * 1 + now.minute / 60 + now.second / 3600;

    print('================================================check4');

    if (GpsQueue.isNotEmpty) {
      final Distance distance = Distance();
      double oldLat = GpsQueue.removeFirst();
      double oldLng = GpsQueue.removeFirst();
      double oldTick = GpsQueue.removeFirst();
      final double meter = distance(
          LatLng(oldLat, oldLng), LatLng(Lat, Lng));
      double tT = tick - oldTick;
      gSpeed = meter / tT / 1000;
      gDirect = GpsDirectionModule().calculateDirection(
          LatLng(oldLat, oldLng), LatLng(Lat, Lng));
      gD2T = GpsDirectionModule().D2T(gDirect);
    } else {
      gSpeed = 0;
    }
    GpsQueue.addAll([Lat, Lng, tick]);
    LogModule.logging();

    service.invoke(
      'update_gps',
      {
        'datetime': DateTime.now().toIso8601String(),
        'Lat': position.latitude,
        'Lng': position.longitude,
        'accuracy': position.accuracy,
        'gSpeed': gSpeed,
        'gDirect': gDirect,
        'gD2T': gD2T,
        'compDegree': compDegree,
        'compText': compText
      },
    );
  });

  // Compass
  FlutterCompass.events?.listen((event) {
    double? compassHeading = event.heading;
    compDegree = (compassHeading! + 360) % 360;
    compText = GpsDirectionModule().D2T(compDegree);
    service.invoke(
      'update_compass',
      {
        'compDegree': compDegree,
        'compText': compText
      },
    );

  });

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        // 여기에 원하는 작업을 추가하세요.
      }
    }

    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        'current_date': DateTime.now().toIso8601String(),
        'device': device,
      },
    );
  });
}
