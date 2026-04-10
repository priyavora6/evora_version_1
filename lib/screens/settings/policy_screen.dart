import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../config/app_colors.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            sliver: SliverToBoxAdapter(
              child: AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => FadeInAnimation(
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: widget,
                      ),
                    ),
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 30),
                      _buildSection(
                        "1. Introduction",
                        "Welcome to Evora. We value your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application.",
                      ),
                      _buildSection(
                        "2. Data We Collect",
                        "• Personal Identification: Name, email address, phone number.\n"
                        "• Event Details: Guest lists, budget data, task lists, and event preferences.\n"
                        "• Payment Information: Processed securely via Stripe; we do not store your full card details.\n"
                        "• Media: Images you upload for your profile or event showcases.",
                      ),
                      _buildSection(
                        "3. How We Use Your Data",
                        "We use your data to:\n"
                        "• Create and manage your account.\n"
                        "• Facilitate event planning and vendor bookings.\n"
                        "• Process payments and generate invoices.\n"
                        "• Send important notifications about your events.\n"
                        "• Improve our services and user experience.",
                      ),
                      _buildSection(
                        "4. Data Sharing & Security",
                        "Your data is shared only with vendors you explicitly interact with. We do not sell your personal information to third parties. We use industry-standard encryption (SSL/TLS) to protect your data during transmission and storage.",
                      ),
                      _buildSection(
                        "5. Your Rights",
                        "You have the right to access, correct, or delete your personal data at any time through the app settings. You can also contact us to request a copy of your data or to withdraw your consent for certain data processing activities.",
                      ),
                      _buildSection(
                        "6. Changes to This Policy",
                        "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the 'Last Updated' date.",
                      ),
                      const SizedBox(height: 40),
                      _buildContactFooter(),
                      const SizedBox(height: 50),
                    ],
                  ),
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
          'Privacy Policy',
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Evora Privacy Policy",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Last Updated: May 2024",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(thickness: 1),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            "Questions about our policy?",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Contact our legal team at evora.eventplanner@gmail.com",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
