import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contact Us', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildContactCard(Icons.email_outlined, "Email Support", "support@evora.com"),
            _buildContactCard(Icons.phone_outlined, "Phone Number", "+91 98765 43210"),
            _buildContactCard(Icons.location_on_outlined, "Office Address", "Evora Headquarters, Mumbai, India"),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.15), // Rose Gold BG
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 28), // Indigo Icon
        ),
        title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)
        ),
        // ✅ FIXED: Removed 'marginTop' and added Padding instead
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
              subtitle,
              style: const TextStyle(color: AppColors.textSecondary)
          ),
        ),
      ),
    );
  }
}