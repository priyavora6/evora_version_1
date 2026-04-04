import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🆕 Added Firebase Auth
import '../../config/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false; // 🆕 Added Loading State

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🔐 PASSWORD CHANGE LOGIC
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _updatePassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // 1. Basic Validation
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (newPassword.length < 6) {
      _showError('New password must be at least 6 characters');
      return;
    }

    if (newPassword != confirmPassword) {
      _showError('New passwords do not match');
      return;
    }

    if (oldPassword == newPassword) {
      _showError('New password must be different from the old one');
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        // 2. Re-authenticate the user (Firebase Security Requirement)
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // 3. Update the password
        await user.updatePassword(newPassword);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Password changed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Go back to settings
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle Specific Firebase Errors
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        _showError('Incorrect old password');
      } else if (e.code == 'weak-password') {
        _showError('The new password is too weak');
      } else {
        _showError(e.message ?? 'An error occurred');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ $message'), backgroundColor: Colors.red),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🎨 BUILD UI
  // ═══════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your password must be at least 6 characters and should include a combination of numbers, letters, and special characters.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),

            CustomTextField(
              controller: _oldPasswordController,
              label: 'Old Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              controller: _newPasswordController,
              label: 'New Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirm New Password',
              obscureText: true,
            ),
            const SizedBox(height: 40),

            // 🔄 Loading Indicator or Button
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Update Password',
                onPressed: _updatePassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}