import 'package:flutter/material.dart';

class Responsive {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isTablet(BuildContext context) => width(context) >= 768;

  static double scale(BuildContext context, double value) {
    final baseWidth = isTablet(context) ? 900 : 390;
    return value * (width(context) / baseWidth);
  }
}
