
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

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
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, spreadRadius: 4),
        ],
      ),
      child: const Center(
        child: Text(
          "EduBot",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
      ),
    );
  }
}
