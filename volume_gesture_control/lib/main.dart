import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volume_gesture_control/services/background_service.dart';
import 'package:volume_gesture_control/utils/permissions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize background service
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'volume_gesture_channel',
      initialNotificationTitle: 'Volume Gesture Control',
      initialNotificationContent: 'Swipe gestures active',
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  
  runApp(const VolumeGestureApp());
}

class VolumeGestureApp extends StatefulWidget {
  const VolumeGestureApp({super.key});

  @override
  State<VolumeGestureApp> createState() => _VolumeGestureAppState();
}

class _VolumeGestureAppState extends State<VolumeGestureApp> {
  bool _hasPermissions = false;
  bool _serviceRunning = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _checkServiceStatus();
  }

  Future<void> _checkPermissions() async {
    final permissions = await PermissionHandler.checkAllPermissions();
    setState(() => _hasPermissions = permissions);
  }

  Future<void> _checkServiceStatus() async {
    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();
    setState(() => _serviceRunning = isRunning);
  }

  Future<void> _requestPermissions() async {
    await PermissionHandler.requestAllPermissions();
    await _checkPermissions();
  }

  Future<void> _toggleService() async {
    final service = FlutterBackgroundService();
    
    if (_serviceRunning) {
      service.invoke('stopService');
    } else {
      service.startService();
    }
    
    await _checkServiceStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volume Gesture Control',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Volume Gesture Control'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Gesture Control Status',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: Icon(
                          _hasPermissions ? Icons.check_circle : Icons.error,
                          color: _hasPermissions ? Colors.green : Colors.red,
                        ),
                        title: const Text('Permissions'),
                        subtitle: Text(
                          _hasPermissions 
                            ? 'All permissions granted' 
                            : 'Permissions required',
                        ),
                        trailing: ElevatedButton(
                          onPressed: _requestPermissions,
                          child: const Text('Grant'),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          _serviceRunning ? Icons.play_circle : Icons.pause_circle,
                          color: _serviceRunning ? Colors.green : Colors.orange,
                        ),
                        title: const Text('Background Service'),
                        subtitle: Text(
                          _serviceRunning 
                            ? 'Service is running' 
                            : 'Service is stopped',
                        ),
                        trailing: ElevatedButton(
                          onPressed: _toggleService,
                          child: Text(_serviceRunning ? 'Stop' : 'Start'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Swipe left/right on the top 25% of screen to control volume',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
