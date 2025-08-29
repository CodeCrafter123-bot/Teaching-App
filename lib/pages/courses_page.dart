import 'package:flutter/material.dart';
import '../core/routes.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
   final courses = [
  ('Mobile Development', '5 modules'),
  ('Web Development', '5 modules'),
  ('Quality Assurance', '5 modules'),
  ('Project Management', '5 modules'),
  ('Artificial Intelligence', '5 modules'),
  ('Cyber Security', '5 modules'),
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
              leading: const Icon(Icons.menu_book_outlined),
              title: Text(c.$1),
              subtitle: Text(c.$2),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.examPlayer,
                arguments: c.$1,
              ),
            ),
          );
        },
      ),
    );
  }
}
