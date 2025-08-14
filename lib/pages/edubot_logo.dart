import 'package:flutter/material.dart';

class EduBotLogo extends StatelessWidget {
  const EduBotLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "EduBot",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E64FF),
          ),
        ),
      ),
    );
  }
}
