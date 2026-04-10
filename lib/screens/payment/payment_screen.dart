import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../providers/payment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/budget_provider.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../../widgets/loading_indicator.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final String eventId;
  final String bookingId;
  final String? expenseId;
  final String? expenseName;
  final String? paymentType;
  final String? vendorId;
  final String? vendorName;
  final String? serviceType;

  const PaymentScreen({
    super.key, required this.totalAmount, required this.eventId,
    required this.bookingId, this.expenseId, this.expenseName,
    this.paymentType, this.vendorId, this.vendorName, this.serviceType,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'card', 'name': 'Credit/Debit Card', 'icon': Icons.credit_card, 'color': Colors.blue},
    {'id': 'upi', 'name': 'UPI (GPay/PhonePe)', 'icon': Icons.qr_code, 'color': Colors.purple},
    {'id': 'net_banking', 'name': 'Net Banking', 'icon': Icons.account_balance, 'color': Colors.teal},
  ];

  Future<void> _handlePayment() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) return;

    setState(() => _isProcessing = true);

    try {
      final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);

      String? clientSecret = await paymentProvider.getClientSecret(
        amount: widget.totalAmount,
        currency: 'inr',
      );

      if (clientSecret == null) throw Exception("Could not initialize payment");

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Evora Events',
          style: ThemeMode.light,
          billingDetails: BillingDetails(
            name: authProvider.user!.name,
            email: authProvider.user!.email,
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      bool success = await paymentProvider.processPayment(
        userId: authProvider.user!.id,
        userName: authProvider.user!.name,
        amount: widget.totalAmount,
        method: _paymentMethods[_selectedMethod]['name'],
        eventId: widget.eventId,
        bookingId: widget.bookingId,
        type: widget.paymentType ?? 'event',
        skipStripeUI: true, // Already presented the sheet
      );

      if (success && mounted) {
        await _triggerPaymentNotifications(authProvider.user!.id);

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(
            amount: widget.totalAmount,
            paymentMethod: _paymentMethods[_selectedMethod]['name'],
            eventId: widget.eventId,
          ),
        ));
      }
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment ${e.error.localizedMessage}"), backgroundColor: Colors.orange),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred during payment"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _triggerPaymentNotifications(String userId) async {
    await NotificationService().sendNotification(NotificationModel(
      id: '',
      userId: userId,
      title: "💳 Payment Successful!",
      message: "₹${widget.totalAmount.toStringAsFixed(0)} paid successfully for ${widget.expenseName ?? 'Event'}.",
      type: 'payment_success',
      relatedId: widget.eventId,
      isRead: false,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Secure Checkout", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black), onPressed: () => Navigator.pop(context)),
      ),
      body: _isProcessing
          ? const Center(child: LoadingIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountCard(),
            const SizedBox(height: 30),
            const Text("Select Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  final isSelected = _selectedMethod == index;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200, width: 2),
                    ),
                    child: RadioListTile(
                      value: index,
                      groupValue: _selectedMethod,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _selectedMethod = val!),
                      title: Text(method['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      secondary: Icon(method['icon'], color: method['color']),
                    ),
                  );
                },
              ),
            ),
            _buildSecurityBadge(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _handlePayment,
                child: Text("PROCEED TO PAY ₹${widget.totalAmount.toStringAsFixed(0)}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(widget.expenseName ?? "Event Payment", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("₹${widget.totalAmount.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const Text("Total Payable Amount", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSecurityBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.lock_outline, size: 14, color: Colors.grey),
        SizedBox(width: 5),
        Text("Secured by Stripe SSL Encryption", style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
