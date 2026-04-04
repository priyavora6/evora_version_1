import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Added to get userId
import '../models/budget_model.dart';
import '../models/cart_item_model.dart';
import '../services/budget_service.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetService _service = BudgetService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Budget? _budget;
  Map<String, double> _breakdown = {};
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = false;
  String? _error;

  StreamSubscription<QuerySnapshot>? _bookingsSubscription;
  StreamSubscription<DocumentSnapshot>? _budgetSubscription;

  // Getters
  Budget? get budget => _budget;
  Map<String, double> get breakdown => _breakdown;
  List<Map<String, dynamic>> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalEstimated => _budget?.totalEstimated ?? 0.0;

  // Total Cost of all Manual Expenses
  double get totalExpenses {
    if (_budget == null || _budget!.expenses.isEmpty) return 0.0;
    return _budget!.expenses.fold<double>(0.0, (sum, e) => sum + e.amount);
  }

  // Total Paid Amount (Manual Expenses Only + Bookings Only)
  double get totalPaid {
    double manualPaid = 0.0;

    // 1. Manual Expenses Paid
    if (_budget != null && _budget!.expenses.isNotEmpty) {
      manualPaid = _budget!.expenses
          .where((e) => e.isPaid)
          .fold<double>(0.0, (sum, e) => sum + e.amount);
    }

    // 2. Bookings Paid
    double bookingsPaid = _bookings
        .where((b) => b['status'] == 'paid')
        .fold<double>(0.0, (sum, b) {
      final price = b['totalPrice'];
      if (price == null) return sum;
      if (price is num) return sum + price.toDouble();
      return sum;
    });

    return manualPaid + bookingsPaid;
  }

  double get remainingAmount => totalEstimated - totalExpenses;

  // ═══════════════════════════════════════════════════════════════════════
  // 🔄 LISTENERS
  // ═══════════════════════════════════════════════════════════════════════

  void startBudgetListener(String eventId) {
    _budgetSubscription?.cancel();

    _budgetSubscription = _firestore
        .collection('userEvents')
        .doc(eventId)
        .collection('budget')
        .doc('main')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        _budget = Budget.fromMap(snapshot.data()!);
        notifyListeners();
      }
    }, onError: (e) {
      print("Budget Listener Error: $e");
    });
  }

  void startBookingsListener(String eventId) {
    _bookingsSubscription?.cancel();

    _bookingsSubscription = _firestore
        .collection('userEvents')
        .doc(eventId)
        .collection('bookings')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _bookings = snapshot.docs.map((doc) {
        final data = doc.data();
        data['docId'] = doc.id;
        return data;
      }).toList();
      notifyListeners();
    }, onError: (e) {
      print("Booking Listener Error: $e");
    });
  }

  @override
  void dispose() {
    _bookingsSubscription?.cancel();
    _budgetSubscription?.cancel();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📊 FETCH BUDGET
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> fetchEventBudget(String eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // ✅ 1. Get User ID to satisfy Firestore Rules
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // 🛠️ AUTO-FIX: Recalculate total before showing data
        // Pass userId so the query doesn't fail permission checks
        await _service.recalculateAndFixTotalPaid(eventId, userId);
      }

      await _service.initializeBudget(eventId);
      _budget = await _service.getEventBudget(eventId);
      _breakdown = await _service.getExpenseBreakdown(eventId);

      startBudgetListener(eventId);
      startBookingsListener(eventId);
    } catch (e) {
      _error = e.toString();
      print("Fetch Budget Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 💾 BUDGET OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════

  Future<bool> saveBudget({
    required String eventId,
    required double totalEstimated,
  }) async {
    try {
      return await _service.saveEventBudget(
        eventId: eventId,
        totalEstimated: totalEstimated,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ➕ ADD EXPENSE
  // ═══════════════════════════════════════════════════════════════════════

  Future<bool> addExpense(String eventId, Expense expense) async {
    try {
      return await _service.addExpense(eventId, expense);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ✅ TOGGLE EXPENSE PAID STATUS
  // ═══════════════════════════════════════════════════════════════════════

  Future<bool> toggleExpensePaid(String eventId, Expense expense) async {
    try {
      final updatedExpense = expense.copyWith(
        isPaid: !expense.isPaid,
        paidDate: !expense.isPaid ? DateTime.now() : null,
      );
      return await _service.updateExpense(eventId, expense, updatedExpense);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 💳 MARK EXPENSE AS PAID BY ID (When returning from payment screen)
  // ═══════════════════════════════════════════════════════════════════════

  Future<bool> markExpenseAsPaidById(String eventId, String expenseId) async {
    try {
      // 1. Ensure budget and expenses exist
      if (_budget == null || _budget!.expenses.isEmpty) {
        _error = 'No expenses found';
        return false;
      }

      // 2. Find the expense safely
      Expense? expense;
      try {
        expense = _budget!.expenses.firstWhere((e) => e.id == expenseId);
      } catch (e) {
        expense = null;
      }

      // 3. Check if we found it before calling copyWith
      if (expense == null) {
        _error = 'Expense not found';
        return false;
      }

      // 4. Safely update since expense is proven not null
      final updatedExpense = expense.copyWith(
        isPaid: true,
        paidDate: DateTime.now(),
      );

      return await _service.updateExpense(eventId, expense, updatedExpense);
    } catch (e) {
      _error = e.toString();
      print("Error marking expense as paid by ID: $e");
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🗑️ DELETE EXPENSE
  // ═══════════════════════════════════════════════════════════════════════

  Future<bool> deleteExpense(String eventId, Expense expense) async {
    try {
      return await _service.deleteExpense(eventId, expense);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🛒 BOOKING OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════

  Future<bool> createBookingRequest(
      String eventId,
      List<CartItem> cartItems,
      double totalAmount,
      ) async {
    try {
      final docRef = _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('bookings')
          .doc();

      await docRef.set({
        'id': docRef.id,
        'items': cartItems.map((e) => e.toMap()).toList(),
        'totalPrice': totalAmount,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> markBookingAsPaid(String eventId, String bookingId) async {
    try {
      await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': 'paid',
        'paidAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error marking booking as paid: $e");
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> adminApproveBooking(String eventId, String bookingId) async {
    try {
      await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error approving booking: $e");
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelBooking(String eventId, String bookingId) async {
    try {
      await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('bookings')
          .doc(bookingId)
          .update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error cancelling booking: $e");
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 💰 UPDATE AMOUNT PAID
  // ═══════════════════════════════════════════════════════════════════════

  Future<bool> updateAmountPaid(String eventId, double amount) async {
    try {
      await _firestore.collection('userEvents').doc(eventId).update({
        'amountPaid': FieldValue.increment(amount),
        'lastPaymentAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error updating amount paid: $e");
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🧹 CLEAR DATA
  // ═══════════════════════════════════════════════════════════════════════

  void clearData() {
    _bookingsSubscription?.cancel();
    _budgetSubscription?.cancel();
    _budget = null;
    _bookings = [];
    _breakdown = {};
    _error = null;
    notifyListeners();
  }
}