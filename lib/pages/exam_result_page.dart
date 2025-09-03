import 'package:flutter/material.dart';
import 'package:teachingapp/pages/lastexam.dart';
import 'exam_player_page.dart';


class ExamResultPage extends StatelessWidget {
  const ExamResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final correctCounter = LastExamResult.correctCounter;
    final answers = LastExamResult.answers;
    final questions = LastExamResult.questions;
    final course = LastExamResult.course;

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text('Correct Answers', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 6),
                  Text(
                    '$correctCounter / 5',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Review Answers',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                      subtitle: Text(
                        'Your answer: ${selected == null ? '—' : (q['options'] as List<String>)[selected]}\n'
                        'Correct answer: ${(q['options'] as List<String>)[correct]}',
                      ),
                      trailing: Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Text('Back to Home'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExamPlayerPage(course: course),
                        ),
                      );
                    },
                    child: const Text('Retake Exam'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
