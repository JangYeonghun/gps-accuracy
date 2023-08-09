import 'package:flutter/material.dart';
import 'package:gps/provider/magnetometer_provider/magnetometer_provider.dart';
import 'package:provider/provider.dart';

class MagnetometerFrame extends StatefulWidget {
  const MagnetometerFrame({Key? key}) : super(key: key);

  @override
  _MagnetometerFrameState createState() => _MagnetometerFrameState();
}

class _MagnetometerFrameState extends State<MagnetometerFrame> {
  @override
  Widget build(BuildContext context) {
    final userMagnetometer =
        Provider.of<MagnetometerProvider>(context).userMagnetometerValues;
    final userMagnetometerAsString = userMagnetometer
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
            padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text('UserMagnetometer: $userMagnetometerAsString'),
      ),
    );
  }
}