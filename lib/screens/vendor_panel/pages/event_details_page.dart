import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/app_colors.dart';
import '../../../providers/auth_provider.dart';
// ✅ Import the correct unified model
import '../../../models/cart_item_model.dart';

class VendorEventDetailsPage extends StatefulWidget {
  final String eventId;

  const VendorEventDetailsPage({
    super.key,
    required this.eventId,
  });

  @override
  State<VendorEventDetailsPage> createState() => _VendorEventDetailsPageState();
}

class _VendorEventDetailsPageState extends State<VendorEventDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userEvents')
            .doc(widget.eventId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Event not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final authProvider = Provider.of<AuthProvider>(context, listen: false);

          // Get vendor ID safely
          final vendorId = authProvider.user?.id ?? '';

          // Get this vendor's assignment details
          final assignedVendors = data['assignedVendors'] as List<dynamic>? ?? [];
          final myAssignment = assignedVendors.firstWhere(
                (v) => v['vendorId'] == vendorId,
            orElse: () => null,
          );

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildSliverAppBar(context, data),
              ];
            },
            body: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Services'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Overview
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildEventInfoCard(data),
                            const SizedBox(height: 20),
                            _buildClientInfoCard(context, data),
                            const SizedBox(height: 20),
                            _buildVenueCard(data),
                            const SizedBox(height: 20),
                            if (myAssignment != null)
                              _buildMyAssignmentCard(myAssignment),
                            const SizedBox(height: 20),
                            if (data['adminNote'] != null && (data['adminNote'] as String).isNotEmpty)
                              _buildRequirementsCard(data['adminNote']),
                            const SizedBox(height: 30),
                            _buildActionButtons(context, data, myAssignment),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Tab 2: Services
                      _buildServicesTab(widget.eventId),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Map<String, dynamic> data) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          data['eventName'] ?? 'Event',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(Icons.event_available, color: Colors.white24, size: 80),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesTab(String eventId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userEvents')
          .doc(eventId)
          .collection('selectedItems')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No specific services added."));
        }

        final items = snapshot.data!.docs
            .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(item.subcategoryName), // ✅ FIXED
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  item.name, // ✅ FIXED: itemName -> name
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Text(
                  item.subcategoryName, // ✅ FIXED: sectionName -> subcategoryName
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                trailing: Text(
                  "₹${item.price.toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getCategoryIcon(String subcategory) {
    String s = subcategory.toLowerCase();
    if (s.contains('photo')) return Icons.camera_alt_outlined;
    if (s.contains('cake')) return Icons.cake_outlined;
    if (s.contains('decor')) return Icons.auto_awesome_mosaic_outlined;
    if (s.contains('food')) return Icons.restaurant_menu;
    if (s.contains('makeup')) return Icons.face_retouching_natural;
    return Icons.miscellaneous_services;
  }

  // UI Helpers for Cards
  Widget _buildEventInfoCard(Map<String, dynamic> data) {
    final eventDate = (data['eventDate'] as Timestamp?)?.toDate() ?? DateTime.now();
    return _buildCardWrapper(
      title: 'Event Details',
      icon: Icons.event,
      children: [
        _buildInfoRow(Icons.calendar_today, 'Date', _formatDate(eventDate)),
        _buildInfoRow(Icons.access_time, 'Time', data['eventTime'] ?? 'N/A'),
        _buildInfoRow(Icons.people, 'Expected Guests', '${data['guestCount'] ?? 0} people'),
        _buildInfoRow(Icons.info_outline, 'Status', data['status'] ?? 'PENDING', valueColor: _getStatusColor(data['status'] ?? '')),
      ],
    );
  }

  Widget _buildClientInfoCard(BuildContext context, Map<String, dynamic> data) {
    return _buildCardWrapper(
      title: 'Client Information',
      icon: Icons.person,
      children: [
        _buildInfoRow(Icons.person_outline, 'Name', data['userName'] ?? 'N/A'),
        _buildInfoRow(Icons.phone_outlined, 'Phone', data['userPhone'] ?? 'N/A'),
        _buildInfoRow(Icons.email_outlined, 'Email', data['userEmail'] ?? 'N/A'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: OutlinedButton.icon(onPressed: () => _makePhoneCall(data['userPhone'] ?? ''), icon: const Icon(Icons.phone), label: const Text('Call'))),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton.icon(onPressed: () => _sendEmail(data['userEmail'] ?? ''), icon: const Icon(Icons.email), label: const Text('Email'))),
          ],
        )
      ],
    );
  }

  Widget _buildVenueCard(Map<String, dynamic> data) {
    return _buildCardWrapper(
      title: 'Venue Details',
      icon: Icons.location_on,
      children: [
        _buildInfoRow(Icons.business, 'Venue', data['venue'] ?? 'N/A'),
        _buildInfoRow(Icons.location_city, 'City', data['city'] ?? 'N/A'),
        _buildInfoRow(Icons.map, 'Address', data['location'] ?? 'N/A'),
      ],
    );
  }

  Widget _buildMyAssignmentCard(Map<String, dynamic> assignment) {
    final price = (assignment['price'] ?? 0.0).toDouble();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.primary.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Earnings', style: TextStyle(fontSize: 13, color: Colors.grey)),
          Text('₹${price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildRequirementsCard(String requirements) {
    return _buildCardWrapper(title: 'Requirements', icon: Icons.note, children: [Text(requirements, style: const TextStyle(height: 1.5))]);
  }

  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> data, Map<String, dynamic>? myAssignment) {
    final status = myAssignment?['status'] ?? 'assigned';
    if (status == 'completed') return const Center(child: Text("Event Completed ✅", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)));

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(16)),
        onPressed: () => _markAsCompleted(context),
        child: const Text('Mark as Completed', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // Base Helpers
  Widget _buildCardWrapper({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]),
        const SizedBox(height: 16),
        ...children
      ]),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 10),
        Text("$label: ", style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: valueColor ?? Colors.black)),
      ]),
    );
  }

  Future<void> _markAsCompleted(BuildContext context) async {
    // Logic to update Firestore status to completed
    await FirebaseFirestore.instance.collection('userEvents').doc(widget.eventId).update({'status': 'COMPLETED'});
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event marked as completed!")));
  }

  String _formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";
  Color _getStatusColor(String status) => status.toLowerCase() == 'confirmed' ? Colors.green : Colors.orange;
  Future<void> _makePhoneCall(String p) async => await launchUrl(Uri.parse("tel:$p"));
  Future<void> _sendEmail(String e) async => await launchUrl(Uri.parse("mailto:$e"));
}