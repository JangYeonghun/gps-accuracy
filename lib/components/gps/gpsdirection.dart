import 'package:latlong2/latlong.dart';
import 'dart:math';

class GpsDirectionModule {
  double calculateDirection(LatLng from, LatLng to) {
    double angle = atan2(to.longitude - from.longitude, to.latitude - from.latitude);
    double degrees = angle * (180 / pi);
    double direction = (degrees + 360) % 360;

    return direction;
  }

  String directionToText(direction) {
    String dirText = '';

    if (0 <= direction && direction < 22.5 || 337.5 <= direction && direction <=360) {
      dirText = 'N';
    } else if (22.5 <= direction && direction < 67.5) {
      dirText = 'NE';
    } else if (67.6 <= direction && direction < 112.5) {
      dirText = 'E';
    } else if (112.5 <= direction && direction < 157.5) {
      dirText = 'SE';
    } else if (157.5 <= direction && direction < 202.5) {
      dirText = 'S';
    } else if (202.5 <= direction && direction < 247.5) {
      dirText = 'SW';
    } else if (247.5 <= direction && direction < 292.5) {
      dirText = 'W';
    } else if (292.5 <= direction && direction < 337.5) {
      dirText = 'NW';
    }

    return dirText;
  }
}
