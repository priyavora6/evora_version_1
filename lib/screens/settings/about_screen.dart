import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    const SizedBox(height: 30),
                    _buildLogoSection(),
                    const SizedBox(height: 40),
                    _buildMissionSection(),
                    const SizedBox(height: 30),
                    _buildFeatureGrid(),
                    const SizedBox(height: 40),
                    _buildContactSection(),
                    const SizedBox(height: 50),
                    _buildFooter(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'About Evora',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.navyGradient,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 2),
          ),
          child: Hero(
            tag: 'app_logo_hero',
            child: Icon(Icons.auto_awesome, size: 70, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "EVORA",
          style: GoogleFonts.montserrat(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: 4,
            color: AppColors.primary,
          ),
        ),
        Text(
          "Plan. Celebrate. Remember.",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.secondary,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildMissionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Text(
            "Our Mission",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "At Evora, we believe that every milestone deserves a perfect celebration without the stress of planning. Our platform bridges the gap between your dreams and reality by connecting you with top-tier vendors and providing powerful organizational tools.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildFeatureItem(Icons.verified_user_outlined, "Trusted Vendors", "Verified professionals only")),
              Expanded(child: _buildFeatureItem(Icons.account_balance_wallet_outlined, "Budgeting", "Track every penny spent")),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildFeatureItem(Icons.checklist_rtl_outlined, "Task Manager", "Never miss a deadline")),
              Expanded(child: _buildFeatureItem(Icons.qr_code_scanner_outlined, "Check-ins", "Seamless guest management")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.secondary, size: 30),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.royalGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.favorite, color: Colors.white, size: 28),
          const SizedBox(height: 16),
          Text(
            "Made for your special moments",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            "Designed and developed with ❤️ in India",
            style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          "Version 1.0.0",
          style: GoogleFonts.poppins(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(Icons.language),
            const SizedBox(width: 20),
            _buildSocialIcon(Icons.facebook),
            const SizedBox(width: 20),
            _buildSocialIcon(Icons.camera_alt_outlined),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "© 2024 Evora App. All rights reserved.",
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade400),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Icon(icon, color: Colors.grey.shade300, size: 20);
  }
}
