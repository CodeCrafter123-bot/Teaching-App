
import 'dart:async';
import 'package:flutter/material.dart';
import '../core/routes.dart';

class ExamPlayerPage extends StatefulWidget {
  const ExamPlayerPage({super.key});

  @override
  State<ExamPlayerPage> createState() => _ExamPlayerPageState();
}

class _ExamPlayerPageState extends State<ExamPlayerPage> {
  final questions = const [
    {
      'q': 'What is the time complexity of binary search?',
      'options': ['O(n)', 'O(log n)', 'O(n log n)', 'O(1)'],
      'answer': 1
    },
    {
      'q': 'Which data structure uses FIFO?',
      'options': ['Stack', 'Queue', 'Tree', 'Graph'],
      'answer': 1
    },
    {
      'q': 'Which sorting algorithm is stable?',
      'options': ['QuickSort', 'MergeSort', 'HeapSort', 'SelectionSort'],
      'answer': 1
    },
  ];

  int index = 0;
  final Map<int, int> selections = {};
  int secondsLeft = 60 * 5; // 5 minutes
  Timer? _timer;

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
      arguments: {'score': score, 'total': questions.length, 'answers': selections, 'questions': questions},
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam'),
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('$minutes:$seconds', style: const TextStyle(fontWeight: FontWeight.w600)),
          )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: (index + 1) / questions.length),
            const SizedBox(height: 16),
            Text('Question ${index + 1}/${questions.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                    child: Text(index == questions.length - 1 ? 'Submit' : 'Next'),
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
