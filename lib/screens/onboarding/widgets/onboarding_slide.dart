import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon; // ✅ Changed from String to IconData

  const OnboardingSlide({
    super.key,
    required this.title,
    required this.description,
    required this.icon, // ✅ Updated Constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon, // ✅ Use passed icon directly
                size: 80,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 50),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}