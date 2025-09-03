import 'package:flutter/material.dart';
import 'package:teachingapp/pages/lastexam.dart';
import 'exam_result_page.dart';


class ExamPlayerPage extends StatefulWidget {
  final String course;

  const ExamPlayerPage({super.key, required this.course});

  @override
  State<ExamPlayerPage> createState() => _ExamPlayerPageState();
}

class _ExamPlayerPageState extends State<ExamPlayerPage> {
  late List<Map<String, dynamic>> questions;
  final Map<int, int> selections = {};

  @override
  void initState() {
    super.initState();
    questions = _loadQuestions(widget.course);
  }

  List<Map<String, dynamic>> _loadQuestions(String course) {
    return [
      {
        'q': 'Which framework is commonly used for cross-platform mobile apps?',
        'options': ['React Native', 'Spring Boot', 'Django', 'Laravel'],
        'answer': 0,
      },
      {
        'q': 'Which language is primarily used in Flutter?',
        'options': ['Kotlin', 'Swift', 'Dart', 'JavaScript'],
        'answer': 2,
      },
      {
        'q': 'Android apps are mainly written in?',
        'options': ['Kotlin/Java', 'Swift', 'C#', 'PHP'],
        'answer': 0,
      },
      {
        'q': 'iOS apps are mainly written in?',
        'options': ['Kotlin', 'Swift', 'Java', 'Python'],
        'answer': 1,
      },
      {
        'q': 'Which of these is a mobile database?',
        'options': ['SQLite', 'Firebase', 'Realm', 'All of these'],
        'answer': 3,
      },
    ];
  }

  void _submit() {
    int correctCounter = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selections[i] == questions[i]['answer']) correctCounter++;
    }

    // Save the last result
    LastExamResult.correctCounter = correctCounter;
    LastExamResult.answers = Map<int, int>.from(selections);
    LastExamResult.questions = List<Map<String, dynamic>>.from(questions);
    LastExamResult.course = widget.course;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ExamResultPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exam - ${widget.course}')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, i) {
          final q = questions[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q['q'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Column(
                    children: List.generate(q['options'].length, (j) {
                      return RadioListTile<int>(
                        value: j,
                        groupValue: selections[i],
                        onChanged: (val) {
                          setState(() => selections[i] = val!);
                        },
                        title: Text(q['options'][j] as String),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submit,
        label: const Text("Submit Exam"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
