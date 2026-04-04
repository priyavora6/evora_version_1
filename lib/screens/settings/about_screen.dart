import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('About Evora', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary, // Indigo
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1), // Rose Gold tint
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text(
              "Evora - Event Planner",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              "Evora is your ultimate companion for organizing events effortlessly. From managing your guest lists and tracking your budget to booking the best vendors in town, Evora makes event planning stress-free and magical.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.6),
            ),
            const Spacer(),
            const Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}