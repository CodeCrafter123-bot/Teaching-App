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
  final Map<String, List<Map<String, Object>>> courseQuestions = {
    'Algorithms': [
      {
        'q': 'What is the time complexity of binary search?',
        'options': ['O(n)', 'O(log n)', 'O(n log n)', 'O(1)'],
        'answer': 1
      },
      {
        'q': 'Which algorithm is used for shortest path in a graph?',
        'options': ['DFS', 'BFS', 'Dijkstra', 'Kruskal'],
        'answer': 2
      },
      {
        'q': 'Which sorting algorithm is stable?',
        'options': ['QuickSort', 'MergeSort', 'HeapSort', 'SelectionSort'],
        'answer': 1
      },
      {
        'q': 'Which algorithm uses divide and conquer?',
        'options': ['MergeSort', 'BubbleSort', 'InsertionSort', 'CountingSort'],
        'answer': 0
      },
      {
        'q': 'What is Big-O of linear search?',
        'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n^2)'],
        'answer': 2
      },
    ],
    'Data Structures': [
      {
        'q': 'Which data structure uses FIFO?',
        'options': ['Stack', 'Queue', 'Tree', 'Graph'],
        'answer': 1
      },
      {
        'q': 'Which data structure uses LIFO?',
        'options': ['Stack', 'Queue', 'Tree', 'Graph'],
        'answer': 0
      },
      {
        'q': 'Which data structure is best for implementing recursion?',
        'options': ['Stack', 'Queue', 'Linked List', 'Array'],
        'answer': 0
      },
      {
        'q': 'Which data structure is used in BFS?',
        'options': ['Stack', 'Queue', 'Heap', 'Graph'],
        'answer': 1
      },
      {
        'q': 'Which data structure allows fast search?',
        'options': ['Linked List', 'Array', 'Hash Table', 'Stack'],
        'answer': 2
      },
    ],
    'Operating Systems': [
      {
        'q': 'Which is not a type of OS?',
        'options': ['Batch', 'Time-sharing', 'Distributed', 'Linked List'],
        'answer': 3
      },
      {
        'q': 'Which algorithm is used for CPU scheduling?',
        'options': ['FCFS', 'SJF', 'Round Robin', 'All of the above'],
        'answer': 3
      },
      {
        'q': 'Which component manages memory?',
        'options': ['Kernel', 'Compiler', 'Shell', 'Loader'],
        'answer': 0
      },
      {
        'q': 'Deadlock occurs when?',
        'options': [
          'Processes share resources',
          'Processes wait indefinitely',
          'CPU is idle',
          'Memory is full'
        ],
        'answer': 1
      },
      {
        'q': 'Which is a page replacement algorithm?',
        'options': ['FIFO', 'LRU', 'Optimal', 'All of these'],
        'answer': 3
      },
    ],
    'Computer Networks': [
      {
        'q': 'Which layer does IP belong to?',
        'options': ['Application', 'Transport', 'Network', 'Data Link'],
        'answer': 2
      },
      {
        'q': 'Which protocol is connection-oriented?',
        'options': ['UDP', 'TCP', 'IP', 'HTTP'],
        'answer': 1
      },
      {
        'q': 'Which device operates at data link layer?',
        'options': ['Router', 'Switch', 'Hub', 'Gateway'],
        'answer': 1
      },
      {
        'q': 'Which is not a routing algorithm?',
        'options': ['Distance Vector', 'Link State', 'Dijkstra', 'Binary Search'],
        'answer': 3
      },
      {
        'q': 'Default port for HTTPS?',
        'options': ['80', '21', '25', '443'],
        'answer': 3
      },
    ],
    'Databases': [
      {
        'q': 'Which language is used to query databases?',
        'options': ['HTML', 'SQL', 'C++', 'XML'],
        'answer': 1
      },
      {
        'q': 'Which normal form removes partial dependency?',
        'options': ['1NF', '2NF', '3NF', 'BCNF'],
        'answer': 1
      },
      {
        'q': 'Which is a primary key property?',
        'options': ['Unique', 'Nullable', 'Duplicate allowed', 'None'],
        'answer': 0
      },
      {
        'q': 'Which join returns all rows?',
        'options': ['Inner Join', 'Left Join', 'Full Outer Join', 'Cross Join'],
        'answer': 2
      },
      {
        'q': 'ACID in DB stands for?',
        'options': [
          'Atomicity, Consistency, Isolation, Durability',
          'Accuracy, Consistency, Isolation, Durability',
          'Access, Control, Integrity, Data',
          'None of these'
        ],
        'answer': 0
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
