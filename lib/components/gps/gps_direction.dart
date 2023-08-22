import 'package:latlong2/latlong.dart';
import 'dart:math';

double calculateDirection(LatLng from, LatLng to) {
  double angle = atan2(to.longitude - from.longitude, to.latitude - from.latitude);
  double degrees = angle * (180 / pi);
  double direction = (degrees + 360) % 360;

  return direction;
}
