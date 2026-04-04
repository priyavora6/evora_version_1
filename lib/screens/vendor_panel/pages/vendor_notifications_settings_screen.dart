import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../config/app_colors.dart';
import '../widgets/vendor_app_bar.dart';

class VendorNotificationSettingsScreen extends StatefulWidget {
  const VendorNotificationSettingsScreen({super.key});

  @override
  State<VendorNotificationSettingsScreen> createState() => _VendorNotificationSettingsScreenState();
}

class _VendorNotificationSettingsScreenState extends State<VendorNotificationSettingsScreen> {
  // Default values
  bool _newWork = true;
  bool _payments = true;
  bool _reviews = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // 📥 Load real settings from Firestore
  Future<void> _loadSettings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('vendors').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        final settings = data['notificationSettings'] as Map<String, dynamic>? ?? {};

        if (mounted) {
          setState(() {
            _newWork = settings['newWork'] ?? true;
            _payments = settings['payments'] ?? true;
            _reviews = settings['reviews'] ?? true;
            _isLoading = false;
          });
        }
      }
    }
  }

  // 💾 Save settings to Firestore
  Future<void> _updateSetting(String key, bool value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // Optimistic UI update
      setState(() {
        if (key == 'newWork') _newWork = value;
        if (key == 'payments') _payments = value;
        if (key == 'reviews') _reviews = value;
      });

      // Write to DB
      await FirebaseFirestore.instance.collection('vendors').doc(uid).set({
        'notificationSettings': {
          'newWork': key == 'newWork' ? value : _newWork,
          'payments': key == 'payments' ? value : _payments,
          'reviews': key == 'reviews' ? value : _reviews,
        }
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const VendorAppBar(
        title: "Notification Settings",
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader("Business Alerts"),
          _buildSwitch(
              "New Work Assignments",
              "Get notified immediately when admin assigns a new event.",
              _newWork,
                  (val) => _updateSetting('newWork', val)
          ),
          const Divider(),
          _buildSwitch(
              "Payments Received",
              "Get notified when funds are transferred to your account.",
              _payments,
                  (val) => _updateSetting('payments', val)
          ),
          const Divider(),
          _buildSwitch(
              "New Reviews",
              "Get notified when a customer rates your service.",
              _reviews,
                  (val) => _updateSetting('reviews', val)
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      ),
    );
  }
}