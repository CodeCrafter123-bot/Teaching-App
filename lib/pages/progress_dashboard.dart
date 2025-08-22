import 'package:flutter/material.dart';

class ProgressDashboardPage extends StatelessWidget {
  const ProgressDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Progress"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Learning Overview",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Lessons Completed
            _buildProgressCard(
              title: "Lessons Completed",
              value: 8,
              total: 12,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // Quizzes Attempted
            _buildProgressCard(
              title: "Quizzes Attempted",
              value: 5,
              total: 10,
              color: Colors.green,
            ),
            const SizedBox(height: 16),

            // Average Score
            _buildProgressCard(
              title: "Average Score",
              value: 75,
              total: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),

            // Streak
            _buildProgressCard(
              title: "Learning Streak",
              value: 6,
              total: 30,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  // Reusable progress card widget
  Widget _buildProgressCard({
    required String title,
    required int value,
    required int total,
    required Color color,
  }) {
    double progress = value / total;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: color,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
            Text(
              "$value / $total",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
