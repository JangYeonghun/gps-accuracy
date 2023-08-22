import 'dart:async';
import 'dart:collection'; // Queue를 사용하기 위해 추가
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerProvider with ChangeNotifier {
  final int _maxQueueSize = 100; // 큐의 최대 크기 설정 (원하는 크기로 변경 가능)
  final Queue<List<double>> _accelerometerQueue = Queue<List<double>>();
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  AccelerometerProvider() {
    _streamSubscriptions.add(
      accelerometerEvents.listen(
            (AccelerometerEvent event) {
          // 센서 값들을 리스트로 저장하여 큐에 추가
          List<double> accelerometerValues = [event.x, event.y, event.z];
          _accelerometerQueue.add(accelerometerValues);

          // 큐의 크기가 최대 크기를 초과할 경우 가장 오래된 값을 제거
          if (_accelerometerQueue.length > _maxQueueSize) {
            _accelerometerQueue.removeFirst();
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
  List<double>? get accelerometerValues {
    if (_accelerometerQueue.isEmpty) {
      return null;
    }
    return _accelerometerQueue.last;
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
