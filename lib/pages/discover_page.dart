import 'package:flutter/material.dart';
import '../core/routes.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      ('Secure Exams', 'Face checks, timers, and question randomization.'),
      ('Smart Tutor', 'AI explanations with citations to your slides.'),
      ('Progress Analytics', 'See strengths, weaknesses, and mastery.'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Discover EduBot")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              "Explore features without signing in",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: features.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final f = features[i];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.star_outline),
                      title: Text(f.$1), // changed from f.item1
                      subtitle: Text(f.$2), // changed from f.item2
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.login,
                ),
                child: const Text("Back to Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
