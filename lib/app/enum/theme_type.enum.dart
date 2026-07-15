import 'package:flutter/foundation.dart';

enum ThemeType {
  device,
  light,
  dark;

  Brightness get brightness => switch (this) {
    device => _getDeviceBrightness(),
    light => Brightness.light,
    dark => Brightness.dark,
  };

  Brightness _getDeviceBrightness() {
    return PlatformDispatcher.instance.platformBrightness;
  }
}
