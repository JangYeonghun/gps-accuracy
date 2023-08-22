import 'package:flutter/material.dart';
import 'package:gps/components/compass_stream.dart';
import 'package:gps/components/gps/gps_stream.dart';

Widget BackgroundDataFrame() {
  return SizedBox.fromSize(
    child: Text(
        '위도: $lat, 경도: $lng\n오차범위: ${accuracy}m\n위치기반 속도: ${gSpeed}km/h\n위치기반 이동 방향: $gDirect, $gD2T\n방향: $compDegree, $compText'),
  );
}