# Build Guide

Build HyperIsland APK from source.

## Requirements

- [Flutter SDK](https://flutter.dev) 3.9.0 or higher
- Android SDK (via Android Studio or command line tools)
- Ensure `flutter` and `dart` commands are in PATH

## Build Steps

1. Clone the repository:

```bash
git clone https://github.com/1812z/HyperIsland.git
cd HyperIsland
```

2. Install dependencies:

```bash
flutter pub get
```

3. Build APK:

```bash
flutter build apk --target-platform=android-arm64
```

After building, the APK is located at `build/app/outputs/flutter-apk/app-release.apk`.

## Build Variants

To build a debug version:

```bash
flutter build apk --target-platform=android-arm64 --debug
```

## FAQ

::: details Build fails?
- Ensure Flutter version meets the SDK constraint in `pubspec.yaml` (^3.9.0)
- Run `flutter doctor` to check environment setup
- Ensure Android licenses are accepted: `flutter doctor --android-licenses`
:::
