// lib/screens/my_events/event_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/user_event_provider.dart';
import '../../models/user_event_model.dart';
import '../../widgets/loading_indicator.dart';

// Tab Imports
import 'tabs/overview_tab.dart';
import 'tabs/selected_services_tab.dart';
import 'tabs/guests_tab.dart';
import 'tabs/budget_tab.dart';
import 'tabs/tasks_tab.dart';
import 'tabs/vendors_tab.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  final int initialTab;

  const EventDetailScreen({
    super.key,
    required this.eventId,
    this.initialTab = 0,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: widget.initialTab);

    // 🔥 Initial Load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvent();
    });
  }

  Future<void> _loadEvent() async {
    if (!mounted) return;
    await Provider.of<UserEventProvider>(context, listen: false).fetchEventById(widget.eventId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 🕒 Fixed: Calculation logic
  int _calculateDaysLeft(DateTime? deadline) {
    if (deadline == null) return 0;
    final now = DateTime.now();
    return deadline.difference(now).inDays;
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserEventProvider>(
        builder: (context, eventProvider, child) {
          // 1. Loading State
          if (eventProvider.isLoading && eventProvider.selectedEvent == null) {
            return const Center(child: LoadingIndicator());
          }

          final event = eventProvider.selectedEvent;

          // 2. Error State
          if (event == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Event data could not be loaded.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back')
                  ),
                ],
              ),
            );
          }

          // 3. Logic based on updated model
          bool showPaymentWarning = (event.status == EventStatus.approved) &&
              (event.amountPaid < event.totalEstimatedCost) &&
              (event.paymentDeadline != null);

          int daysLeft = showPaymentWarning ? _calculateDaysLeft(event.paymentDeadline) : 0;
          double headerHeight = showPaymentWarning ? 320.0 : 260.0;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: headerHeight,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.primary),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    // ✅ NEW: Refresh Button (Essential for checking Admin assignments)
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.refresh, color: AppColors.primary, size: 20),
                      ),
                      onPressed: _loadEvent,
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.more_vert, color: AppColors.primary),
                      ),
                      onPressed: () => _showOptionsBottomSheet(context, event),
                    ),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 60,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (showPaymentWarning)
                                  _buildWarningBanner(daysLeft),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    event.eventTypeName,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  event.eventName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildInfoBadge(Icons.calendar_today, _formatDate(event.eventDate)),
                                      const SizedBox(width: 12),
                                      _buildInfoBadge(Icons.access_time, event.eventTime),
                                      const SizedBox(width: 12),
                                      _buildInfoBadge(Icons.people, '${event.guestCount} Guests'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: AppColors.secondary,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    tabAlignment: TabAlignment.start,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Services'),
                      Tab(text: 'Guests'),
                      Tab(text: 'Budget'),
                      Tab(text: 'Tasks'),
                      Tab(text: 'Professionals'), // ✅ Renamed from Team
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                OverviewTab(event: event),
                SelectedServicesTab(eventId: widget.eventId),
                GuestsTab(eventId: widget.eventId),
                BudgetTab(eventId: widget.eventId, totalEstimated: event.totalEstimatedCost),
                TasksTab(eventId: widget.eventId),
                VendorsTab(
                  eventTypeId: event.eventTypeId,
                  eventId: widget.eventId,
                  eventName: event.eventName,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🎨 Sub-widget for cleaner code
  Widget _buildWarningBanner(int daysLeft) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade800),
      ),
      child: Row(
        children: [
          Icon(Icons.access_alarm, color: Colors.orange.shade900, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              daysLeft > 0
                  ? "Action Required: Complete payment within $daysLeft days."
                  : "Urgent: Payment Overdue! Event at risk of cancellation.",
              style: TextStyle(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.white70)),
      ],
    );
  }

  void _showOptionsBottomSheet(BuildContext context, UserEvent event) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.white,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.primary),
              title: const Text('Edit Event Details', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(
                    context,
                    AppRoutes.eventForm,
                    arguments: {'eventId': widget.eventId, 'isEditing': true}
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.primary),
              title: const Text('Share Invite Link', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(ctx);
                _shareEvent(event);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Cancel & Delete Event', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareEvent(UserEvent event) {
    final String message =
        "📅 You're invited to *${event.eventName}*!\n"
        "📍 Venue: ${event.venue}\n"
        "⏰ Date: ${_formatDate(event.eventDate)} at ${event.eventTime}\n"
        "✨ See you there!";
    Share.share(message);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to permanently delete this event? All guest lists and bookings will be lost.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Back')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final eventProvider = Provider.of<UserEventProvider>(context, listen: false);
              final success = await eventProvider.deleteEvent(widget.eventId);
              if (mounted) {
                if (success) {
                  Navigator.pop(context); // Exit detail screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event deleted successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error deleting event. Try again.'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}