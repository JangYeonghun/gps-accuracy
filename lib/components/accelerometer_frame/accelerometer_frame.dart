import 'package:flutter/material.dart';
import 'package:gps/provider/accelerometer_provider/accelerometer_provider.dart';
import 'package:provider/provider.dart';

class AccelerometerFrame extends StatefulWidget {
  const AccelerometerFrame({Key? key}) : super(key: key);

  @override
  _AccelerometerFrameState createState() => _AccelerometerFrameState();
}

class _AccelerometerFrameState extends State<AccelerometerFrame> {
  @override
  Widget build(BuildContext context) {
    final Accelerometer =
        Provider.of<AccelerometerProvider>(context).accelerometerValues;
    final AccelerometerAsString = Accelerometer
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
        child: Text('Accelerometer: $AccelerometerAsString'),
      ),
    );
  }
}