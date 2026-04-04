// lib/screens/payments/payment_success_screen.dart

import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../config/app_routes.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final double? amount;
  final String? paymentMethod;
  final String? paymentType;
  final String? itemName;
  final String? eventId;
  final String? transactionId;

  const PaymentSuccessScreen({
    super.key,
    this.amount,
    this.paymentMethod,
    this.paymentType,
    this.itemName,
    this.eventId,
    this.transactionId,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  // ✅ FIXED: Navigate to Payment History
  void _goToPaymentHistory() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.paymentHistory,
      arguments: widget.eventId,
    );
  }

  void _sendReceiptEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('Receipt sent to your email!')),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  IconData _getPaymentIcon(String method) {
    if (method.toLowerCase().contains('card') ||
        method.toLowerCase().contains('credit') ||
        method.toLowerCase().contains('debit')) {
      return Icons.credit_card;
    } else if (method.toLowerCase().contains('upi') ||
        method.toLowerCase().contains('gpay') ||
        method.toLowerCase().contains('phonepe')) {
      return Icons.qr_code;
    } else if (method.toLowerCase().contains('bank') ||
        method.toLowerCase().contains('net')) {
      return Icons.account_balance;
    } else if (method.toLowerCase().contains('wallet')) {
      return Icons.account_balance_wallet;
    } else {
      return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = "Payment Successful!";
    String subtitle = "Your payment has been processed successfully.";
    IconData icon = Icons.check_circle;
    Color color = Colors.green;

    // ✅ Handle different payment types
    if (widget.paymentType == 'vendor') {
      title = "Vendor Payment Successful!";
      subtitle = widget.itemName != null
          ? "Payment to '${widget.itemName}' completed successfully."
          : "Vendor payment has been processed.";
      icon = Icons.verified;
    } else if (widget.paymentType == 'expense') {
      title = "Expense Paid!";
      subtitle = widget.itemName != null
          ? "'${widget.itemName}' has been marked as paid."
          : "Your expense has been paid successfully.";
      icon = Icons.receipt_long;
    } else if (widget.paymentType == 'booking') {
      title = "Booking Confirmed!";
      subtitle = "Your service booking payment is complete.";
      icon = Icons.event_available;
    }

    return WillPopScope(
      onWillPop: () async {
        _goToHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // ✅ Success Animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 70),
                  ),
                ),

                const SizedBox(height: 32),

                // 🎉 Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 12),

                // 📝 Subtitle
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 32),

                // 💰 Amount Card
                if (widget.amount != null)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Amount Paid",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${AppStrings.rupee}${widget.amount!.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          if (widget.paymentMethod != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getPaymentIcon(widget.paymentMethod!),
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.paymentMethod!,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Text(
                            "Transaction ID: ${widget.transactionId ?? "TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}"}",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const Spacer(),

                // 🏠 Back to Home Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _goToHome,
                    icon: const Icon(Icons.home, color: Colors.white),
                    label: const Text(
                      "Back to Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 📋 View Payment History Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: _goToPaymentHistory,
                    icon: Icon(Icons.receipt_long, color: AppColors.primary),
                    label: Text(
                      "View Payment History",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 📧 Receipt via Email (Optional)
                TextButton.icon(
                  onPressed: _sendReceiptEmail,
                  icon: Icon(Icons.email_outlined,
                      size: 18, color: Colors.grey.shade600),
                  label: Text(
                    "Send Receipt to Email",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}