import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/app_colors.dart';

class VendorHelpScreen extends StatelessWidget {
  const VendorHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Help & Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSupportHeader(),
            const SizedBox(height: 30),
            _buildSectionTitle('Frequently Asked Questions'),
            const SizedBox(height: 15),
            _buildFaqItem(
              'How do I update my service availability?',
              'You can toggle your availability directly from the Settings tab. When OFF, your services won\'t appear in user searches.',
            ),
            _buildFaqItem(
              'How do I receive payments?',
              'Payments are processed through the Evora platform and settled to your registered bank account within 3-5 business days after event completion.',
            ),
            _buildFaqItem(
              'What happens if I need to cancel a booking?',
              'Cancellations should be avoided. If necessary, please contact support immediately. Frequent cancellations may affect your vendor rating.',
            ),
            const SizedBox(height: 30),
            _buildSectionTitle('Contact Technical Support'),
            const SizedBox(height: 15),
            _buildContactCard(
              context,
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'vendor.support@evora.com',
              onTap: () {},
            ),
            _buildContactCard(
              context,
              icon: Icons.headset_mic_outlined,
              title: 'Live Chat',
              subtitle: 'Available Mon-Fri, 9am - 6pm',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.navyGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.help_center_rounded, size: 50, color: Colors.white),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How can we help you?',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Find answers or contact our technical team for assistance.',
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            answer,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }
}
