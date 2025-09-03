import 'package:flutter/material.dart';
import 'services/database_helper.dart';
import 'core/routes.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing  database before running the app
  await DatabaseHelper().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduBot',
      initialRoute: AppRoutes.login,
      routes: AppRoutes.map,
    );
  }
}
