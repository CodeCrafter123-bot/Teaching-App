import 'package:flutter/material.dart';
import 'package:teachingapp/pages/profile_page.dart';
import 'package:teachingapp/services/auth_services.dart';
import '../core/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EduBot Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                final user = authService.currentUser;
                final username = user?['name'] ?? "User";
                return Text(
                  "Welcome, $username 👋",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.menu_book),
              label: const Text("Courses"),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.courses),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.fact_check),
              label: const Text("Exam Results"),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.examResult),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text("Profile"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
