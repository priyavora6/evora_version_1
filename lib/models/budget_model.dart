import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  final double totalEstimated;
  final double totalPaid;
  final List<Expense> expenses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Budget({
    this.totalEstimated = 0,
    this.totalPaid = 0,
    this.expenses = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      totalEstimated: (map['totalEstimated'] ?? 0).toDouble(),
      totalPaid: (map['totalPaid'] ?? 0).toDouble(),
      expenses: (map['expenses'] as List<dynamic>?)
          ?.map((e) => Expense.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
      createdAt: _parseTimestamp(map['createdAt']),
      updatedAt: _parseTimestamp(map['updatedAt']),
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'totalEstimated': totalEstimated,
      'totalPaid': totalPaid,
      'expenses': expenses.map((e) => e.toMap()).toList(),
    };
  }
}

class Expense {
  final String id;
  final String name;
  final double amount;
  final String category;
  final bool isPaid;
  final DateTime? createdAt;
  final DateTime? paidDate;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    this.category = 'Other',
    this.isPaid = false,
    this.createdAt,
    this.paidDate,
  });

  // Getter for backward compatibility
  String get itemName => name;

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      name: map['name'] ?? map['itemName'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      category: map['category'] ?? 'Other',
      isPaid: map['isPaid'] ?? false,
      createdAt: _parseTimestamp(map['createdAt']),
      paidDate: _parseTimestamp(map['paidDate']),
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  // ✅ FIXED: Use Timestamp.now() instead of FieldValue.serverTimestamp()
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category,
      'isPaid': isPaid,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : Timestamp.now(),  // ✅ Use Timestamp.now() NOT FieldValue.serverTimestamp()
      'paidDate': paidDate != null
          ? Timestamp.fromDate(paidDate!)
          : null,
    };
  }

  Expense copyWith({
    String? id,
    String? name,
    double? amount,
    String? category,
    bool? isPaid,
    DateTime? createdAt,
    DateTime? paidDate,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
      paidDate: paidDate ?? this.paidDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}