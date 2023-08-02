import 'package:permission_handler/permission_handler.dart';

class PermissionModule {
  static Future<bool> checkPermission() async {
    // 위치 권한 확인
    PermissionStatus permission = await Permission.location.status;

    if (permission == PermissionStatus.granted) {
      return true;
    } else {
      // 위치 권한 요청
      PermissionStatus permissionStatus = await Permission.location.request();

      if (permissionStatus.isGranted) {
        // 권한이 승인되면 true를 반환
        return true;
      } else {
        // 사용자에게 위치 권한이 필요하다고 알림을 표시하고 설정으로 이동하도록 안내
        openAppSettings();
        return false;
      }
    }
  }
}
