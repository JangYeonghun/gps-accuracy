import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:gps/provider/CompassProvider.dart';
import 'package:gps/components/gpsdirection.dart';

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
      final compProv = Provider.of<CompProv>(context, listen: false);
      compProv.Compass = (compassHeading! + 360) % 360;
      ;
      compProv.CompassText = GpsDirectionModule().Direction2Text(compProv.Compass);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
