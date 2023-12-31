import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps/components/background/background_data_frame.dart';

class GpsChecker extends StatefulWidget {
  const GpsChecker({super.key});

  @override
  State<GpsChecker> createState() => _GpsCheckerState();
}

class _GpsCheckerState extends State<GpsChecker> {
  bool _pass = false;
  bool _click = false;

  Future<void> check() async {
    Future<bool> isEnabled = Geolocator.isLocationServiceEnabled();
    if (await isEnabled) {
      _pass = true;
    } else {
      _pass = false;
    }
    setState(() {
    });
  }

  void click() {
    _click = true;
    check();
    if (!_pass) {
      _click = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    check();
    return _pass&&_click ? BackgroundDataFrame() : AlertDialog(
      content: Text('실행에 위치서비스가 필요합니다.'),
      actions: [
        TextButton(onPressed: (){
          click();
        },
            child: Text('켰어요!'))
      ],
    );
  }
}