import 'package:flutter/material.dart';

class ColorUtils {
  static Color fromHex(String hex) {
    final buffer = StringBuffer();
    var value = hex.replaceFirst('#', '');
    if (value.length == 6) {
      buffer.write('ff');
    }
    buffer.write(value);
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static List<Color> parseHexList(List<dynamic> values) {
    return values.map((value) => fromHex(value.toString())).toList();
  }
}
