import 'dart:async';
import 'dart:collection'; // Queue를 사용하기 위해 추가
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MagnetometerProvider with ChangeNotifier {
  final int _maxQueueSize = 100; // 큐의 최대 크기 설정 (원하는 크기로 변경 가능)
  final Queue<List<double>> _magnetometerQueue = Queue<List<double>>();
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  MagnetometerProvider() {
    _streamSubscriptions.add(
      magnetometerEvents.listen(
            (MagnetometerEvent  event) {
          // 센서 값들을 리스트로 저장하여 큐에 추가
          List<double> magnetometerValues = [event.x, event.y, event.z];
          _magnetometerQueue.add(magnetometerValues);

          // 큐의 크기가 최대 크기를 초과할 경우 가장 오래된 값을 제거
          if (_magnetometerQueue.length > _maxQueueSize) {
            _magnetometerQueue.removeFirst();
          }

          notifyListeners(); // 상태 변화 알림
        },
        onError: (e) {
          // Handle error if necessary
        },
        cancelOnError: true,
      ),
    );
  }

  // 센서 값을 반환하는 메서드를 수정하여 큐에서 값을 꺼내서 반환
  List<double>? get userMagnetometerValues {
    if (_magnetometerQueue.isEmpty) {
      return null;
    }
    return _magnetometerQueue.last;
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
