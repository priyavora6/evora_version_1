// lib/screens/notifications/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        // Start listening for USER-SIDE notifications only
        Provider.of<NotificationProvider>(context, listen: false)
            .startNotificationsListener(uid, false); // 👈 false = User side
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () => Provider.of<NotificationProvider>(context, listen: false).markAllAsRead(),
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.notifications.isEmpty) return _buildEmptyState();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.notifications.length,
            itemBuilder: (_, i) => _NotificationCard(notification: provider.notifications[i]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("No notifications yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final style = _getStyle(notification.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : style.bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: notification.isRead ? Colors.grey.shade200 : style.color, width: 1.5),
      ),
      child: ListTile(
        leading: Icon(style.icon, color: style.color),
        title: Text(notification.title, style: TextStyle(fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w900)),
        subtitle: Text(notification.message, style: const TextStyle(fontSize: 13)),
        onTap: () => _handleTap(context, notification),
      ),
    );
  }

  _NotifStyle _getStyle(String type) {
    switch (type) {
      case NotificationType.paymentSuccess:
        return _NotifStyle(Icons.check_circle, Colors.green, Colors.green.shade50);
      case NotificationType.bookingApproved:
        return _NotifStyle(Icons.verified, Colors.blue, Colors.blue.shade50);
      default:
        return _NotifStyle(Icons.notifications, AppColors.primary, AppColors.primary.withOpacity(0.1));
    }
  }

  void _handleTap(BuildContext context, NotificationModel n) {
    Provider.of<NotificationProvider>(context, listen: false).markAsRead(n.id);
    if (n.relatedId != null) {
      Navigator.pushNamed(context, AppRoutes.eventDetail, arguments: {'eventId': n.relatedId});
    }
  }
}

class _NotifStyle {
  final IconData icon;
  final Color color;
  final Color bgColor;
  _NotifStyle(this.icon, this.color, this.bgColor);
}