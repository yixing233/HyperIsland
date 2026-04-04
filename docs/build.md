# 构建指南

从源码构建 HyperIsland APK。

## 环境要求

- [Flutter SDK](https://flutter.dev) 3.9.0 或更高版本
- Android SDK（通过 Android Studio 或命令行工具）
- 确保 `flutter` 和 `dart` 命令在 PATH 中

## 构建步骤

1. 克隆仓库：

```bash
git clone https://github.com/1812z/HyperIsland.git
cd HyperIsland
```

2. 安装依赖：

```bash
flutter pub get
```

3. 构建 APK：

```bash
flutter build apk --target-platform=android-arm64
```

构建完成后，APK 文件位于 `build/app/outputs/flutter-apk/app-release.apk`。

## 构建变体

如需构建调试版本：

```bash
flutter build apk --target-platform=android-arm64 --debug
```

## 常见问题

::: details 构建失败怎么办？
- 确保 Flutter 版本满足 `pubspec.yaml` 中的 SDK 约束（^3.9.0）
- 运行 `flutter doctor` 检查环境配置
- 确保已接受 Android 许可证：`flutter doctor --android-licenses`
:::
