import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../models/notification_model.dart';
import '../../../providers/notification_provider.dart';
import '../../../services/notification_service.dart';

class VendorNotificationsScreen extends StatefulWidget {
  const VendorNotificationsScreen({super.key});

  @override
  State<VendorNotificationsScreen> createState() => _VendorNotificationsScreenState();
}

class _VendorNotificationsScreenState extends State<VendorNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        // ✅ Start listening specifically for Vendor Side notifications
        Provider.of<NotificationProvider>(context, listen: false)
            .startListening(userId: uid, isVendorSide: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Business Alerts", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Distinct color for Vendor Panel
        foregroundColor: Colors.white,
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, _) => provider.unreadCount > 0
                ? IconButton(icon: const Icon(Icons.done_all), onPressed: () => provider.markAllAsRead())
                : const SizedBox.shrink(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (val) => val == 'clear' ? _showClearDialog(context) : null,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'clear', child: Text('Clear All Notifications', style: TextStyle(color: Colors.red))),
            ],
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.notifications.isEmpty) return _buildEmptyState();

          return RefreshIndicator(
            onRefresh: () async => await provider.refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.notifications.length,
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return _VendorNotificationCard(
                  notification: notification,
                  onTap: () => _handleTap(context, notification),
                  onDismiss: () => provider.deleteNotification(notification.id),
                );
              },
            ),
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
          Icon(Icons.work_off_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No business alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
          const Text("New work assignments will appear here", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context, NotificationModel notification) {
    Provider.of<NotificationProvider>(context, listen: false).markAsRead(notification.id);

    // ✅ NAVIGATION: Synchronized with AppRoutes
    switch (notification.type) {
      case NotificationType.vendorAssigned:
      case NotificationType.newWorkRequest:
        if (notification.relatedId != null) {
          Navigator.pushNamed(
            context,
            AppRoutes.vendorEventDetails,
            arguments: {'eventId': notification.relatedId},
          );
        } else {
          Navigator.pushNamed(context, AppRoutes.vendorMain);
        }
        break;

      case NotificationType.paymentReceived:
      // Logic to navigate to your vendor earnings page
        Navigator.pushNamed(context, AppRoutes.vendorMain);
        break;

      default:
        _showDetails(context, notification);
    }
  }

  void _showDetails(BuildContext context, NotificationModel notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(notification.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(notification.message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Clear All?"),
        content: const Text("Delete all business notifications?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(onPressed: () {
            Provider.of<NotificationProvider>(context, listen: false).clearAll();
            Navigator.pop(ctx);
          }, child: const Text("Clear", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

class _VendorNotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _VendorNotificationCard({required this.notification, required this.onTap, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;
    final style = _getStyle(notification.type);

    return Dismissible(
      key: Key(notification.id),
      onDismissed: (_) => onDismiss(),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: isUnread ? Colors.deepPurple.shade50 : Colors.white,
        elevation: isUnread ? 2 : 0,
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: isUnread ? Colors.deepPurple.withOpacity(0.3) : Colors.grey.shade200),
        ),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: style.color.withOpacity(0.1),
            child: Icon(style.icon, color: style.color, size: 20),
          ),
          title: Text(notification.title, style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
          subtitle: Text(notification.message, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: isUnread ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle)) : null,
        ),
      ),
    );
  }

  _CardStyle _getStyle(String type) {
    if (type.contains('assign')) return _CardStyle(Icons.assignment_turned_in, Colors.purple);
    if (type.contains('payment')) return _CardStyle(Icons.account_balance_wallet, Colors.green);
    if (type.contains('approve')) return _CardStyle(Icons.verified_user, Colors.blue);
    return _CardStyle(Icons.notifications, Colors.grey);
  }
}

class _CardStyle {
  final IconData icon;
  final Color color;
  _CardStyle(this.icon, this.color);
}