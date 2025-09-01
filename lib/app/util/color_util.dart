import 'package:flutter/material.dart';

class ColorUtil {
  ColorUtil._();

  /// #RRGGBB => Color(0xFFRRGGBB)
  static Color? parseHex(String? hex) {
    return (hex == null) ? null : Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
  }
}

extension ColorExtension on Color {
  /// 0xAARRGGBB => #RRGGBB
  String toHexColor() {
    final argb = toARGB32(); // AARRGGBB
    final r = (argb >> 16) & 0xFF;
    final g = (argb >> 8) & 0xFF;
    final b = (argb >> 0) & 0xFF;

    String two(int v) => v.toRadixString(16).padLeft(2, '0');
    var s = '#${two(r)}${two(g)}${two(b)}';
    return s;
  }

  /// hex code 값 비교
  bool equalsHexCode(Color? color) {
    return toHexColor() == color?.toHexColor();
  }
}
