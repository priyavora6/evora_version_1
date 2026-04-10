// lib/screens/payments/payment_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../providers/payment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/budget_provider.dart';
import '../../screens/payment/payment_success_screen.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final String eventId;
  final String bookingId;
  final String? expenseId;
  final String? expenseName;
  final String? paymentType; // 'event', 'booking', 'expense', 'vendor'

  // ✅ Vendor payment fields
  final String? vendorId;
  final String? vendorName;
  final String? serviceType;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.eventId,
    required this.bookingId,
    this.expenseId,
    this.expenseName,
    this.paymentType,
    this.vendorId,
    this.vendorName,
    this.serviceType,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Credit/Debit Card', 'icon': Icons.credit_card, 'color': Colors.blue},
    {'name': 'UPI (GPay/PhonePe)', 'icon': Icons.qr_code, 'color': Colors.purple},
    {'name': 'Net Banking', 'icon': Icons.account_balance, 'color': Colors.teal},
    {'name': 'Wallet', 'icon': Icons.account_balance_wallet, 'color': Colors.orange},
  ];

  Future<void> _handlePayment() async {
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user == null) {
      _showError("Error: User session not found.");
      return;
    }

    bool success = await paymentProvider.processPayment(
      userId: user.id,
      userName: user.name,
      amount: widget.totalAmount,
      method: _paymentMethods[_selectedMethod]['name'],
      eventId: widget.eventId,
      expenseId: widget.expenseId,
      expenseName: widget.expenseName ?? widget.vendorName,
      bookingId: widget.bookingId,
      type: widget.paymentType ?? 'event',
      vendorId: widget.vendorId,
      vendorName: widget.vendorName,
      serviceType: widget.serviceType,
    );

    if (!mounted) return;

    if (success) {
      await _handlePostPayment(
        budgetProvider,
        notificationProvider,
        user.id,
        paymentProvider.lastTransactionId,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(
            amount: widget.totalAmount,
            paymentMethod: _paymentMethods[_selectedMethod]['name'],
            paymentType: widget.paymentType ?? 'event',
            itemName: widget.vendorName ?? widget.expenseName,
            eventId: widget.eventId,
            transactionId: paymentProvider.lastTransactionId,
          ),
        ),
      );
    } else {
      _showError("Payment Failed. Please try again.");
    }
  }

  Future<void> _handlePostPayment(
      BudgetProvider budgetProvider,
      NotificationProvider notificationProvider,
      String userId,
      String? transactionId,
      ) async {
    final paymentType = widget.paymentType ?? 'event';

    switch (paymentType) {
      case 'vendor':
        if (widget.vendorId != null) {
          await _updateVendorPaymentStatus(transactionId);
          await _sendNotification(
            notificationProvider,
            userId,
            "Vendor Payment Successful! 🎉",
            "Paid ${AppStrings.rupee}${widget.totalAmount.toStringAsFixed(0)} to '${widget.vendorName ?? 'Vendor'}'.",
            false,
          );
        }
        break;

      case 'expense':
        if (widget.expenseId != null) {
          await budgetProvider.markExpenseAsPaidById(widget.eventId, widget.expenseId!);
          await _sendNotification(
            notificationProvider,
            userId,
            "Expense Paid! ✅",
            "Paid ${AppStrings.rupee}${widget.totalAmount.toStringAsFixed(0)} for '${widget.expenseName ?? 'Expense'}'.",
            false,
          );
        }
        break;

      case 'booking':
        if (widget.bookingId.isNotEmpty) {
          await budgetProvider.markBookingAsPaid(widget.eventId, widget.bookingId);
          await _sendNotification(
            notificationProvider,
            userId,
            "Booking Payment Successful! 🎉",
            "Paid ${AppStrings.rupee}${widget.totalAmount.toStringAsFixed(0)}.",
            false,
          );
        }
        break;

      default:
        await budgetProvider.fetchEventBudget(widget.eventId);
        break;
    }
  }

  Future<void> _sendNotification(
      NotificationProvider provider,
      String userId,
      String title,
      String message,
      bool isVendorSide,
      ) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'title': title,
        'message': message,
        'type': NotificationType.paymentSuccess,
        'isRead': false,
        'isVendorSide': isVendorSide,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("❌ Error sending notification: $e");
    }
  }

  Future<void> _updateVendorPaymentStatus(String? transactionId) async {
    if (widget.vendorId == null) return;

    try {
      final eventRef = FirebaseFirestore.instance.collection('userEvents').doc(widget.eventId);
      final eventDoc = await eventRef.get();

      if (!eventDoc.exists) return;

      final data = eventDoc.data() as Map<String, dynamic>;
      final List<dynamic> assignedVendors = List.from(data['assignedVendors'] ?? []);

      bool found = false;
      for (int i = 0; i < assignedVendors.length; i++) {
        if (assignedVendors[i]['vendorId'] == widget.vendorId) {
          assignedVendors[i] = {
            ...assignedVendors[i],
            'paymentStatus': 'paid',
            'paidAt': Timestamp.now(),
            'transactionId': transactionId ?? 'TXN${DateTime.now().millisecondsSinceEpoch}',
            'paymentMethod': _paymentMethods[_selectedMethod]['name'],
          };
          found = true;
          break;
        }
      }

      if (found) {
        double totalVendorPaid = 0;
        for (var v in assignedVendors) {
          if (v['paymentStatus'] == 'paid') {
            totalVendorPaid += (v['price'] ?? 0).toDouble();
          }
        }

        await eventRef.update({
          'assignedVendors': assignedVendors,
          'totalVendorPaid': totalVendorPaid,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('❌ Error updating vendor payment status: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<PaymentProvider>(context).isLoading;
    final paymentType = widget.paymentType ?? 'event';

    String title = "Payment";
    String subtitle = "Event Payment";
    Color accentColor = AppColors.primary;

    if (paymentType == 'vendor') {
      title = "Pay Vendor";
      subtitle = widget.serviceType ?? "Vendor Services";
      accentColor = Colors.green.shade600;
    } else if (paymentType == 'expense') {
      title = "Pay Expense";
      subtitle = widget.expenseName ?? "Other Expense";
      accentColor = Colors.orange.shade600;
    } else if (paymentType == 'booking') {
      title = "Pay Booking";
      subtitle = "Service Payment";
      accentColor = Colors.purple.shade600;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAmountCard(subtitle, accentColor),
            const SizedBox(height: 20),

            if (paymentType == 'vendor' && widget.vendorName != null)
              _buildVendorInfoCard(),

            if (paymentType == 'vendor' && widget.vendorName != null)
              const SizedBox(height: 20),

            _buildSecurityBadge(),
            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _paymentMethods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildPaymentMethodTile(index, accentColor),
            ),

            const SizedBox(height: 24),
            _buildPaymentSummary(),
          ],
        ),
      ),
      bottomNavigationBar: _buildPayButton(isLoading, accentColor),
    );
  }

  Widget _buildVendorInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getServiceIcon(widget.serviceType ?? ''),
              color: Colors.green,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vendorName ?? 'Vendor',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.serviceType ?? 'Service',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'PAYING',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(String subtitle, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              subtitle,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Total Amount",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            "${AppStrings.rupee}${widget.totalAmount.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(int index, Color accentColor) {
    final isSelected = _selectedMethod == index;
    final method = _paymentMethods[index];

    return InkWell(
      onTap: () => setState(() => _selectedMethod = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.05) : Colors.white,
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (method['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(method['icon'], color: method['color']),
            ),
            const SizedBox(width: 16),
            Text(
              method['name'],
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: accentColor)
            else
              Icon(Icons.circle_outlined, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildSummaryRow("Subtotal", widget.totalAmount),
          const Divider(height: 24),
          _buildSummaryRow("Total Paid", widget.totalAmount, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey.shade600,
          ),
        ),
        Text(
          "${AppStrings.rupee}${amount.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.green.shade700 : Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, color: Colors.grey.shade600, size: 14),
            const SizedBox(width: 8),
            Text(
              "256-bit Secure SSL Encryption",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton(bool isLoading, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handlePayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
            child: isLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            )
                : Text(
              "PAY ${AppStrings.rupee}${widget.totalAmount.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getServiceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'photography': return Icons.camera_alt_rounded;
      case 'catering': return Icons.restaurant_menu_rounded;
      case 'decoration': return Icons.celebration_rounded;
      case 'makeup artist': return Icons.brush_rounded;
      case 'dj & music': return Icons.music_note_rounded;
      case 'venue': return Icons.location_on_rounded;
      default: return Icons.business_center_rounded;
    }
  }
}
