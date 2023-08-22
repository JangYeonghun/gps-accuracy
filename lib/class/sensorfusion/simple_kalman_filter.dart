class SimpleKalmanFilter {
  final double _processNoise; // 프로세스 노이즈 (Q)
  final double _measurementNoise; // 측정 노이즈 (R)
  double _stateEstimate = 0.0; // 현재 상태 추정 값 (x̂)
  double _errorCovariance = 1.0; // 오차 공분산 (P)

  // 생성자
  SimpleKalmanFilter(this._processNoise, this._measurementNoise);

  // 필터링 메서드
  double filter(double measurement) {
    // 예측 단계
    double predictedEstimate = _stateEstimate;
    double predictedErrorCovariance = _errorCovariance + _processNoise;

    // 업데이트 단계
    double kalmanGain = predictedErrorCovariance / (predictedErrorCovariance + _measurementNoise);
    _stateEstimate = predictedEstimate + kalmanGain * (measurement - predictedEstimate);
    _errorCovariance = (1 - kalmanGain) * predictedErrorCovariance;

    return _stateEstimate;
  }
}
