import 'dart:collection';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps/components/log/logger.dart';
import 'package:gps/utility/direction_to_text.dart';

double lat = 0;
double lng = 0;
double accuracy = 0;
double gSpeed = 0;
double gDirect = 0;
String gD2T = 'null';

Queue<double> gpsQueue = ListQueue<double>(3);
double tick = 0;

final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 1
);

// GPS
void onStartGps(ServiceInstance service) {

  Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position position) {
    DateTime now = DateTime.now();
    lat = position.latitude;
    lng = position.longitude;
    accuracy = position.accuracy;
    tick = now.hour * 1 + now.minute / 60 + now.second / 3600;

    if (gpsQueue.isNotEmpty) {
      double oldLat = gpsQueue.removeFirst();
      double oldLng = gpsQueue.removeFirst();
      double oldTick = gpsQueue.removeFirst();
      final double meter = Geolocator.distanceBetween(oldLat, oldLng, lat, lng);
      double tT = tick - oldTick;
      gSpeed = meter / tT / 1000;
      gDirect = position.heading;
      gD2T = directionToText(gDirect);
    } else {
      gSpeed = 0;
    }
    gpsQueue.addAll([lat, lng, tick]);
    LogModule.logging();

    service.invoke(
      'update_gps',
      {
        'lat': lat,
        'lng': lng,
        'accuracy': accuracy,
        'gSpeed': gSpeed,
        'gDirect': gDirect,
        'gD2T': gD2T,
      },
    );
  });
}