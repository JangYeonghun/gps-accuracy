import 'package:permission_handler/permission_handler.dart';

class PermissionModule {
  static Future<bool> checkPermission() async {
    // 위치 권한 확인
    PermissionStatus locationPermission = await Permission.location.status;

    if (locationPermission == PermissionStatus.granted) {
      // 신체 활동 권한 확인
      PermissionStatus activityPermission = await Permission.activityRecognition.status;

      if (activityPermission == PermissionStatus.granted) {
        return true;
      } else {
        // 신체 활동 권한 요청
        PermissionStatus permissionStatus = await Permission.activityRecognition.request();

        if (permissionStatus.isGranted) {
          // 권한이 승인되면 true를 반환
          return true;
        } else {
          // 사용자에게 신체 활동 권한이 필요하다고 알림을 표시하고 설정으로 이동하도록 안내
          openAppSettings();
          return false;
        }
      }
    } else {
      // 사용자에게 위치 권한이 필요하다고 알림을 표시하고 설정으로 이동하도록 안내
      openAppSettings();
      return false;
    }
  }
}
