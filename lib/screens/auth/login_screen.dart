import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../services/email_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_indicator.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isProcessing = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔑 LOGIN & ROUTE CALCULATION
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // 1. Firebase Auth Sign In
      bool success = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success && mounted) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception("User session not found.");

        // 2. Sync Notification Token Immediately
        await NotificationService().updateDeviceToken();

        // 3. Fetch User Data to determine where they belong
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        String nextRoute = AppRoutes.dashboard;

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          String roleIntent = (userData['roleIntent'] ?? 'user').toString().toLowerCase();
          String vendorStatus = (userData['vendorStatus'] ?? 'none').toString().toLowerCase();

          debugPrint("🔍 Role: $roleIntent | Status: $vendorStatus");

          // 🚀 AUTO-ONLINE LOGIC FOR VENDORS
          if (roleIntent == 'vendor') {
            if (vendorStatus == 'approved') {
              // ✅ Set Vendor to ACTIVE so they appear in Admin Panel immediately
              await FirebaseFirestore.instance
                  .collection('vendors')
                  .doc(user.uid)
                  .update({
                'isAvailable': true,
                'lastActive': FieldValue.serverTimestamp(),
              });

              nextRoute = AppRoutes.vendorMain;
            } else {
              nextRoute = AppRoutes.vendorApplicationStatus;
            }
          } else {
            nextRoute = AppRoutes.dashboard;
          }
        }

        // 4. Multi-Factor Authentication (OTP via Email)
        final String? otp = await authProvider.sendEmailOTP(_emailController.text.trim());

        if (otp != null) {
          await EmailService.sendOTP(
            toEmail: _emailController.text.trim(),
            otpCode: otp,
          );

          if (mounted) {
            Navigator.pushNamed(
              context,
              AppRoutes.emailOtpScreen,
              arguments: {
                'email': _emailController.text.trim(),
                'correctOtp': otp,
                'nextRoute': nextRoute,
              },
            );
          }
        } else {
          throw Exception("Authentication service is temporarily unavailable.");
        }
      } else if (mounted) {
        _showError(authProvider.errorMessage ?? "Invalid email or password.");
      }
    } catch (e) {
      debugPrint("❌ Login Error: $e");
      if (mounted) _showError("Authentication failed. Please try again.");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Icon(Icons.stars_rounded, size: 80, color: AppColors.primary),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "EVORA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: 4
                    ),
                  ),
                  const SizedBox(height: 50),

                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Access your event planning dashboard.',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 35),

                  CustomTextField(
                    controller: _emailController,
                    label: "Email",
                    hint: 'name@example.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.alternate_email_rounded,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: _passwordController,
                    label: "Password",
                    hint: '••••••••',
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_open_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: Validators.validatePassword,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  _isProcessing
                      ? const Center(child: LoadingIndicator())
                      : CustomButton(
                    text: "Login",
                    onPressed: _handleLogin,
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          "New to Evora?",
                          style: TextStyle(color: AppColors.textSecondary)
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                        child: const Text(
                            "Create Account",
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}