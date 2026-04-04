// lib/screens/vendor_panel/tabs/settings_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../../../config/app_colors.dart';
import '../../../providers/auth_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final vendor = authProvider.currentVendor;
        final isAvailable = vendor?.isAvailable ?? false;
        final businessName = vendor?.businessName ?? 'Vendor';
        final email = FirebaseAuth.instance.currentUser?.email ?? '';
        final initial = businessName.isNotEmpty ? businessName[0].toUpperCase() : 'V';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. Profile Overview Card
              _buildProfileCard(context, businessName, email, initial, isAvailable),
              const SizedBox(height: 24),

              // 2. Business Management Section
              _buildSectionHeader('Business Management'),
              _buildMenuContainer([
                _buildMenuItem(
                  context,
                  icon: Icons.edit_note_rounded,
                  title: 'Edit Business Profile',
                  onTap: () => Navigator.pushNamed(context, '/vendor-edit-profile'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.sensors_rounded,
                  title: 'Accepting New Orders',
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: isAvailable,
                      activeColor: Colors.green,
                      activeTrackColor: Colors.green.withOpacity(0.3),
                      onChanged: (val) => _updateAvailability(context, val),
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.notifications_active_outlined,
                  title: 'Notification Settings',
                  isLast: true,
                  onTap: () => Navigator.pushNamed(context, '/vendor-notifications-settings'),
                ),
              ]),
              const SizedBox(height: 24),

              // 3. App Experience Section
              _buildSectionHeader('Experience'),
              _buildMenuContainer([
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'Switch to User View',
                  iconColor: Colors.blue,
                  onTap: () => _showSwitchToUserDialog(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.support_agent_rounded,
                  title: 'Help & Technical Support',
                  onTap: () => Navigator.pushNamed(context, '/vendor-help'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.gavel_rounded,
                  title: 'Legal & Terms',
                  isLast: true,
                  onTap: () => Navigator.pushNamed(context, '/vendor-terms'),
                ),
              ]),
              const SizedBox(height: 24),

              // 4. Logout Section
              _buildMenuContainer([
                _buildMenuItem(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'Logout Business Account',
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  isLast: true,
                  onTap: () => _showLogoutDialog(context),
                ),
              ]),

              const SizedBox(height: 30),
              Text(
                "EVORA VENDOR PANEL v1.0.4",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 10, letterSpacing: 1.2),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ⚡ LOGIC METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  // Toggle Availability in Firestore
  Future<void> _updateAvailability(BuildContext context, bool value) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance.collection('vendors').doc(uid).update({
        'isAvailable': value,
        'lastStatusUpdate': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        await Provider.of<AuthProvider>(context, listen: false).refreshUserData();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value ? "You are now ONLINE and discoverable." : "You are now OFFLINE."),
          backgroundColor: value ? Colors.green : Colors.black87,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      debugPrint("Update failed: $e");
    }
  }

  // Logout Logic (Forces Offline)
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('You will be set to Offline and logged out. Continue?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                // Force offline so Admin knows they are gone
                await FirebaseFirestore.instance.collection('vendors').doc(uid).update({'isAvailable': false});
              }
              if (context.mounted) {
                Navigator.pop(ctx);
                await Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Switch to User Side Logic
  void _showSwitchToUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Switch to User View'),
        content: const Text('Browse services and manage your own events?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
            },
            child: const Text('Switch Now', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎨 UI COMPONENTS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProfileCard(BuildContext context, String name, String email, String initial, bool isOnline) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(initial, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(email, style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isOnline ? "ONLINE" : "OFFLINE",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isOnline ? Colors.green : Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 8, bottom: 10),
      child: Text(title.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey.shade400, letterSpacing: 1.5)),
    );
  }

  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, Widget? trailing, VoidCallback? onTap, Color? textColor, Color? iconColor, bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(icon, color: iconColor ?? Colors.black87, size: 22),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor ?? Colors.black87)),
          trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        ),
        if (!isLast) Divider(height: 1, indent: 60, endIndent: 20, color: Colors.grey.shade100),
      ],
    );
  }
}