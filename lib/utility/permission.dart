import 'package:permission_handler/permission_handler.dart';

class PermissionModule {
  static Future<bool> checkPermissions() async {
    // 위치 권한 확인
    PermissionStatus locationPermission = await Permission.location.status;
    // 활동 인식 권한 확인
    PermissionStatus activityRecogPermission = await Permission.activityRecognition.status;

    if (locationPermission == PermissionStatus.granted && activityRecogPermission == PermissionStatus.granted) {
      return true;
    } else {
      // 위치 권한 요청
      PermissionStatus locationPermissionStatus = await Permission.location.request();
      // 활동 인식 권한 요청
      PermissionStatus activityRecogPermissionStatus = await Permission.activityRecognition.request();

      if (locationPermissionStatus.isGranted && activityRecogPermissionStatus.isGranted) {
        // 권한이 승인되면 true를 반환
        return true;
      } else {
        // 사용자에게 권한이 필요하다고 알림을 표시하고 설정으로 이동하도록 안내
        openAppSettings();
        return false;
      }
    }
  }
}
