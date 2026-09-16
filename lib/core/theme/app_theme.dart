import 'package:flutter/material.dart';
import 'package:task/core/theme/app_fonts.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppFonts.gilroy,
      textTheme: Typography.material2021().black.apply(
            fontFamily: AppFonts.gilroy,
          ),
    );
  }
}
