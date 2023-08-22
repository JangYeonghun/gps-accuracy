import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps/components/compass/compass_stream.dart';
import 'package:gps/components/gps/gps_stream.dart';
import 'package:gps/components/log/logger.dart';
import 'package:gps/components/log/log_frame.dart';


class MapModule extends StatefulWidget {
  const MapModule({Key? key}) : super(key: key);

  @override
  MapModuleState createState() => MapModuleState();
}

class MapModuleState extends State<MapModule> {
  late GoogleMapController mapController;
  bool _isTracking = true;
  bool _showLog = false;
  final LatLng _center = LatLng(lat, lng);
  late Timer _rotationTimer;

  Uint8List? customMarkerIcon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCustomMarker();
      _startRotationTimer();
    });
  }

  void _loadCustomMarker() async {
    customMarkerIcon = await getBytesFromAsset("assets/img/marker.png", 130); // 이미지 경로와 width 설정 필요
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
            markers: _createMarkers(),
          ),
          Positioned(
            top: 16, // 버튼을 지도의 상단에 배치 (원하는 위치로 조정 가능)
            right: 16, // 버튼을 지도의 오른쪽에 배치 (원하는 위치로 조정 가능)
            child: ElevatedButton(
              onPressed: (){
                LogModule.initializeLogFile();
                setState(() {
                  _showLog = false;
                });
                },
              child: Text('로그 리셋'),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Switch(
              value: _isTracking,
              onChanged: (value) {
                setState(() {
                  _isTracking = value;
                });
              },
            ),
          ),
          Positioned(
            bottom: 50,
            left: 16,
            child: Switch(
              value: _showLog,
              onChanged: (value) {
                setState(() {
                  _showLog = value;
                });
              },
            ),
          ),
          if (_showLog)
            Positioned(
              bottom: 90,
              left: 5,
              right: 5,
              child: LogWindow(),
            ),
          //CompassModule(),
        ],
      ),
    );
  }

  Set<Marker> _createMarkers() {
    final LatLng currentLatLng = LatLng(lat, lng);

    Marker? customMarker;

    if (customMarkerIcon != null) {
      customMarker = Marker(
        markerId: MarkerId('customMarker'),
        position: currentLatLng,
        icon: BitmapDescriptor.fromBytes(customMarkerIcon!),
        infoWindow: InfoWindow(title: '현재 위치', snippet: '이동중'),
      );
    }

    final markers = <Marker>{};

    if (customMarker != null) {
      markers.add(customMarker);
    }

    return markers;
  }

  void _goToMyLocation() {
    final LatLng currentLatLng = LatLng(lat, lng);

    mapController.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
                target: currentLatLng,
                zoom: 17,
                bearing: compDegree,
            ),
        )
    );
  }

  void _startRotationTimer() {
    _rotationTimer = Timer.periodic(Duration(milliseconds: 1100), (timer) {
      setState(() {
        if (_isTracking) {
          _goToMyLocation();
        }
      });
    });
  }

  @override
  void dispose() {
    _rotationTimer.cancel();
    super.dispose();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}




