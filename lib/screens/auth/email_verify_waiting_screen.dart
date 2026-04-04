// lib/screens/auth/email_verify_waiting_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Added for DB check
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';

class EmailVerifyWaitingScreen extends StatefulWidget {
  const EmailVerifyWaitingScreen({super.key});

  @override
  State<EmailVerifyWaitingScreen> createState() => _EmailVerifyWaitingScreenState();
}

class _EmailVerifyWaitingScreenState extends State<EmailVerifyWaitingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // 1. Send the verification email immediately
    _sendInitialVerification();

    // 2. 🔄 Check status every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkEmailVerified();
    });
  }

  Future<void> _sendInitialVerification() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    } catch (e) {
      debugPrint("Verification email error: $e");
    }
  }

  Future<void> _checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();

    if (user != null && user.emailVerified) {
      _timer?.cancel(); // Stop checking once verified

      if (mounted) {
        try {
          // 🔥 1. FETCH THE INTENT FROM THE DATABASE
          // This is the safest way to ensure they go to the right place.
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          String roleIntent = 'user'; // Default
          if (userDoc.exists) {
            roleIntent = userDoc.get('roleIntent') ?? 'user';
          }

          // 🔥 2. PERFORM REDIRECTION BASED ON INTENT
          if (roleIntent == 'vendor') {
            debugPrint("🚀 Redirecting Professional to Vendor Form");
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.vendorRegistration, // The 5-step form
                  (route) => false,
            );
          } else {
            debugPrint("🏠 Redirecting Organizer to Dashboard");
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.dashboard, // Standard organizer dashboard
                  (route) => false,
            );
          }
        } catch (e) {
          debugPrint("Error during final redirection: $e");
          // Fallback to dashboard if anything fails
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (route) => false);
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Visual Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 40),

              const Text(
                "Verify your Email",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 15),

              const Text(
                "Check your inbox! We've sent a verification link to your email address. Click it to activate your account.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
              ),

              const SizedBox(height: 50),

              const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
              const SizedBox(height: 25),

              const Text(
                "Waiting for you to click the link...",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 60),

              const Text(
                "Didn't receive the email?",
                style: TextStyle(color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: _sendInitialVerification,
                child: const Text(
                  "Resend Verification Link",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}