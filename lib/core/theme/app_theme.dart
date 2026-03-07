import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Segoe UI',
      scaffoldBackgroundColor: const Color(0xFF031D15),
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Segoe UI',
      scaffoldBackgroundColor: const Color(0xFFF4FAF7),
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static Widget withFixedTextScale(Widget child) {
    return MediaQuery(
      data: MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: child,
    );
  }

  static void lockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
  }
}

