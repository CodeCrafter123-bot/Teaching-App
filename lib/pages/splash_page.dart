import 'package:flutter/material.dart';
import 'package:teachingapp/services/auth_services.dart';
import '../core/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      final next = authService.currentUser == null ? AppRoutes.login : AppRoutes.home;
      Navigator.pushReplacementNamed(context, next);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("EduBot", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
