import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppThemeController {
  AppThemeController._();

  static final ValueNotifier<ThemeMode> mode = ValueNotifier<ThemeMode>(ThemeMode.dark);

  static bool get isLightMode => mode.value == ThemeMode.light;

  static void setLightMode(bool light) {
    mode.value = light ? ThemeMode.light : ThemeMode.dark;
  }
}

