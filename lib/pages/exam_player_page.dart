import 'dart:async';
import 'package:flutter/material.dart';
import '../core/routes.dart';

class ExamPlayerPage extends StatefulWidget {
  const ExamPlayerPage({super.key});

  @override
  State<ExamPlayerPage> createState() => _ExamPlayerPageState();
}

class _ExamPlayerPageState extends State<ExamPlayerPage> {
  late List<Map<String, Object>> questions;
  String? course;
  int index = 0;
  final Map<int, int> selections = {};
  int secondsLeft = 60 * 5; // 5 minutes
  Timer? _timer;

  // ✅ Questions bank
    // ✅ Questions bank
  final Map<String, List<Map<String, Object>>> courseQuestions = {
    'Mobile Development': [
      {
        'q': 'Which framework is commonly used for cross-platform mobile apps?',
        'options': ['React Native', 'Spring Boot', 'Django', 'Laravel'],
        'answer': 0
      },
      {
        'q': 'Which language is primarily used in Flutter?',
        'options': ['Kotlin', 'Swift', 'Dart', 'JavaScript'],
        'answer': 2
      },
      {
        'q': 'Android apps are mainly written in?',
        'options': ['Kotlin/Java', 'Swift', 'C#', 'PHP'],
        'answer': 0
      },
      {
        'q': 'iOS apps are mainly written in?',
        'options': ['Kotlin', 'Swift', 'Java', 'Python'],
        'answer': 1
      },
      {
        'q': 'Which of these is a mobile database?',
        'options': ['SQLite', 'Firebase', 'Realm', 'All of these'],
        'answer': 3
      },
    ],

    'Web Development': [
      {
        'q': 'Which language is used for styling web pages?',
        'options': ['HTML', 'CSS', 'JavaScript', 'Python'],
        'answer': 1
      },
      {
        'q': 'Which of these is a frontend framework?',
        'options': ['Angular', 'Django', 'Spring Boot', 'Laravel'],
        'answer': 0
      },
      {
        'q': 'Which of these is a backend technology?',
        'options': ['React', 'Vue.js', 'Node.js', 'Bootstrap'],
        'answer': 2
      },
      {
        'q': 'What does HTML stand for?',
        'options': [
          'Hyper Trainer Marking Language',
          'Hyper Text Markup Language',
          'Hyper Text Marketing Language',
          'Hyperlinks Text Markup Level'
        ],
        'answer': 1
      },
      {
        'q': 'Which database is often used with web apps?',
        'options': ['MySQL', 'Photoshop', 'Illustrator', 'Excel'],
        'answer': 0
      },
    ],

    'Quality Assurance': [
      {
        'q': 'Which testing ensures individual units of code work?',
        'options': ['Unit Testing', 'Integration Testing', 'System Testing', 'Acceptance Testing'],
        'answer': 0
      },
      {
        'q': 'Which testing checks the whole system?',
        'options': ['Unit', 'Integration', 'System', 'Smoke'],
        'answer': 2
      },
      {
        'q': 'Automation testing is done using?',
        'options': ['Jenkins', 'Selenium', 'JUnit', 'All of these'],
        'answer': 3
      },
      {
        'q': 'Regression testing ensures?',
        'options': ['Old features still work after changes', 'Performance is fast', 'App looks good', 'Code compiles'],
        'answer': 0
      },
      {
        'q': 'Which document defines test cases?',
        'options': ['Test Plan', 'Bug Report', 'Design Doc', 'User Manual'],
        'answer': 0
      },
    ],

    'Project Management': [
      {
        'q': 'Which methodology is iterative and flexible?',
        'options': ['Waterfall', 'Agile', 'V-Model', 'Spiral'],
        'answer': 1
      },
      {
        'q': 'What does a Gantt Chart show?',
        'options': ['Budget', 'Timeline', 'Risks', 'Team members'],
        'answer': 1
      },
      {
        'q': 'Which role leads an Agile team?',
        'options': ['Project Manager', 'Scrum Master', 'Tester', 'Product Owner'],
        'answer': 1
      },
      {
        'q': 'The triple constraint in project management is?',
        'options': ['Scope, Time, Cost', 'Scope, Budget, HR', 'Risk, Quality, Budget', 'Scope, People, Cost'],
        'answer': 0
      },
      {
        'q': 'Which is a project management tool?',
        'options': ['Trello', 'Excel', 'Jira', 'All of these'],
        'answer': 3
      },
    ],

    'Artificial Intelligence': [
      {
        'q': 'Which is a common AI programming language?',
        'options': ['Python', 'HTML', 'CSS', 'SQL'],
        'answer': 0
      },
      {
        'q': 'Which algorithm is used in Machine Learning?',
        'options': ['Decision Trees', 'DFS', 'Sorting', 'Hashing'],
        'answer': 0
      },
      {
        'q': 'Which field is part of AI?',
        'options': ['Computer Vision', 'Databases', 'Web Development', 'Operating Systems'],
        'answer': 0
      },
      {
        'q': 'Which is an AI application?',
        'options': ['Self-driving cars', 'Text editors', 'Compilers', 'Printers'],
        'answer': 0
      },
      {
        'q': 'NLP in AI stands for?',
        'options': ['Natural Language Processing', 'New Logic Programming', 'Network Layer Protocol', 'None'],
        'answer': 0
      },
    ],

    'Cyber Security': [
      {
        'q': 'Which is NOT a cyber attack?',
        'options': ['Phishing', 'SQL Injection', 'Firewall', 'DDoS'],
        'answer': 2
      },
      {
        'q': 'What does HTTPS provide?',
        'options': ['Speed', 'Encryption & Security', 'Free Hosting', 'Bug Fixes'],
        'answer': 1
      },
      {
        'q': 'Which is a type of malware?',
        'options': ['Virus', 'Trojan', 'Worm', 'All of these'],
        'answer': 3
      },
      {
        'q': 'What is the main purpose of a firewall?',
        'options': ['Encrypt data', 'Monitor and control network traffic', 'Store passwords', 'Hack attackers'],
        'answer': 1
      },
      {
        'q': 'Two-factor authentication improves?',
        'options': ['Usability', 'Security', 'Performance', 'Design'],
        'answer': 1
      },
    ],
  };


  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => secondsLeft--);
      if (secondsLeft <= 0) {
        t.cancel();
        _submit();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (course == null) {
      course = ModalRoute.of(context)!.settings.arguments as String;
      questions = courseQuestions[course] ?? [];
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _submit() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selections[i] == questions[i]['answer']) score++;
    }
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.examResult,
      arguments: {
        'score': score,
        'total': questions.length,
        'answers': selections,
        'questions': questions,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No questions found for this course")),
      );
    }

    final q = questions[index];
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text(course ?? 'Exam'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text('$minutes:$seconds',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: (index + 1) / questions.length),
            const SizedBox(height: 16),
            Text('Question ${index + 1}/${questions.length}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(q['q'] as String, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            ...(q['options'] as List<String>).asMap().entries.map((e) {
              final selected = selections[index] == e.key;
              return Card(
                child: RadioListTile<int>(
                  value: e.key,
                  groupValue: selections[index],
                  onChanged: (v) => setState(() => selections[index] = v!),
                  title: Text(e.value),
                  selected: selected,
                ),
              );
            }),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: index == 0 ? null : () => setState(() => index--),
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: index == questions.length - 1
                        ? _submit
                        : () => setState(() => index++),
                    child: Text(
                        index == questions.length - 1 ? 'Submit' : 'Next'),
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
