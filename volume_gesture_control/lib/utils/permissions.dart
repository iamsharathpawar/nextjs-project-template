import 'package:permission_handler/permission_handler.dart';
import 'package:system_alert_window/system_alert_window.dart';

class PermissionHandler {
  static Future<bool> checkAllPermissions() async {
    final overlayPermission = await SystemAlertWindow.checkPermissions();
    final systemAlertPermission = await Permission.systemAlertWindow.isGranted;
    final ignoreBatteryOptimization = await Permission.ignoreBatteryOptimizations.isGranted;
    
    return overlayPermission && systemAlertPermission && ignoreBatteryOptimization;
  }

  static Future<void> requestAllPermissions() async {
    // Request system alert window permission
    await Permission.systemAlertWindow.request();
    
    // Request ignore battery optimization
    await Permission.ignoreBatteryOptimizations.request();
    
    // Request overlay permission
    await SystemAlertWindow.requestPermissions(prefOptions: SystemWindowPrefModel(
      systemWindowOption: SystemWindowOption.BOTTOM,
      systemWindowGravity: SystemWindowGravity.TOP,
    ));
  }

  static Future<bool> checkOverlayPermission() async {
    final status = await SystemAlertWindow.checkPermissions();
    return status;
  }

  static Future<void> openSettings() async {
    await SystemAlertWindow.openSettings();
  }
}
