import 'package:flutter/material.dart';
import '../core/routes.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      ('Algorithms', '12 modules'),
      ('Data Structures', '10 modules'),
      ('Operating Systems', '8 modules'),
      ('Computer Networks', '7 modules'),
      ('Databases', '6 modules'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final c = courses[i];
          return Card(
            child: ListTile(
              title: Text(c.$1),
              subtitle: Text(c.$2),
              leading: const Icon(Icons.menu_book_outlined),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.examPlayer,
                arguments: c.$1, // 👈 send course name
              ),
            ),
          );
        },
      ),
    );
  }
}
