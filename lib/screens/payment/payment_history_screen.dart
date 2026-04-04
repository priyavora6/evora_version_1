// lib/screens/payments/payment_history_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../providers/auth_provider.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final String? eventId; // ✅ Added eventId to the class

  const PaymentHistoryScreen({super.key, this.eventId}); // ✅ Added to constructor

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String _filter = 'all';
  String? _eventId; // Use local variable for consistency if needed, or use widget.eventId

  @override
  void initState() {
    super.initState();
    _eventId = widget.eventId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ Handle arguments if passed via pushNamed as well
    if (_eventId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _eventId = args;
      } else if (args is Map<String, dynamic>) {
        _eventId = args['eventId'] as String?;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id ?? '';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(_eventId != null ? "Event Payments" : "Payment History"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryHeader(userId),
          _buildFilterChips(),
          Expanded(child: _buildPaymentList(userId)),
        ],
      ),
    );
  }

  // Rest of your existing methods remain the same...

  String _getPaymentTitle(String type, String? eventName, String? vendorName) {
    switch (type.toLowerCase()) {
      case 'vendor':
        return vendorName ?? 'Vendor Payment';
      case 'expense':
        return 'Expense Payment';
      case 'booking':
        return 'Service Booking';
      case 'event':
      default:
        return eventName ?? 'Event Payment';
    }
  }

  Widget _buildPaymentCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final amount = (data['amount'] ?? 0).toDouble();
    final method = data['method']?.toString() ?? 'Unknown';
    final status = data['status']?.toString().toLowerCase() ?? 'success';
    final timestamp = data['timestamp'] as Timestamp?;
    final date = timestamp?.toDate() ?? DateTime.now();
    final eventName = data['eventName']?.toString();
    final vendorName = data['vendorName']?.toString();
    final type = data['type']?.toString() ?? 'event';

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case 'success':
      case 'paid':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Success';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = 'Pending';
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Failed';
        break;
      case 'refunded':
        statusColor = Colors.purple;
        statusIcon = Icons.money_off;
        statusText = 'Refunded';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Unknown';
    }

    return GestureDetector(
      onTap: () => _showPaymentDetails(data, doc.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getMethodColor(method).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getMethodIcon(method),
                  color: _getMethodColor(method),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _getPaymentTitle(type, eventName, vendorName),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "${AppStrings.rupee}${amount.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Payment Type Badge
                        if (type == 'vendor')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.business,
                                    size: 10, color: Colors.green.shade700),
                                const SizedBox(width: 4),
                                Text(
                                  'Vendor',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              method,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 10, color: statusColor),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat('hh:mm a').format(date),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentDetails(Map<String, dynamic> data, String paymentId) {
    final amount = (data['amount'] ?? 0).toDouble();
    final method = data['method']?.toString() ?? 'Unknown';
    final status = data['status']?.toString().toLowerCase() ?? 'success';
    final timestamp = data['timestamp'] as Timestamp?;
    final date = timestamp?.toDate() ?? DateTime.now();
    final eventName = data['eventName']?.toString() ?? 'N/A';
    final vendorName = data['vendorName']?.toString();
    final serviceType = data['serviceType']?.toString();
    final type = data['type']?.toString() ?? 'event';
    final transactionId = data['transactionId']?.toString() ??
        "TXN${paymentId.substring(0, 8).toUpperCase()}";

    Color statusColor = status == 'success' || status == 'paid'
        ? Colors.green
        : (status == 'pending'
        ? Colors.orange
        : (status == 'refunded' ? Colors.purple : Colors.red));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                status == 'success' || status == 'paid'
                    ? Icons.check_circle
                    : (status == 'pending'
                    ? Icons.pending
                    : (status == 'refunded'
                    ? Icons.money_off
                    : Icons.cancel)),
                color: statusColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "${AppStrings.rupee}${amount.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            _buildDetailRow("Transaction ID", transactionId),
            _buildDetailRow("Payment Type", _capitalizeFirst(type)),
            if (type == 'vendor' && vendorName != null) ...[
              _buildDetailRow("Vendor", vendorName),
              if (serviceType != null) _buildDetailRow("Service", serviceType),
            ] else
              _buildDetailRow("Event", eventName),
            _buildDetailRow("Payment Method", method),
            _buildDetailRow("Date", DateFormat('dd MMM yyyy').format(date)),
            _buildDetailRow("Time", DateFormat('hh:mm:ss a').format(date)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getPaymentsStream(userId),
      builder: (context, snapshot) {
        double totalPaid = 0;
        int successCount = 0;
        int pendingCount = 0;

        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final status =
                data['status']?.toString().toLowerCase() ?? 'success';
            final amount = (data['amount'] ?? 0).toDouble();

            if (status == 'success' || status == 'paid') {
              totalPaid += amount;
              successCount++;
            } else if (status == 'pending') {
              pendingCount++;
            }
          }
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const Text(
                "Total Payments",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                "${AppStrings.rupee}${totalPaid.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMiniStat("Successful", successCount.toString(),
                      Icons.check_circle, Colors.green),
                  Container(width: 1, height: 30, color: Colors.white30),
                  _buildMiniStat("Pending", pendingCount.toString(),
                      Icons.pending, Colors.orange),
                  Container(width: 1, height: 30, color: Colors.white30),
                  _buildMiniStat("Total", (successCount + pendingCount).toString(),
                      Icons.receipt, Colors.white),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMiniStat(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip('all', 'All', Icons.list),
            const SizedBox(width: 8),
            _buildChip('success', 'Successful', Icons.check_circle),
            const SizedBox(width: 8),
            _buildChip('pending', 'Pending', Icons.pending),
            const SizedBox(width: 8),
            _buildChip('failed', 'Failed', Icons.cancel),
            const SizedBox(width: 8),
            _buildChip('vendor', 'Vendors', Icons.business),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String value, String label, IconData icon) {
    final isSelected = _filter == value;
    Color chipColor;

    switch (value) {
      case 'success':
        chipColor = Colors.green;
        break;
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'failed':
        chipColor = Colors.red;
        break;
      case 'vendor':
        chipColor = Colors.purple;
        break;
      default:
        chipColor = AppColors.primary;
    }

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : chipColor,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      selectedColor: chipColor,
      backgroundColor: Colors.white,
      checkmarkColor: Colors.white,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? chipColor : Colors.grey.shade300),
      ),
      onSelected: (selected) {
        setState(() => _filter = value);
      },
    );
  }

  Widget _buildPaymentList(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getPaymentsStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 60, color: Colors.red.shade300),
                const SizedBox(height: 16),
                const Text("Error loading payments"),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        var payments = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          if (_filter == 'all') return true;

          if (_filter == 'vendor') {
            return data['type']?.toString().toLowerCase() == 'vendor';
          }

          final status = data['status']?.toString().toLowerCase() ?? 'success';
          if (_filter == 'success')
            return status == 'success' || status == 'paid';
          if (_filter == 'pending') return status == 'pending';
          if (_filter == 'failed') return status == 'failed';
          return true;
        }).toList();

        if (payments.isEmpty) {
          return _buildNoResultsState();
        }

        Map<String, List<DocumentSnapshot>> groupedPayments = {};
        for (var doc in payments) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = data['timestamp'] as Timestamp?;
          final date = timestamp?.toDate() ?? DateTime.now();
          final dateKey = DateFormat('dd MMM yyyy').format(date);

          if (!groupedPayments.containsKey(dateKey)) {
            groupedPayments[dateKey] = [];
          }
          groupedPayments[dateKey]!.add(doc);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groupedPayments.length,
          itemBuilder: (context, index) {
            final dateKey = groupedPayments.keys.elementAt(index);
            final dayPayments = groupedPayments[dateKey]!;
            final dayTotal = dayPayments.fold<double>(0, (sum, doc) {
              final data = doc.data() as Map<String, dynamic>;
              return sum + (data['amount'] ?? 0).toDouble();
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateKey,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${AppStrings.rupee}${dayTotal.toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...dayPayments.map((doc) => _buildPaymentCard(doc)),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No Payments Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your payment history will appear here",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No $_filter payments found",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filter & Sort",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text("This Week"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("This Month"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.sort),
              title: const Text("Sort by Amount"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text("Sort by Date"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getPaymentsStream(String userId) {
    Query query = FirebaseFirestore.instance
        .collection('payments')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true);

    if (_eventId != null) {
      query = query.where('eventId', isEqualTo: _eventId);
    }

    return query.snapshots();
  }

  IconData _getMethodIcon(String method) {
    final m = method.toLowerCase();
    if (m.contains('card') || m.contains('credit') || m.contains('debit')) {
      return Icons.credit_card;
    } else if (m.contains('upi') ||
        m.contains('gpay') ||
        m.contains('phonepe')) {
      return Icons.qr_code;
    } else if (m.contains('bank') || m.contains('net')) {
      return Icons.account_balance;
    } else if (m.contains('wallet')) {
      return Icons.account_balance_wallet;
    } else if (m.contains('cash')) {
      return Icons.money;
    }
    return Icons.payment;
  }

  Color _getMethodColor(String method) {
    final m = method.toLowerCase();
    if (m.contains('card')) return Colors.blue;
    if (m.contains('upi')) return Colors.purple;
    if (m.contains('bank')) return Colors.teal;
    if (m.contains('wallet')) return Colors.orange;
    if (m.contains('cash')) return Colors.green;
    return Colors.grey;
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
