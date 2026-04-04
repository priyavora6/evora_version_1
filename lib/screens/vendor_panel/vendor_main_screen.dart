// lib/screens/vendor_panel/vendor_main_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/vendor_panel_provider.dart';

// ✅ IMPORT THE NEW WIDGETS & TABS
import 'widgets/vendor_app_bar.dart';
import 'tabs/vendor_home_tab.dart';
import 'tabs/assigned_work_tab.dart';
import 'tabs/reviews_tab.dart';
import 'tabs/settings_tab.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  int _currentIndex = 0;

  // 1. Define the Screens for each tab
  final List<Widget> _tabs = [
    const VendorHomeTab(),     // Dashboard
    const AssignedWorkTab(),   // My Work
    const ReviewsTab(),        // Reviews
    const SettingsTab(),       // Profile/Settings
  ];

  // 2. Define Titles for the AppBar (Must match the tab order)
  final List<String> _titles = [
    'Dashboard',
    'My Work',
    'Reviews',
    'Profile', // Changed from 'Settings' to match the User Icon
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadVendorData();
  }

  void _initializeNotifications() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      notificationProvider.startNotificationsListener(authProvider.currentUser!.id, true);
    }
  }

  void _loadVendorData() {
    // Determine vendor ID safely after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;

      if (user != null && user.vendorId != null) {
        // Pre-fetch general stats (optional, as HomeTab now streams data too)
        Provider.of<VendorPanelProvider>(context, listen: false)
            .fetchDashboardStats(user.vendorId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Modern light grey background

      // ✅ 3. Using the Clean, Modern AppBar
      appBar: VendorAppBar(
        title: _titles[_currentIndex],
        showBackButton: false, // Root screen, no back button needed
      ),

      // ✅ 4. IndexedStack keeps the state of tabs alive when switching
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎨 BOTTOM NAVIGATION BAR
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, Icons.grid_view_outlined, Icons.grid_view_rounded, 'Home'),
              _buildNavItem(1, Icons.calendar_today_outlined, Icons.calendar_month_rounded, 'Work'),
              _buildNavItem(2, Icons.star_outline_rounded, Icons.star_rounded, 'Reviews'),
              _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : Colors.grey[400],
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}