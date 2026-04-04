// lib/models/task_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

// This is for DEFAULT TASKS (admin managed)
class DefaultTask {
  final String id;
  final String eventTypeId;
  final String taskName;
  final String description;
  final int daysBeforeEvent;      // How many days before event to do this
  final String priority;          // high, medium, low
  final int order;
  final bool isActive;
  final DateTime? createdAt;

  DefaultTask({
    required this.id,
    required this.eventTypeId,
    required this.taskName,
    required this.description,
    required this.daysBeforeEvent,
    this.priority = 'medium',
    this.order = 0,
    this.isActive = true,
    this.createdAt,
  });

  factory DefaultTask.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DefaultTask(
      id: doc.id,
      eventTypeId: data['eventTypeId'] ?? '',
      taskName: data['taskName'] ?? '',
      description: data['description'] ?? '',
      daysBeforeEvent: data['daysBeforeEvent'] ?? 0,
      priority: data['priority'] ?? 'medium',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'eventTypeId': eventTypeId,
      'taskName': taskName,
      'description': description,
      'daysBeforeEvent': daysBeforeEvent,
      'priority': priority,
      'order': order,
      'isActive': isActive,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

// This is for USER'S EVENT TASKS (generated from default tasks)
class EventTask {
  final String id;
  final String taskName;
  final String description;
  final DateTime deadline;
  final String priority;
  final bool isCompleted;
  final DateTime? completedAt;

  EventTask({
    required this.id,
    required this.taskName,
    required this.description,
    required this.deadline,
    this.priority = 'medium',
    this.isCompleted = false,
    this.completedAt,
  });

  factory EventTask.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EventTask(
      id: doc.id,
      taskName: data['taskName'] ?? '',
      description: data['description'] ?? '',
      deadline: (data['deadline'] as Timestamp).toDate(),
      priority: data['priority'] ?? 'medium',
      isCompleted: data['isCompleted'] ?? false,
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'taskName': taskName,
      'description': description,
      'deadline': Timestamp.fromDate(deadline),
      'priority': priority,
      'isCompleted': isCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  EventTask copyWith({
    String? id,
    String? taskName,
    String? description,
    DateTime? deadline,
    String? priority,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return EventTask(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}