import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter/material.dart';
import 'package:gps/components/gps/gpsdirection.dart';

double compDegree = 0;
String compText = 'null';

class CompassModule extends StatefulWidget {
  @override
  _CompassModuleState createState() => _CompassModuleState();
}

class _CompassModuleState extends State<CompassModule> {

  @override
  void initState() {
    super.initState();
    _startListeningToCompass();
  }

  void _startListeningToCompass() {

    FlutterCompass.events?.listen((event) {
      double? compassHeading = event.heading;
      compDegree = (compassHeading! + 360) % 360;
      compText = GpsDirectionModule().D2T(compDegree);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
