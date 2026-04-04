// lib/models/user_event_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item_model.dart';

enum EventStatus {
  pending,
  confirmed,
  approved,
  rejected,
  inProgress,
  completed,
  cancelled
}

enum PaymentStatus {
  unpaid,
  partial,
  paid,
  overdue,
  refunded
}

class AssignedVendor {
  final String vendorId;
  final String vendorName;
  final String serviceType;
  final double price;
  final String status;
  final double paidAmount;
  final DateTime assignedAt;
  final DateTime? confirmedAt;

  AssignedVendor({
    required this.vendorId,
    required this.vendorName,
    required this.serviceType,
    required this.price,
    this.status = 'assigned',
    this.paidAmount = 0.0,
    required this.assignedAt,
    this.confirmedAt,
  });

  factory AssignedVendor.fromMap(Map<String, dynamic> data) {
    return AssignedVendor(
      vendorId: data['vendorId'] ?? '',
      vendorName: data['vendorName'] ?? '',
      serviceType: data['serviceType'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'assigned',
      paidAmount: (data['paidAmount'] ?? 0.0).toDouble(),
      assignedAt: (data['assignedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      confirmedAt: (data['confirmedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'vendorName': vendorName,
      'serviceType': serviceType,
      'price': price,
      'status': status,
      'paidAmount': paidAmount,
      'assignedAt': Timestamp.fromDate(assignedAt),
      'confirmedAt': confirmedAt != null ? Timestamp.fromDate(confirmedAt!) : null,
    };
  }
}

class UserEvent {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String userEmail;
  final String eventTypeId;
  final String eventTypeName;
  final String eventName;
  final String description;
  final DateTime eventDate;
  final String eventTime;
  final String location;
  final String venue;
  final String city;
  final int guestCount;
  final int checkedInCount;
  final String eventPassCode;
  final EventStatus status;
  final String adminNote;
  final String? rejectionReason;
  final List<AssignedVendor> assignedVendors;
  final List<CartItem> selectedItems;
  final double estimatedBudget;
  final double totalEstimatedCost;
  final double totalVendorCost;
  final double amountPaid;
  final PaymentStatus paymentStatus;
  final DateTime? paymentDeadline;
  final String? paymentMethod;
  final List<String>? transactionIds;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime? updatedAt;

  UserEvent({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.eventTypeId,
    required this.eventTypeName,
    required this.eventName,
    this.description = '',
    required this.eventDate,
    required this.eventTime,
    required this.location,
    this.venue = '',
    this.city = '',
    this.guestCount = 0,
    this.checkedInCount = 0,
    this.eventPassCode = '',
    this.status = EventStatus.pending,
    this.adminNote = '',
    this.rejectionReason,
    this.assignedVendors = const [],
    this.selectedItems = const [],
    this.estimatedBudget = 0.0,
    required this.totalEstimatedCost,
    this.totalVendorCost = 0.0,
    this.amountPaid = 0.0,
    this.paymentStatus = PaymentStatus.unpaid,
    this.paymentDeadline,
    this.paymentMethod,
    this.transactionIds,
    required this.createdAt,
    this.approvedAt,
    this.completedAt,
    this.cancelledAt,
    this.updatedAt,
  });

  // Helper getters
  bool get isCompleted => status == EventStatus.completed;
  bool get isFullyPaid => paymentStatus == PaymentStatus.paid;

  factory UserEvent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserEvent(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      userEmail: data['userEmail'] ?? '',
      eventTypeId: data['eventTypeId'] ?? '',
      eventTypeName: data['eventTypeName'] ?? '',
      eventName: data['eventName'] ?? '',
      description: data['description'] ?? '',
      eventDate: (data['eventDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      eventTime: data['eventTime'] ?? '',
      location: data['location'] ?? '',
      venue: data['venue'] ?? '',
      city: data['city'] ?? '',
      guestCount: data['guestCount'] ?? 0,
      checkedInCount: data['checkedInCount'] ?? 0,
      eventPassCode: data['eventPassCode'] ?? '',
      status: _parseEventStatus(data['status']),
      adminNote: data['adminNote'] ?? '',
      rejectionReason: data['rejectionReason'],
      assignedVendors: (data['assignedVendors'] as List<dynamic>?)
          ?.map((item) => AssignedVendor.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      selectedItems: (data['selectedItems'] as List<dynamic>?)
          ?.map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      estimatedBudget: (data['estimatedBudget'] ?? 0.0).toDouble(),
      totalEstimatedCost: (data['totalEstimatedCost'] ?? 0.0).toDouble(),
      totalVendorCost: (data['totalVendorCost'] ?? 0.0).toDouble(),
      amountPaid: (data['amountPaid'] ?? 0.0).toDouble(),
      paymentStatus: _parsePaymentStatus(data['paymentStatus']),
      paymentDeadline: (data['paymentDeadline'] as Timestamp?)?.toDate(),
      paymentMethod: data['paymentMethod'],
      transactionIds: data['transactionIds'] != null ? List<String>.from(data['transactionIds']) : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      approvedAt: (data['approvedAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      cancelledAt: (data['cancelledAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  static EventStatus _parseEventStatus(String? status) {
    return EventStatus.values.firstWhere((e) => e.name == status, orElse: () => EventStatus.pending);
  }

  static PaymentStatus _parsePaymentStatus(String? status) {
    return PaymentStatus.values.firstWhere((e) => e.name == status, orElse: () => PaymentStatus.unpaid);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'eventTypeId': eventTypeId,
      'eventTypeName': eventTypeName,
      'eventName': eventName,
      'description': description,
      'eventDate': Timestamp.fromDate(eventDate),
      'eventTime': eventTime,
      'location': location,
      'venue': venue,
      'city': city,
      'guestCount': guestCount,
      'checkedInCount': checkedInCount,
      'eventPassCode': eventPassCode,
      'status': status.name,
      'adminNote': adminNote,
      'rejectionReason': rejectionReason,
      'assignedVendors': assignedVendors.map((v) => v.toMap()).toList(),
      'selectedItems': selectedItems.map((item) => item.toMap()).toList(),
      'estimatedBudget': estimatedBudget,
      'totalEstimatedCost': totalEstimatedCost,
      'totalVendorCost': totalVendorCost,
      'amountPaid': amountPaid,
      'paymentStatus': paymentStatus.name,
      'paymentDeadline': paymentDeadline != null ? Timestamp.fromDate(paymentDeadline!) : null,
      'paymentMethod': paymentMethod,
      'transactionIds': transactionIds,
      'createdAt': Timestamp.fromDate(createdAt), // ✅ FIXED: DateTime to Timestamp
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null, // ✅ FIXED
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null, // ✅ FIXED
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null, // ✅ FIXED
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'eventTypeId': eventTypeId,
      'eventTypeName': eventTypeName,
      'eventName': eventName,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'eventTime': eventTime,
      'location': location,
      'venue': venue,
      'city': city,
      'guestCount': guestCount,
      'checkedInCount': checkedInCount,
      'eventPassCode': eventPassCode,
      'status': status.name,
      'adminNote': adminNote,
      'rejectionReason': rejectionReason,
      'assignedVendors': assignedVendors.map((v) => v.toMap()).toList(),
      'selectedItems': selectedItems.map((v) => v.toMap()).toList(),
      'estimatedBudget': estimatedBudget,
      'totalEstimatedCost': totalEstimatedCost,
      'totalVendorCost': totalVendorCost,
      'amountPaid': amountPaid,
      'paymentStatus': paymentStatus.name,
      'paymentDeadline': paymentDeadline?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'transactionIds': transactionIds,
      'createdAt': createdAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  UserEvent copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhone,
    String? userEmail,
    String? eventTypeId,
    String? eventTypeName,
    String? eventName,
    String? description,
    DateTime? eventDate,
    String? eventTime,
    String? location,
    String? venue,
    String? city,
    int? guestCount,
    int? checkedInCount,
    String? eventPassCode,
    EventStatus? status,
    String? adminNote,
    String? rejectionReason,
    List<AssignedVendor>? assignedVendors,
    List<CartItem>? selectedItems,
    double? estimatedBudget,
    double? totalEstimatedCost,
    double? totalVendorCost,
    double? amountPaid,
    PaymentStatus? paymentStatus,
    DateTime? paymentDeadline,
    String? paymentMethod,
    List<String>? transactionIds,
    DateTime? createdAt,
    DateTime? approvedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? updatedAt,
  }) {
    return UserEvent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      userEmail: userEmail ?? this.userEmail,
      eventTypeId: eventTypeId ?? this.eventTypeId,
      eventTypeName: eventTypeName ?? this.eventTypeName,
      eventName: eventName ?? this.eventName,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      location: location ?? this.location,
      venue: venue ?? this.venue,
      city: city ?? this.city,
      guestCount: guestCount ?? this.guestCount,
      checkedInCount: checkedInCount ?? this.checkedInCount,
      eventPassCode: eventPassCode ?? this.eventPassCode,
      status: status ?? this.status,
      adminNote: adminNote ?? this.adminNote,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      assignedVendors: assignedVendors ?? this.assignedVendors,
      selectedItems: selectedItems ?? this.selectedItems,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      totalEstimatedCost: totalEstimatedCost ?? this.totalEstimatedCost,
      totalVendorCost: totalVendorCost ?? this.totalVendorCost,
      amountPaid: amountPaid ?? this.amountPaid,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentDeadline: paymentDeadline ?? this.paymentDeadline,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionIds: transactionIds ?? this.transactionIds,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserEvent(id: $id, name: $eventName, status: ${status.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}