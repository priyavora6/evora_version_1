// lib/screens/notifications/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/notification_model.dart';
import '../../providers/notification_provider.dart';
import '../../services/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        Provider.of<NotificationProvider>(context, listen: false)
            .startListening(userId: uid, isVendorSide: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              if (provider.unreadCount == 0) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.done_all),
                tooltip: 'Mark all as read',
                onPressed: () => provider.markAllAsRead(),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmation(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear All'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return _buildErrorState(provider.errorMessage!);
          }

          if (provider.notifications.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => provider.refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.notifications.length,
              itemBuilder: (context, index) {
                return _NotificationCard(
                  notification: provider.notifications[index],
                  onTap: () => _handleNotificationTap(
                    context,
                    provider.notifications[index],
                  ),
                  onDismiss: () => provider.deleteNotification(
                    provider.notifications[index].id,
                  ),
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
          Icon(Icons.notifications_off_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No notifications yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text("We'll notify you when something arrives", style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          const Text("Something went wrong", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Provider.of<NotificationProvider>(context, listen: false).refresh(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, NotificationModel notification) {
    Provider.of<NotificationProvider>(context, listen: false).markAsRead(notification.id);

    switch (notification.type) {
      case NotificationType.bookingApproved:
      case NotificationType.bookingRejected:
        if (notification.relatedId != null) {
          Navigator.pushNamed(context, '/booking-details', arguments: {'bookingId': notification.relatedId});
        }
        break;
      case NotificationType.paymentSuccess:
      case NotificationType.paymentReminder:
        Navigator.pushNamed(context, '/my-bookings');
        break;
      case NotificationType.taskReminder:
        Navigator.pushNamed(context, '/tasks');
        break;
      default:
        _showNotificationDetails(context, notification);
    }
  }

  void _showNotificationDetails(BuildContext context, NotificationModel notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getNotificationIcon(notification.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(notification.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(notification.message, style: const TextStyle(fontSize: 16)),
            if (notification.createdAt != null) ...[
              const SizedBox(height: 16),
              Text(
                DateFormat('MMM dd, yyyy • hh:mm a').format(notification.createdAt!),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _getNotificationIcon(String type) {
    final style = _NotificationStyle.fromType(type);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: style.color.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(style.icon, color: style.color, size: 28),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All Notifications?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false).clearAll();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Clear All"),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({required this.notification, required this.onTap, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final style = _NotificationStyle.fromType(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : style.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: notification.isRead ? Colors.grey[200]! : style.color.withOpacity(0.3), width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: style.color.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(style.icon, color: style.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.title,
                          style: TextStyle(fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(notification.message,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(children: [
                          Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(notification.createdAt != null ? _getTimeAgo(notification.createdAt!) : '',
                            style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                        ]),
                      ],
                    ),
                  ),
                  if (!notification.isRead)
                    Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(color: style.color, shape: BoxShape.circle)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return DateFormat('MMM dd').format(date);
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}

class _NotificationStyle {
  final IconData icon;
  final Color color;
  _NotificationStyle({required this.icon, required this.color});

  factory _NotificationStyle.fromType(String type) {
    switch (type) {
      case NotificationType.bookingApproved: return _NotificationStyle(icon: Icons.check_circle, color: Colors.green);
      case NotificationType.bookingRejected: return _NotificationStyle(icon: Icons.cancel, color: Colors.red);
      case NotificationType.paymentSuccess:
      case NotificationType.paymentReceived: return _NotificationStyle(icon: Icons.payments, color: Colors.teal);
      case NotificationType.taskReminder: return _NotificationStyle(icon: Icons.assignment_late, color: Colors.orange);
      case NotificationType.vendorAssigned:
      case NotificationType.newWorkRequest: return _NotificationStyle(icon: Icons.work, color: Colors.blue);
      // ✅ Handle Login/Welcome type
      case NotificationType.login: return _NotificationStyle(icon: Icons.auto_awesome, color: Colors.amber);
      default: return _NotificationStyle(icon: Icons.notifications, color: Colors.indigo);
    }
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: CircularProgressIndicator());
}