import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Text(
            "Privacy Policy\n\n"
                "Last updated: January 2024\n\n"
                "1. Information Collection\n"
                "We collect personal information such as your name, email address, and phone number when you register to use our app.\n\n"
                "2. Usage of Data\n"
                "The information collected is used to manage your events, handle payments securely, and connect you with verified vendors.\n\n"
                "3. Data Security\n"
                "We implement highly secure protocols to ensure that your personal and financial information is safe.\n\n"
                "4. Third-Party Sharing\n"
                "We do not sell your personal data. It is only shared with vendors you explicitly choose to book.\n\n"
                "For further questions, please contact our support team via the Contact Us page.",
            style: TextStyle(fontSize: 15, height: 1.6, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}