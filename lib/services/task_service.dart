// lib/services/task_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _defaultTasksCollection = 'defaultTasks';

  // Get default tasks for an event type (admin created)
  Future<List<DefaultTask>> getDefaultTasksByEventType(String eventTypeId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_defaultTasksCollection)
          .where('eventTypeId', isEqualTo: eventTypeId)
          .where('isActive', isEqualTo: true)
          .orderBy('daysBeforeEvent', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => DefaultTask.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get default tasks error: $e');
      return [];
    }
  }

  // Generate event tasks from default tasks
  Future<List<EventTask>> generateEventTasks(String eventTypeId, DateTime eventDate) async {
    try {
      List<DefaultTask> defaultTasks = await getDefaultTasksByEventType(eventTypeId);

      List<EventTask> eventTasks = [];
      for (var defaultTask in defaultTasks) {
        DateTime deadline = eventDate.subtract(Duration(days: defaultTask.daysBeforeEvent));

        eventTasks.add(EventTask(
          id: '',
          taskName: defaultTask.taskName,
          description: defaultTask.description,
          deadline: deadline,
          priority: defaultTask.priority,
          isCompleted: false,
        ));
      }

      return eventTasks;
    } catch (e) {
      print('Generate event tasks error: $e');
      return [];
    }
  }

  // Get event tasks (user's event specific)
  Future<List<EventTask>> getEventTasks(String eventId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('eventTasks')
          .orderBy('deadline')
          .get();

      return snapshot.docs
          .map((doc) => EventTask.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get event tasks error: $e');
      return [];
    }
  }

  // Add tasks to user event
  Future<bool> addTasksToEvent(String eventId, List<EventTask> tasks) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (var task in tasks) {
        DocumentReference docRef = _firestore
            .collection('userEvents')
            .doc(eventId)
            .collection('eventTasks')
            .doc();

        batch.set(docRef, task.toFirestore());
      }

      await batch.commit();
      return true;
    } catch (e) {
      print('Add tasks to event error: $e');
      return false;
    }
  }

  // Mark task as completed
  Future<bool> markTaskCompleted(String eventId, String taskId, bool isCompleted) async {
    try {
      await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('eventTasks')
          .doc(taskId)
          .update({
        'isCompleted': isCompleted,
        'completedAt': isCompleted ? FieldValue.serverTimestamp() : null,
      });

      return true;
    } catch (e) {
      print('Mark task completed error: $e');
      return false;
    }
  }

  // Stream event tasks
  Stream<List<EventTask>> streamEventTasks(String eventId) {
    return _firestore
        .collection('userEvents')
        .doc(eventId)
        .collection('eventTasks')
        .orderBy('deadline')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => EventTask.fromFirestore(doc))
        .toList());
  }

  // Get task completion percentage
  Future<double> getTaskCompletionPercentage(String eventId) async {
    try {
      List<EventTask> tasks = await getEventTasks(eventId);

      if (tasks.isEmpty) return 0.0;

      int completedCount = tasks.where((t) => t.isCompleted).length;
      return (completedCount / tasks.length) * 100;
    } catch (e) {
      print('Get task completion error: $e');
      return 0.0;
    }
  }

  // Get pending tasks
  Future<List<EventTask>> getPendingTasks(String eventId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('userEvents')
          .doc(eventId)
          .collection('eventTasks')
          .where('isCompleted', isEqualTo: false)
          .orderBy('deadline')
          .get();

      return snapshot.docs
          .map((doc) => EventTask.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Get pending tasks error: $e');
      return [];
    }
  }

  // Get overdue tasks
  Future<List<EventTask>> getOverdueTasks(String eventId) async {
    try {
      List<EventTask> pendingTasks = await getPendingTasks(eventId);
      DateTime now = DateTime.now();

      return pendingTasks.where((task) => task.deadline.isBefore(now)).toList();
    } catch (e) {
      print('Get overdue tasks error: $e');
      return [];
    }
  }
}