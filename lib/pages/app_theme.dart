import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF3E64FF);
  static const bg = Color(0xFFF5F6FA);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.bg,
  );
}
