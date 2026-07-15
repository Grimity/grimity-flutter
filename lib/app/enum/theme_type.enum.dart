import 'package:flutter/material.dart';

enum ThemeType {
  device,
  light,
  dark;

  ThemeMode get themeMode => switch (this) {
    device => ThemeMode.system,
    light => ThemeMode.light,
    dark => ThemeMode.dark,
  };
}
