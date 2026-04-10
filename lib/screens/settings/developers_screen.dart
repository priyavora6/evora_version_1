import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../config/app_colors.dart';

// A data model to hold developer information for clean code
class DeveloperInfo {
  final String name;
  final String role;
  final String department;
  final String imagePath;

  DeveloperInfo({
    required this.name,
    required this.role,
    required this.department,
    required this.imagePath,
  });
}

class DevelopersScreen extends StatefulWidget {
  const DevelopersScreen({super.key});

  @override
  State<DevelopersScreen> createState() => _DevelopersScreenState();
}

class _DevelopersScreenState extends State<DevelopersScreen> {
  // --- Data for the developers and mentors ---
  final List<DeveloperInfo> developers = [
    DeveloperInfo(
      name: 'Priya Vora',
      role: 'Student',
      department: 'B.Tech CE Department',
      imagePath: 'assets/images/priya.png', // Replace with your actual image path
    ),
    DeveloperInfo(
      name: 'Jargavi Jadeja',
      role: 'Student',
      department: 'B.Tech CE Department',
      imagePath: 'assets/images/jargavi.png', // Replace with your actual image path
    ),
  ];

  final List<DeveloperInfo> mentors = [
    DeveloperInfo(
      name: 'Prof. Chirag Bhalodia',
      role: 'Faculty Guide',
      department: 'Project Mentor',
      imagePath: 'assets/images/chirag.png', // Replace with your actual image path
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Our Team', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: AnimationLimiter(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionHeader("Designed & Developed By"),
            ..._buildAnimatedList(developers, 0),
            const SizedBox(height: 24),
            _buildSectionHeader("Guided By"),
            ..._buildAnimatedList(mentors, developers.length),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  List<Widget> _buildAnimatedList(List<DeveloperInfo> list, int initialIndex) {
    return List.generate(
      list.length,
          (index) => AnimationConfiguration.staggeredList(
        position: initialIndex + index,
        duration: const Duration(milliseconds: 475),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: _DeveloperInfoCard(info: list[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return AnimationConfiguration.staggeredList(
      position: developers.length + mentors.length,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              "Version 1.0.0.0",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable card widget for displaying a person's info
class _DeveloperInfoCard extends StatelessWidget {
  final DeveloperInfo info;

  const _DeveloperInfoCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.primary.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.secondary.withOpacity(0.2),
              // Use a fallback icon if the image fails to load
              backgroundImage: AssetImage(info.imagePath),
              onBackgroundImageError: (_, __) {}, // Handles image load errors gracefully
              child: const Icon(Icons.person, size: 35, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info.role,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    info.department,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}