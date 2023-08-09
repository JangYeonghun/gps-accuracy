import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps/components/gps.dart';

class GpsChecker extends StatefulWidget {
  const GpsChecker({super.key});

  @override
  State<GpsChecker> createState() => _GpsCheckerState();
}

class _GpsCheckerState extends State<GpsChecker> {

  bool _pass = false;

  Future<void> check() async {
    Future<bool> _isEnabled = Geolocator.isLocationServiceEnabled();
    if (await _isEnabled) {
      _pass = true;
    } else {
      _pass = false;
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return _pass ? GpsModule() : AlertDialog(
      content: Text('실행에 위치서비스가 필요합니다.'),
      actions: [
        TextButton(onPressed: (){
          check();
        },
        child: Text('켰어요!'))
      ],
    );
  }
}
