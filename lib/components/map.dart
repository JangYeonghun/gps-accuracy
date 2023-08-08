import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gps/provider/LatLngProvider.dart';
import 'package:gps/components/logwindow.dart';

class MapModule extends StatefulWidget {
  const MapModule({Key? key}) : super(key: key);

  @override
  _MapModuleState createState() => _MapModuleState();
}

class _MapModuleState extends State<MapModule> {
  late GoogleMapController mapController;
  bool _isTracking = true;
  bool _showLog = false;
  Timer? _timer;
  final LatLng _center = LatLng(0, 0);

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
              onPressed: _goToMyLocation,
              child: Text('내 위치로 이동'),
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
              }
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
                  }
              )
          ),
          if (_showLog)
            Positioned(
              bottom: 5,
              left: 70,
              right: 50,
              child: LogWindow(),
            ),
        ],
      ),
    );
  }



  Set<Marker> _createMarkers() {
    final LatLngProv gpsProvider = Provider.of<LatLngProv>(context, listen: true);
    final LatLng currentLatLng = LatLng(gpsProvider.Lat, gpsProvider.Lng);

    final Marker currentMarker = Marker(
      markerId: MarkerId('currentLocation'),
      position: currentLatLng,
    );

    if (_isTracking) {
      _goToMyLocation();
    }

    return {currentMarker};
  }

  Future<void> _goToMyLocation() async {
    final LatLngProv gpsProvider = Provider.of<LatLngProv>(context, listen: false);
    final LatLng currentLatLng = LatLng(gpsProvider.Lat, gpsProvider.Lng);

    mapController.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 17));
  }
}

