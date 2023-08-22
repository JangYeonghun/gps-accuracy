import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:gps/utility/direction_to_text.dart';

double compDegree = 0;
String compText = 'null';

void onStartCompass(ServiceInstance service) {

  FlutterCompass.events?.listen((event) {
    double? compassHeading = event.heading;
    compDegree = (compassHeading! + 360) % 360;
    compText = directionToText(compDegree);
    service.invoke(
      'update_compass',
      {
        'compDegree': compDegree,
        'compText': compText
      },
    );
  });
}