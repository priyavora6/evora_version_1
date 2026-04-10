// lib/providers/payment_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/payment_model.dart';

class PaymentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _stripePublishableKey => dotenv.get('STRIPE_PUBLISHABLE_KEY', fallback: '');
  String get _stripeSecretKey => dotenv.get('STRIPE_SECRET_KEY', fallback: '');

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _lastTransactionId;
  String? get lastTransactionId => _lastTransactionId;

  PaymentProvider() {
    _initStripe();
  }

  void _initStripe() {
    Stripe.publishableKey = _stripePublishableKey;
    Stripe.instance.applySettings();
  }

  // ✅ ADDED: getClientSecret for manual Stripe flow
  Future<String?> getClientSecret({required double amount, String currency = 'inr'}) async {
    final intent = await _createPaymentIntent(amount, currency);
    return intent?['client_secret'];
  }

  Future<bool> processPayment({
    required String userId,
    required String userName,
    required double amount,
    required String method,
    required String eventId,
    String? expenseId,
    String? expenseName,
    String? bookingId,
    String type = 'event',
    String? vendorId,
    String? vendorName,
    String? serviceType,
    bool skipStripeUI = false, // ✅ Optional: skip Stripe UI if already handled
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String txnId = "STRIPE_${DateTime.now().millisecondsSinceEpoch}";

      if (!skipStripeUI) {
        Map<String, dynamic>? paymentIntent = await _createPaymentIntent(amount, "INR");
        if (paymentIntent == null) throw Exception("Failed to create Payment Intent");

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent['client_secret'],
            merchantDisplayName: 'Evora Events',
            style: ThemeMode.light,
          ),
        );

        await Stripe.instance.presentPaymentSheet();
        txnId = paymentIntent['id'] ?? txnId;
      }

      DocumentSnapshot eventDoc = await _firestore.collection('userEvents').doc(eventId).get();
      if (!eventDoc.exists) throw Exception("Event not found");

      Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;
      String eventName = eventData['eventName'] ?? 'Unknown Event';

      _lastTransactionId = txnId;

      String paymentId = _firestore.collection('payments').doc().id;
      String paymentTitle = _getPaymentTitle(type, eventName, expenseName ?? vendorName);

      PaymentModel newPayment = PaymentModel(
        id: paymentId,
        userId: userId,
        userName: userName,
        amount: amount,
        method: method,
        status: "success",
        transactionId: txnId,
        timestamp: DateTime.now(),
        eventName: paymentTitle,
        eventId: eventId,
        expenseId: expenseId,
        expenseName: expenseName ?? vendorName,
        bookingId: bookingId,
        type: type,
        vendorId: vendorId,
        vendorName: vendorName,
        serviceType: serviceType,
      );

      WriteBatch batch = _firestore.batch();
      batch.set(_firestore.collection('payments').doc(paymentId), newPayment.toMap());
      batch.update(_firestore.collection('userEvents').doc(eventId), {
        'amountPaid': FieldValue.increment(amount),
        'lastPaymentDate': FieldValue.serverTimestamp(),
      });

      if (type == 'booking' && bookingId != null && bookingId.isNotEmpty) {
        DocumentReference bookingRef = _firestore
            .collection('userEvents')
            .doc(eventId)
            .collection('bookings')
            .doc(bookingId);

        batch.update(bookingRef, {
          'status': 'paid',
          'paidAt': FieldValue.serverTimestamp(),
          'paymentId': paymentId,
          'transactionId': txnId,
        });
      }

      await batch.commit();

      _isLoading = false;
      notifyListeners();
      return true;

    } on StripeException catch (e) {
      debugPrint("❌ Stripe Error: ${e.error.localizedMessage}");
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint("❌ General Payment Error: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(double amount, String currency) async {
    try {
      String amountInSmallestUnit = (amount * 100).toInt().toString();

      Map<String, dynamic> body = {
        'amount': amountInSmallestUnit,
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('❌ Error creating payment intent: $err');
      return null;
    }
  }

  // ... (rest of history and stats methods remain same)
  Stream<List<PaymentModel>> getPaymentHistory(String userId, {String? eventId}) {
    Query query = _firestore
        .collection('payments')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true);

    if (eventId != null) {
      query = query.where('eventId', isEqualTo: eventId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PaymentModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<Map<String, dynamic>> getPaymentStats(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'success')
          .get();

      double totalPaid = 0;
      int successCount = 0;
      Map<String, double> methodTotals = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final amount = (data['amount'] ?? 0).toDouble();
        final method = data['method']?.toString() ?? 'Unknown';

        totalPaid += amount;
        successCount++;
        methodTotals[method] = (methodTotals[method] ?? 0) + amount;
      }

      return {
        'totalPaid': totalPaid,
        'successCount': successCount,
        'methodTotals': methodTotals,
      };
    } catch (e) {
      return {'totalPaid': 0.0, 'successCount': 0, 'methodTotals': {}};
    }
  }

  String _getPaymentTitle(String type, String eventName, String? expenseName) {
    switch (type.toLowerCase()) {
      case 'expense': return expenseName ?? 'Expense Payment';
      case 'booking': return 'Service Booking - $eventName';
      case 'vendor': return 'Vendor Payment - ${expenseName ?? 'Professional'}';
      default: return eventName;
    }
  }
}
