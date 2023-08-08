import 'package:flutter/material.dart';
import 'package:gps/provider/accelerometer_provider/useraccelerometer_provider.dart';
import 'package:provider/provider.dart';

class UserAccelerometerFrame extends StatefulWidget {
  const UserAccelerometerFrame({Key? key}) : super(key: key);

  @override
  _UserAccelerometerFrameState createState() => _UserAccelerometerFrameState();
}

class _UserAccelerometerFrameState extends State<UserAccelerometerFrame> {
  @override
  Widget build(BuildContext context) {
    final userAccelerometer =
        Provider.of<UserAccelerometerProvider>(context).userAccelerometerValues;
    final userAccelerometerAsString = userAccelerometer
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
        child: Text('UserAccelerometer: $userAccelerometerAsString'),
      ),
    );
  }
}