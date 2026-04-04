// lib/screens/vendor_panel/tabs/assigned_work_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/vendor_panel_provider.dart';

class AssignedWorkTab extends StatelessWidget {
  const AssignedWorkTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final vendorProvider = Provider.of<VendorPanelProvider>(context, listen: false);
    final vendorId = auth.currentVendor?.id ?? auth.currentUser?.vendorId;

    if (vendorId == null) return _buildErrorState("Vendor profile not found.");

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: vendorProvider.getAssignedWorkStream(vendorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) return _buildErrorState("Error loading assignments");

          final assignments = snapshot.data ?? [];
          if (assignments.isEmpty) return _buildEmptyState();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final booking = assignments[index];
              return _buildProfessionalWorkCard(context, booking);
            },
          );
        },
      ),
    );
  }

  Widget _buildProfessionalWorkCard(BuildContext context, Map<String, dynamic> data) {
    // ═══════════════════════════════════════════════════════════════════════════
    // 🛰️ DYNAMIC DATA PARSING (Strictly from your Firestore logs)
    // ═══════════════════════════════════════════════════════════════════════════
    final String eventName = data['eventName'] ?? 'Unnamed Event';
    final String service = data['serviceType'] ?? data['vendorCategory'] ?? 'Service';
    final String venue = data['venue'] ?? data['location'] ?? 'Venue Address TBA';
    final String clientName = data['userName'] ?? 'Customer';
    final String clientPhone = data['userPhone'] ?? '';

    // Status & Payment
    final String status = (data['status'] ?? 'assigned').toString().toUpperCase();
    final String paymentStatus = (data['paymentStatus'] ?? 'Pending').toString();
    final double vendorPrice = (data['vendorPrice'] ?? data['price'] ?? 0).toDouble();

    // Dates
    final Timestamp? eventTs = data['eventDate'] as Timestamp?;
    final DateTime eventDate = eventTs?.toDate() ?? DateTime.now();
    final String startTime = data['eventTime'] ?? '10:00 AM';

    final Timestamp? deadlineTs = data['assignmentDeadline'] as Timestamp?;
    final DateTime? deadline = deadlineTs?.toDate();

    // Logic: Reporting time is 2.5 hours before start time
    String reportingTime = _calculateReportingTime(startTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 20, offset: const Offset(0, 10))],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // 1. TOP HEADER (Event Info)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bookmark_added_rounded, size: 22, color: Colors.blueGrey),
                const SizedBox(width: 10),
                Expanded(child: Text(eventName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17))),
                _buildBadge(status, _getStatusColor(status)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. FINANCIAL SUMMARY (Payment)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("YOUR EARNINGS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Text("₹${vendorPrice.toStringAsFixed(0)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black)),
                      ],
                    ),
                    _buildBadge(paymentStatus.toUpperCase(), paymentStatus.toLowerCase() == 'paid' ? Colors.green : Colors.orange),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),

                // 3. SCHEDULE DETAILS
                Row(
                  children: [
                    Expanded(child: _buildInfoItem(Icons.calendar_today_rounded, "EVENT DATE", DateFormat('dd MMM, yyyy').format(eventDate))),
                    Expanded(child: _buildInfoItem(Icons.alarm_on_rounded, "REACH BY", reportingTime, valueColor: Colors.orange.shade800)),
                  ],
                ),
                const SizedBox(height: 18),

                // 4. DYNAMIC ADDRESS
                _buildInfoItem(Icons.location_on_rounded, "VENUE ADDRESS", venue, valueColor: Colors.blue.shade900),

                if (deadline != null) ...[
                  const SizedBox(height: 15),
                  _buildDeadlineAlert(deadline),
                ],

                const SizedBox(height: 25),

                // 5. ACTION BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.map_outlined,
                        label: "NAVIGATE",
                        color: Colors.blue.shade800,
                        onTap: () => _openMaps(venue),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.phone_in_talk_rounded,
                        label: "CALL CLIENT",
                        color: Colors.green.shade700,
                        onTap: () => _makeCall(clientPhone),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ⚙️ LOGIC & UI HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  String _calculateReportingTime(String startTime) {
    try {
      final format = DateFormat.jm();
      DateTime time = format.parse(startTime);
      DateTime reporting = time.subtract(const Duration(hours: 2, minutes: 30));
      return format.format(reporting);
    } catch (e) {
      return "2.5 hrs before";
    }
  }

  Widget _buildInfoItem(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade400),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5)),
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor ?? Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineAlert(DateTime deadline) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 16, color: Colors.red),
          const SizedBox(width: 8),
          Text(
            "Complete by: ${DateFormat('dd MMM, hh:mm a').format(deadline)}",
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status.contains('CONFIRM')) return Colors.green;
    if (status.contains('PEND')) return Colors.orange;
    if (status.contains('ASSIGN')) return Colors.blue;
    return Colors.grey;
  }

  Future<void> _makeCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  Future<void> _openMaps(String address) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_outlined, size: 80, color: Colors.grey.shade200),
          const Text("No Work Found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildErrorState(String msg) => Center(child: Text(msg, style: const TextStyle(color: Colors.red)));
}