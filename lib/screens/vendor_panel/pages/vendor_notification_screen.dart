// lib/screens/vendor_panel/notifications/vendor_notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../config/app_colors.dart';
import '../../../providers/notification_provider.dart';
import '../../../models/notification_model.dart';
import '../widgets/vendor_app_bar.dart';

class VendorNotificationsScreen extends StatefulWidget {
  const VendorNotificationsScreen({super.key});

  @override
  State<VendorNotificationsScreen> createState() => _VendorNotificationsScreenState();
}

class _VendorNotificationsScreenState extends State<VendorNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        // ✅ Start listening for VENDOR-SIDE notifications only
        Provider.of<NotificationProvider>(context, listen: false)
            .startNotificationsListener(uid, true); // 👈 true = Vendor side
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const VendorAppBar(
        title: "Business Alerts",
        showBackButton: true,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.notifications.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.notifications.length,
            itemBuilder: (context, index) {
              final notification = provider.notifications[index];
              return _NotificationCard(
                notification: notification,
                onTap: () => _handleTap(context, notification, provider),
              );
            },
          );
        },
      ),
    );
  }

  void _handleTap(BuildContext context, NotificationModel n, NotificationProvider prov) {
    // 1. Mark as read
    if (!n.isRead) prov.markAsRead(n.id);

    // 2. Navigate based on type
    switch (n.type) {
      case NotificationType.vendorAssigned:
        if (n.relatedId != null) {
          Navigator.pushNamed(context, '/vendor-event-details', arguments: {'eventId': n.relatedId});
        }
        break;
      case NotificationType.vendorApproved:
        Navigator.pushNamed(context, '/vendor-panel');
        break;
      case NotificationType.paymentReceived:
      // Navigate to Earnings or Payments screen if you have one
        break;
      default:
        break;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No Business Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 8),
          const Text(
            "New bookings, approvals, and payments\nwill appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// 🎨 REUSABLE NOTIFICATION CARD
// ══════════════════════════════════════════════════════════════════════════
class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = _getStyle(notification.type);
    final timeAgo = _formatTime(notification.createdAt);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        Provider.of<NotificationProvider>(context, listen: false).deleteNotification(notification.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead ? Colors.grey.shade200 : AppColors.primary.withOpacity(0.2),
            width: notification.isRead ? 1 : 1.5,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: style.bgColor, shape: BoxShape.circle),
            child: Icon(style.icon, color: style.color, size: 24),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w900,
              fontSize: 15,
              color: notification.isRead ? Colors.black87 : AppColors.primary,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: notification.isRead ? Colors.grey.shade600 : Colors.black87,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(timeAgo, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  _NotifStyle _getStyle(String type) {
    switch (type) {
      case NotificationType.vendorApproved:
        return _NotifStyle(Icons.verified_rounded, Colors.teal, Colors.teal.withOpacity(0.1));
      case NotificationType.paymentReceived:
        return _NotifStyle(Icons.attach_money_rounded, Colors.green, Colors.green.withOpacity(0.1));
      case NotificationType.vendorAssigned:
        return _NotifStyle(Icons.assignment_ind_rounded, AppColors.primary, AppColors.primary.withOpacity(0.1));
      default:
        return _NotifStyle(Icons.notifications_rounded, Colors.grey, Colors.grey.withOpacity(0.1));
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('dd MMM, hh:mm a').format(time);
  }
}

class _NotifStyle {
  final IconData icon;
  final Color color;
  final Color bgColor;
  _NotifStyle(this.icon, this.color, this.bgColor);
}