
import 'package:flutter/material.dart';
import '../core/routes.dart';

class ExamResultPage extends StatelessWidget {
  const ExamResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final score = args?['score'] as int? ?? 0;
    final total = args?['total'] as int? ?? 0;
    final answers = (args?['answers'] as Map<int, int>?) ?? {};
    final questions = (args?['questions'] as List<Map<String, dynamic>>?) ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text('Your Score', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text('$score / $total', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Review Answers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final q = questions[i];
                  final correct = q['answer'] as int;
                  final selected = answers[i];
                  final isCorrect = selected == correct;
                  return Card(
                    child: ListTile(
                      title: Text(q['q'] as String),
                      subtitle: Text('Your answer: ${selected == null ? '—' : (q['options'] as List<String>)[selected]}\n'
                          'Correct answer: ${(q['options'] as List<String>)[correct]}'),
                      trailing: Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home), child: const Text('Back to Home'))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.examPlayer), child: const Text('Retake Exam'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
