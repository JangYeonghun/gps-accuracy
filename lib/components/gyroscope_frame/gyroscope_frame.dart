import 'package:flutter/material.dart';
import 'package:gps/provider/gyroscope_provider/gyroscope_provider.dart';
import 'package:provider/provider.dart';

class GyroscopeFrame extends StatefulWidget {
  const GyroscopeFrame({Key? key}) : super(key: key);

  @override
  GyroscopeFrameState createState() => GyroscopeFrameState();
}

class GyroscopeFrameState extends State<GyroscopeFrame> {
  @override
  Widget build(BuildContext context) {
    final userGyroscope =
        Provider.of<GyroscopeProvider>(context).userGyroscopeValues;
    final userGyroscopeAsString = userGyroscope
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
        child: Text('UserGyroscope: $userGyroscopeAsString'),
      ),
    );
  }
}