import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'core/routes.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduBot',
      theme: buildTheme(),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.map,
    );
  }
}
