import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';

class EmailOtpScreen extends StatefulWidget {
  final String email;

  const EmailOtpScreen({super.key, required this.email});

  @override
  State<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends State<EmailOtpScreen> {
  final List<TextEditingController> controllers = List.generate(6, (i) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (i) => FocusNode());

  bool _isResending = false;

  @override
  void dispose() {
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔥 VERIFY OTP & NAVIGATE TO CORRECT PANEL
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _onVerify() async {
    // 🛡️ SAFETY FIX: Always read arguments BEFORE the 'await' call!
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String nextRoute = args?['nextRoute'] ?? AppRoutes.dashboard;

    String enteredOtp = controllers.map((c) => c.text).join();

    if (enteredOtp.length < 6) {
      _showError("Please enter all 6 digits of the security code.");
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Server verification
    final isValid = await authProvider.verifyEmailOTP(widget.email, enteredOtp);

    if (isValid && mounted) {
      debugPrint("🎯 OTP Verified. Redirecting to: $nextRoute");

      // Clear the navigation stack so user cannot go back to OTP/Login
      Navigator.pushNamedAndRemoveUntil(
        context,
        nextRoute,
            (route) => false,
      );
    } else if (mounted) {
      _showError("Invalid verification code. Please check and try again.");
      for (var c in controllers) c.clear();
      focusNodes[0].requestFocus();
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.sendEmailOTP(widget.email);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A new security code has been sent to your email.")),
      );
      setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Verification"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Shield Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.security, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 30),
            const Text("Verify Your Identity", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("Enter the 6-digit code sent to\n${widget.email}",
                textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, height: 1.5)),
            const SizedBox(height: 40),

            // OTP Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return KeyboardListener(
                  focusNode: FocusNode(), // Temporary node to detect backspace
                  onKeyEvent: (event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.backspace &&
                        controllers[index].text.isEmpty && index > 0) {
                      focusNodes[index - 1].requestFocus();
                    }
                  },
                  child: SizedBox(
                    width: 45,
                    height: 60,
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 1,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 5) {
                            focusNodes[index + 1].requestFocus();
                          } else {
                            focusNodes[index].unfocus();
                            _onVerify(); // Auto-verify on last digit
                          }
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 50),

            Consumer<AuthProvider>(
              builder: (context, auth, child) {
                return auth.isLoading
                    ? const LoadingIndicator()
                    : CustomButton(text: "Confirm & Login", onPressed: _onVerify);
              },
            ),
            const SizedBox(height: 30),

            _isResending
                ? const CircularProgressIndicator()
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't get the code?", style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: _resendOtp,
                  child: const Text("Resend Email", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}