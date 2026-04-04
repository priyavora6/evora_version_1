import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final bool isRegistration;

  const OtpScreen({
    super.key,
    required this.email,
    this.isRegistration = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _countdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_countdown == 0) {
        t.cancel();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  // ═══════════════════════════════════════════════════════════════════════
  // 🔥 VERIFY & REDIRECT TO CORRECT PANEL
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _handleVerify() async {
    if (_otpCode.length < 6) {
      _showMessage('Please enter the complete 6-digit code');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.verifyEmailOTP(widget.email, _otpCode);

    if (success && mounted) {
      // ✅ GET THE PRE-CALCULATED ROUTE FROM LOGIN SCREEN
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      // 'nextRoute' was calculated in LoginScreen based on roleIntent & vendorStatus
      String nextRoute = args?['nextRoute'] ?? AppRoutes.dashboard;

      debugPrint("🎯 OTP Verified! Redirecting to: $nextRoute");

      // Clear entire navigation stack so user can't go "Back" to OTP/Login
      Navigator.pushNamedAndRemoveUntil(context, nextRoute, (route) => false);

    } else if (mounted) {
      _showMessage(authProvider.errorMessage ?? 'Invalid code. Please try again.', isError: true);
      _clearOtp();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔄 RESEND OTP
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _handleResend() async {
    if (_countdown > 0) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.sendEmailOTP(widget.email);

    if (authProvider.errorMessage == null && mounted) {
      _startCountdown();
      _clearOtp();
      _showMessage('A new OTP has been sent to your email.');
    } else if (mounted) {
      _showMessage(authProvider.errorMessage ?? "Failed to resend", isError: true);
    }
  }

  void _clearOtp() {
    for (var c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
  }

  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.security, size: 50, color: AppColors.primary),
              ),
              const SizedBox(height: 40),

              // Title
              const Text(
                "Verification",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                "Enter the 6-digit code sent to\n${widget.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 40),

              // OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpBox(index)),
              ),
              const SizedBox(height: 32),

              // Resend Link
              GestureDetector(
                onTap: _countdown == 0 ? _handleResend : null,
                child: Text(
                  _countdown > 0 ? "Resend code in ${_countdown}s" : "Resend Code Now",
                  style: TextStyle(
                    color: _countdown > 0 ? AppColors.textSecondary : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Verify Button
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  if (auth.isLoading) return const LoadingIndicator();
                  return CustomButton(text: "Verify & Proceed", onPressed: _handleVerify);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
              _handleVerify(); // Auto-verify when last digit entered
            }
          } else if (index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}