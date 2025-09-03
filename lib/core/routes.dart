import 'package:flutter/material.dart';
import '../pages/splash_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/discover_page.dart';
import '../pages/home_page.dart';
import '../pages/courses_page.dart';
import '../pages/exam_player_page.dart';
import '../pages/exam_result_page.dart';
import '../pages/profile_page.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const discover = '/discover';
  static const home = '/home';
  static const courses = '/courses';
  static const examPlayer = '/exam';
  static const examResult = '/examResult';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> map = {
    splash: (_) => const SplashPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    discover: (_) => const DiscoverPage(),
    home: (_) => const HomePage(),
    courses: (_) => const CoursesPage(),
    examPlayer: (_) => const ExamPlayerPage(course: '',),
    examResult: (_) => const ExamResultPage(),
    profile: (_) => const ProfilePage(),
  };
}
