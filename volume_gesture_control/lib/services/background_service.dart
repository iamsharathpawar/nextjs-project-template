import 'dart:async';
import 'dart:io';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Initialize volume control service
  await _initializeVolumeControl(service);
}

Future<void> _initializeVolumeControl(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    // Start the native overlay service
    service.setForegroundNotificationInfo(
      title: "Volume Gesture Control",
      content: "Swipe gestures are active",
    );
  }

  // Keep service running
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (!(await service.isRunning())) {
      timer.cancel();
      return;
    }
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}
