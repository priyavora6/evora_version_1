import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/app_colors.dart';

class VendorTermsScreen extends StatelessWidget {
  const VendorTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Legal & Terms', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLastUpdated(),
            const SizedBox(height: 25),
            _buildTermSection(
              '1. Vendor Responsibilities',
              'Vendors are responsible for maintaining accurate profiles, pricing, and availability. All services provided must meet the quality standards specified in the service description.',
            ),
            _buildTermSection(
              '2. Booking & Cancellations',
              'Confirmed bookings are a binding agreement. Vendors must provide 48-hour notice for any unavoidable cancellations. High cancellation rates may lead to account suspension.',
            ),
            _buildTermSection(
              '3. Payment Terms',
              'Evora charges a service fee on every successful booking. Net payouts are processed to the linked bank account after successful event completion and client confirmation.',
            ),
            _buildTermSection(
              '4. Professional Conduct',
              'Vendors must maintain professional behavior when interacting with clients. Any form of harassment or unprofessionalism will result in immediate termination of the partnership.',
            ),
            _buildTermSection(
              '5. Data Privacy',
              'Vendors agree to protect client data shared for event coordination and must not use it for marketing purposes outside the Evora platform.',
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'By using the Evora Vendor Panel, you agree to these terms.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Last Updated: October 2023',
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
    );
  }

  Widget _buildTermSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
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
}
