// lib/models/payment_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final String userId;
  final String userName;
  final double amount;
  final String method;
  final String status; // 'success', 'pending', 'failed', 'refunded'
  final String transactionId;
  final String? stripePaymentId;
  final DateTime timestamp;
  final String eventName;
  final String? eventId;
  final String? expenseId;
  final String? expenseName;
  final String? bookingId;
  final String type; // 'event', 'expense', 'booking', 'vendor'

  // ✅ NEW: Vendor payment fields
  final String? payerType; // 'user', 'admin'
  final String? payeeType; // 'admin', 'vendor'
  final String? vendorId;
  final String? vendorName;
  final String? serviceType;
  final double adminProfit;
  final String paymentStep; // 'user_to_admin', 'admin_advance', 'admin_final'
  final bool isAdminPayment;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.amount,
    required this.method,
    required this.status,
    required this.transactionId,
    this.stripePaymentId,
    required this.timestamp,
    required this.eventName,
    this.eventId,
    this.expenseId,
    this.expenseName,
    this.bookingId,
    this.type = 'event',
    this.payerType = 'user',
    this.payeeType = 'admin',
    this.vendorId,
    this.vendorName,
    this.serviceType,
    this.adminProfit = 0.0,
    this.paymentStep = '',
    this.isAdminPayment = false,
  });

  // ── 📤 TO MAP (For Firestore) ──────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'amount': amount,
      'method': method,
      'status': status,
      'transactionId': transactionId,
      'stripePaymentId': stripePaymentId,
      'timestamp': Timestamp.fromDate(timestamp),
      'eventName': eventName,
      'eventId': eventId,
      'expenseId': expenseId,
      'expenseName': expenseName,
      'bookingId': bookingId,
      'type': type,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'serviceType': serviceType,
    };
  }

  // ── 📥 FROM MAP (For JSON/Internal) ────────────────────────────────────────
  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      method: map['method'] ?? '',
      status: map['status'] ?? 'pending',
      transactionId: map['transactionId'] ?? '',
      stripePaymentId: map['stripePaymentId'],
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      eventName: map['eventName'] ?? '',
      eventId: map['eventId'],
      expenseId: map['expenseId'],
      expenseName: map['expenseName'],
      bookingId: map['bookingId'],
      type: map['type'] ?? 'event',
      vendorId: map['vendorId'],
      vendorName: map['vendorName'],
      serviceType: map['serviceType'],
    );
  }

  // ── 📥 FROM FIRESTORE (Direct from Document) ───────────────────────────────
  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel.fromMap({...data, 'id': doc.id});
  }

  // ── ⚙️ COPY WITH ───────────────────────────────────────────────────────────
  PaymentModel copyWith({
    String? id,
    String? userId,
    String? userName,
    double? amount,
    String? method,
    String? status,
    String? transactionId,
    String? stripePaymentId,
    DateTime? timestamp,
    String? eventName,
    String? eventId,
    String? expenseId,
    String? expenseName,
    String? bookingId,
    String? type,
    String? vendorId,
    String? vendorName,
    String? serviceType,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      stripePaymentId: stripePaymentId ?? this.stripePaymentId,
      timestamp: timestamp ?? this.timestamp,
      eventName: eventName ?? this.eventName,
      eventId: eventId ?? this.eventId,
      expenseId: expenseId ?? this.expenseId,
      expenseName: expenseName ?? this.expenseName,
      bookingId: bookingId ?? this.bookingId,
      type: type ?? this.type,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      serviceType: serviceType ?? this.serviceType,
    );
  }

  // ── 🎨 HELPER GETTERS ──────────────────────────────────────────────────────

  /// Check if this is a vendor payment
  bool get isVendorPayment => type == 'vendor' && vendorId != null;

  /// Check if payment was successful
  bool get isSuccessful => status == 'success';

  /// Check if payment is pending
  bool get isPending => status == 'pending';

  /// Check if payment failed
  bool get isFailed => status == 'failed';

  /// Check if payment was refunded
  bool get isRefunded => status == 'refunded';

  /// Get display name for the payment
  String get displayName {
    if (isVendorPayment && vendorName != null) {
      return vendorName!;
    } else if (expenseName != null && expenseName!.isNotEmpty) {
      return expenseName!;
    } else if (eventName.isNotEmpty) {
      return eventName;
    }
    return 'Payment';
  }

  /// Get payment type display string
  String get typeDisplayName {
    switch (type) {
      case 'vendor':
        return 'Vendor Payment';
      case 'expense':
        return 'Expense Payment';
      case 'booking':
        return 'Booking Payment';
      case 'event':
      default:
        return 'Event Payment';
    }
  }

  /// Get formatted amount with rupee symbol
  String get formattedAmount => '₹${amount.toStringAsFixed(0)}';

  /// Get formatted date
  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${timestamp.day} ${months[timestamp.month - 1]}, ${timestamp.year}';
  }

  /// Get formatted time
  String get formattedTime {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')} $period';
  }

  /// Get formatted date and time
  String get formattedDateTime => '$formattedDate at $formattedTime';

  @override
  String toString() => 'Payment(id: $id, amount: $amount, status: $status, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}