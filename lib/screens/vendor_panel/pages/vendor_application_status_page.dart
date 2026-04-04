// lib/screens/vendor_panel/pages/vendor_application_status_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/vendor_model.dart'; // ✅ Added import

class VendorApplicationStatusPage extends StatelessWidget {
  const VendorApplicationStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text('Application Status'),
        automaticallyImplyLeading: false, // 🔥 Professional look: no back button to registration form
        actions: [
          IconButton(
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout().then((_) {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            }),
            icon: const Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final vendor = authProvider.currentVendor;
          final status = vendor?.status ?? 'pending';

          return RefreshIndicator(
            onRefresh: () async {
              await authProvider.refreshUserData();
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 1. Status Visuals
                  _buildStatusIcon(status),
                  const SizedBox(height: 24),
                  _buildStatusTitle(status),
                  const SizedBox(height: 12),
                  _buildStatusMessage(status, vendor?.rejectedReason),

                  const SizedBox(height: 40),

                  // 2. Application Summary Card
                  if (vendor != null) _buildApplicationDetails(vendor),

                  const SizedBox(height: 40),

                  // 3. Primary Action Buttons
                  _buildActionButtons(context, status, authProvider),

                  const SizedBox(height: 30),

                  // Footer branding
                  const Opacity(
                    opacity: 0.5,
                    child: Text(
                      "EVORA • Partner Program",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    IconData icon;
    Color color;
    Color bgColor;

    switch (status.toLowerCase()) {
      case 'approved':
        icon = Icons.verified_rounded;
        color = Colors.green;
        bgColor = Colors.green.shade50;
        break;
      case 'rejected':
        icon = Icons.error_outline_rounded;
        color = Colors.red;
        bgColor = Colors.red.shade50;
        break;
      default: // pending
        icon = Icons.hourglass_empty_rounded;
        color = Colors.orange;
        bgColor = Colors.orange.shade50;
    }

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 80, color: color),
    );
  }

  Widget _buildStatusTitle(String status) {
    String title;
    Color color;

    switch (status.toLowerCase()) {
      case 'approved':
        title = 'You are Approved!';
        color = Colors.green;
        break;
      case 'rejected':
        title = 'Application Declined';
        color = Colors.red;
        break;
      default: // pending
        title = 'Review in Progress';
        color = Colors.orange;
    }

    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildStatusMessage(String status, String? rejectedReason) {
    String message;

    switch (status.toLowerCase()) {
      case 'approved':
        message = 'Welcome to the team! You can now access your professional dashboard and manage your assigned events.';
        break;
      case 'rejected':
        message = 'We couldn\'t approve your application at this time. See the reason below.';
        break;
      default: // pending
        message = 'Our team is currently reviewing your business profile. This usually takes 24-48 hours.';
    }

    return Column(
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
        ),
        if (status.toLowerCase() == 'rejected' && rejectedReason != null) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              "Reason: $rejectedReason",
              style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildApplicationDetails(VendorModel vendor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Submission Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          _buildDetailRow(Icons.storefront, 'Business', vendor.businessName),
          _buildDetailRow(Icons.category_outlined, 'Service', vendor.serviceType),
          _buildDetailRow(Icons.location_on_outlined, 'City', vendor.city),
          _buildDetailRow(Icons.phone_outlined, 'Phone', vendor.businessPhone),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String status, AuthProvider auth) {
    if (status.toLowerCase() == 'approved') {
      return Column(
        children: [
          _buildPrimaryButton(
              context,
              "Enter Professional Panel",
              Icons.dashboard_customize,
                  () => Navigator.pushReplacementNamed(context, AppRoutes.vendorMain)
          ),
          const SizedBox(height: 15),
          _buildSecondaryButton(context, "Plan an Event (User Mode)", Icons.person_outline, () => Navigator.pushReplacementNamed(context, AppRoutes.dashboard)),
        ],
      );
    }

    if (status.toLowerCase() == 'rejected') {
      return _buildPrimaryButton(
          context,
          "Edit & Re-submit",
          Icons.edit_note,
              () => Navigator.pushReplacementNamed(context, AppRoutes.vendorRegistration)
      );
    }

    // Pending State Buttons
    return Column(
      children: [
        _buildPrimaryButton(
            context,
            "Refresh Status",
            Icons.refresh,
                () => auth.refreshUserData()
        ),
        const SizedBox(height: 15),
        _buildSecondaryButton(
            context,
            "Browse as Organizer",
            Icons.home_outlined,
                () => Navigator.pushReplacementNamed(context, AppRoutes.dashboard)
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 55),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}