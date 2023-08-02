import 'package:flutter/material.dart';
import 'package:gps/components/gps.dart';
import 'package:gps/components/permission.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:gps/components/map.dart';

void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => LatLngProv()),
      ],
        child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    PermissionModule.checkPermission();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: MapModule(),
        bottomNavigationBar: GpsModule(),
      ),
    );
  }
}
