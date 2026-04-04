import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../services/auth_service.dart';

class VerificationGateScreen extends StatelessWidget {
  final String email;

  const VerificationGateScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Safely capture the roleIntent passed from the Register screen
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String roleIntent = args?['roleIntent'] ?? 'user';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user_outlined, size: 70, color: AppColors.primary),
              ),
              const SizedBox(height: 30),

              const Text(
                "Account Verification",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 15),

              Text(
                "To ensure the security of your account, please verify your email address:\n$email",
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 40),

              // ── Send Verification Link ──
              _buildChoiceCard(
                title: "Send Verification Link",
                subtitle: "We'll send a link to your inbox",
                icon: Icons.alternate_email_rounded,
                onTap: () => _sendVerification(context, roleIntent),
              ),

              const SizedBox(height: 50),

              // Logout
              TextButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                label: const Text(
                  "Use a different account / Logout",
                  style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📧 SEND VERIFICATION & NAVIGATE
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _sendVerification(BuildContext context, String roleIntent) async {
    try {
      await AuthService().sendEmailVerification();

      if (context.mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.emailVerifyWaiting,
          arguments: {
            'email': email,
            'roleIntent': roleIntent, // ✅ Passing roleIntent forward
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🚪 LOGOUT
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _handleLogout(BuildContext context) async {
    await AuthService().logout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🎨 CHOICE CARD UI
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildChoiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}