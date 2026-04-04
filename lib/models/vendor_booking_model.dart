import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus {
  pending,
  assigned,
  approved,
  rejected,
  confirmed,
  completed,
  cancelled,
}

enum PaymentStatus {
  unpaid,
  partial,
  paid,
  refunded,
}

class VendorBookingModel {
  final String id;
  final String vendorId;
  final String vendorName;
  final String? vendorPhone;
  final String? vendorCategory;
  final String serviceType;
  final String userId;
  final String userName;
  final String userPhone;
  final String userEmail;
  final String eventId;
  final String eventName;
  final DateTime? eventDate;
  final String eventTime;      // ✅ ADDED THIS (e.g., "10:00 AM")
  final String eventVenue;     // ✅ UPDATED logic to catch "venue" or "location"
  final String message;
  final BookingStatus status;
  final String adminNote;
  final String? rejectionReason;
  final double vendorPrice;
  final double paidAmount;
  final PaymentStatus paymentStatus;
  final String? paymentMethod;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime? assignmentDeadline;
  final String? assignmentSource;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final DateTime? confirmedAt;
  final DateTime? completedAt;
  final DateTime? paidAt;
  final DateTime? updatedAt;

  VendorBookingModel({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    this.vendorPhone,
    this.vendorCategory,
    required this.serviceType,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.eventId,
    required this.eventName,
    this.eventDate,
    required this.eventTime,    // ✅ Added
    required this.eventVenue,   // ✅ Ensure this is passed
    required this.message,
    required this.status,
    this.adminNote = '',
    this.rejectionReason,
    this.vendorPrice = 0.0,
    this.paidAmount = 0.0,
    this.paymentStatus = PaymentStatus.unpaid,
    this.paymentMethod,
    this.transactionId,
    required this.createdAt,
    this.assignmentDeadline,
    this.assignmentSource,
    this.approvedAt,
    this.rejectedAt,
    this.confirmedAt,
    this.completedAt,
    this.paidAt,
    this.updatedAt,
  });

  // Helper getters
  bool get isPending => status == BookingStatus.pending;
  bool get isAssigned => status == BookingStatus.assigned;
  bool get isApproved => status == BookingStatus.approved;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCompleted => status == BookingStatus.completed;

  factory VendorBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return VendorBookingModel(
      id: doc.id,
      vendorId: data['vendorId'] ?? '',
      vendorName: data['vendorName'] ?? data['businessName'] ?? '',
      vendorPhone: data['vendorPhone'] ?? data['businessPhone'],
      vendorCategory: data['vendorCategory'] ?? data['category'],
      serviceType: data['serviceType'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      userEmail: data['userEmail'] ?? '',
      eventId: data['eventId'] ?? '',
      eventName: data['eventName'] ?? '',

      // ✅ LOGIC: Capture Time from DB
      eventTime: data['eventTime'] ?? 'TBA',

      // ✅ LOGIC: Robust Address Capture (Checks all possible keys from your logs)
      eventVenue: data['venue'] ?? data['location'] ?? data['eventVenue'] ?? 'Address TBA',

      eventDate: (data['eventDate'] as Timestamp?)?.toDate(),
      message: data['message'] ?? data['description'] ?? '',
      adminNote: data['adminNote'] ?? '',
      rejectionReason: data['rejectionReason'],
      status: _parseBookingStatus(data['status']),

      // Handle Price keys
      vendorPrice: (data['vendorPrice'] ?? data['price'] ?? 0).toDouble(),
      paidAmount: (data['amountPaid'] ?? data['paidAmount'] ?? 0).toDouble(),

      paymentStatus: _parsePaymentStatus(data['paymentStatus']),
      paymentMethod: data['paymentMethod'],
      transactionId: data['transactionId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      assignmentDeadline: (data['assignmentDeadline'] as Timestamp?)?.toDate(),
      assignmentSource: data['assignmentSource'],
      approvedAt: (data['approvedAt'] as Timestamp?)?.toDate(),
      rejectedAt: (data['rejectedAt'] as Timestamp?)?.toDate(),
      confirmedAt: (data['confirmedAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      paidAt: (data['paidAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  static BookingStatus _parseBookingStatus(String? status) {
    if (status == null) return BookingStatus.pending;
    try {
      return BookingStatus.values.firstWhere(
            (e) => e.name.toLowerCase() == status.toLowerCase(),
      );
    } catch (_) {
      return BookingStatus.assigned; // Default if string doesn't match enum exactly
    }
  }

  static PaymentStatus _parsePaymentStatus(String? status) {
    if (status == null) return PaymentStatus.unpaid;
    try {
      return PaymentStatus.values.firstWhere(
            (e) => e.name.toLowerCase() == status.toLowerCase(),
      );
    } catch (_) {
      return PaymentStatus.unpaid;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'vendorId': vendorId,
      'vendorName': vendorName,
      'vendorPhone': vendorPhone,
      'vendorCategory': vendorCategory,
      'serviceType': serviceType,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'eventId': eventId,
      'eventName': eventName,
      'eventTime': eventTime,
      'venue': eventVenue, // Save back as 'venue'
      'eventDate': eventDate != null ? Timestamp.fromDate(eventDate!) : null,
      'status': status.name,
      'vendorPrice': vendorPrice,
      'paymentStatus': paymentStatus.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'assignmentDeadline': assignmentDeadline != null ? Timestamp.fromDate(assignmentDeadline!) : null,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}