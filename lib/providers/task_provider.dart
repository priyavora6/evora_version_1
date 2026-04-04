import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<EventTask> _tasks = [];
  bool _isLoading = false;
  StreamSubscription<QuerySnapshot>? _taskSubscription; // Keep reference to cancel later

  // Getters
  List<EventTask> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // 📊 Calculate Completion % for the Progress Bar
  double get progress {
    if (_tasks.isEmpty) return 0.0;
    int completed = _tasks.where((t) => t.isCompleted).length;
    return completed / _tasks.length;
  }

  // 📡 1. Real-time Listener
  void listenToTasks(String eventId) {
    _isLoading = true;

    // Cancel old subscription if exists
    _taskSubscription?.cancel();

    _taskSubscription = _firestore
        .collection('userEvents')
        .doc(eventId)
        .collection('tasks') // Make sure this matches your DB (tasks vs eventTasks)
        .orderBy('deadline', descending: false)
        .snapshots()
        .listen((snapshot) {

      _tasks = snapshot.docs.map((doc) => EventTask.fromFirestore(doc)).toList();

      // 🔥 AUTO-COMPLETE EXPIRED TASKS
      _checkAutoCompletion(eventId);

      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      print("❌ Error listening to tasks: $e");
      _isLoading = false;
      notifyListeners();
    });
  }

  // 🤖 Helper function to auto-complete expired tasks
  void _checkAutoCompletion(String eventId) {
    final now = DateTime.now();

    for (var task in _tasks) {
      // If task is NOT completed AND deadline has passed
      if (!task.isCompleted && task.deadline.isBefore(now)) {
        print("🤖 Auto-completing expired task: ${task.taskName}");

        // Mark as completed in Firestore
        // We call toggleTask directly since it does exactly what we need
        toggleTask(eventId, task);
      }
    }
  }

  // ✅ 2. Toggle Task Status (Used by UI and Auto-Complete)
  Future<void> toggleTask(String eventId, EventTask task) async {
    try {
      await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('tasks')
          .doc(task.id)
          .update({
        'isCompleted': !task.isCompleted, // Toggles boolean
        'completedAt': !task.isCompleted ? FieldValue.serverTimestamp() : null,
      });
    } catch (e) {
      print("❌ Error toggling task: $e");
    }
  }

  // ➕ 3. Add New Task
  Future<EventTask?> addTask({
    required String eventId,
    required String eventName,
    required String userName,
    required String taskName,
    required DateTime deadline,
  }) async {
    try {
      final docRef = await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('tasks')
          .add({
        'taskName': taskName,
        'deadline': Timestamp.fromDate(deadline),
        'isCompleted': false,
        'eventId': eventId,
        'eventName': eventName,
        'userName': userName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      final doc = await docRef.get();
      print("✅ Task Saved to Firestore successfully!");
      return EventTask.fromFirestore(doc);
    } catch (e) {
      print("❌ Error saving task: $e");
      return null;
    }
  }

  // 🗑️ 4. Delete Task
  Future<void> deleteTask(String eventId, String taskId) async {
    try {
      await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('tasks')
          .doc(taskId)
          .delete();
      print("✅ Task Deleted");
    } catch (e) {
      print("❌ Error deleting task: $e");
    }
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    super.dispose();
  }
}