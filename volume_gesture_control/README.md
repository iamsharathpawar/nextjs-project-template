# Volume Gesture Control

A Flutter Android app that replaces physical volume buttons with swipe gestures. The app runs persistently in the background and provides volume control through swipe gestures on the top 25% of the screen.

## Features

- **Background Operation**: Runs continuously even when screen is off or locked
- **Gesture Control**: 
  - Swipe right on top 25% of screen → Increase volume
  - Swipe left on top 25% of screen → Decrease volume
- **Persistent Overlay**: Uses system alert window for gesture detection
- **Auto-start**: Automatically starts on device boot
- **Battery Optimization**: Handles battery restrictions to prevent app killing

## Permissions Required

- **System Alert Window**: For overlay gesture detection
- **Foreground Service**: For background operation
- **Boot Complete**: For auto-start on device boot
- **Modify Audio Settings**: For system volume control
- **Ignore Battery Optimizations**: To prevent app killing

## Installation

1. Clone the repository
2. Navigate to the project directory: `cd volume_gesture_control`
3. Install Flutter dependencies: `flutter pub get`
4. Build and install on Android device: `flutter run` or `flutter build apk`
5. Grant all requested permissions when prompted

## Usage

1. Open the app
2. Grant all required permissions (the app will guide you through this)
3. Start the background service using the toggle in the app
4. Swipe left/right on the top 25% of your screen to control volume
5. The app will continue working even when minimized or screen is off

## Technical Details

### Architecture
- **Flutter Layer**: Main UI and permission management
- **Native Android Services**: Background volume control and gesture detection
- **System Integration**: Boot receiver and battery optimization handling

### Key Components
- `VolumeControlService`: Handles system volume changes
- `GestureOverlayService`: Detects swipe gestures on screen overlay
- `BootReceiver`: Auto-starts services on device boot
- `MainActivity`: Bridges Flutter and native Android code

### Supported Versions
- Android 5.0+ (API 21+)
- Flutter 3.0+

## Building

### Debug Build
```bash
flutter run
```

### Release Build
```bash
flutter build apk --release
```

### Install APK
```bash
flutter install
```

## Development

### Prerequisites
- Flutter SDK
- Android SDK
- Android device or emulator

### Setup
1. Clone the repository
2. Run `flutter doctor` to verify setup
3. Connect Android device or start emulator
4. Run `flutter pub get`
5. Run `flutter run`

## Troubleshooting

### App Not Working in Background
1. Check if overlay permission is granted
2. Disable battery optimization for the app
3. Ensure the background service is running

### Gestures Not Detected
1. Verify overlay permission is granted
2. Check if gestures are performed in the top 25% of screen
3. Ensure sufficient swipe distance and velocity

### Auto-start Not Working
1. Check if boot permission is granted
2. Verify the app is not restricted by device manufacturer settings
3. Add app to auto-start whitelist in device settings

## Permissions Explained

- **SYSTEM_ALERT_WINDOW**: Creates invisible overlay for gesture detection
- **FOREGROUND_SERVICE**: Keeps app running in background
- **RECEIVE_BOOT_COMPLETED**: Starts app automatically after device boot
- **MODIFY_AUDIO_SETTINGS**: Changes system volume levels
- **REQUEST_IGNORE_BATTERY_OPTIMIZATIONS**: Prevents Android from killing the app
- **WAKE_LOCK**: Keeps services active when screen is off

## License

This project is open source and available under the MIT License.
