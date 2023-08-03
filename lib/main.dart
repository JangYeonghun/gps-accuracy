import 'package:flutter/material.dart';
import 'package:gps/components/gps.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:gps/components/map.dart';
import 'package:gps/components/permission.dart';

void main() async {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => LatLngProv()),
      ],
        child: MyApp(),
    ),
  );
  PermissionModule.checkPermission();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GPS Accuracy'),
          backgroundColor: Colors.green[700],
        ),
        body: MapModule(),
        bottomNavigationBar: GpsModule(),
      ),
    );
  }
}
