import 'package:flutter/material.dart';
import '../my_events/tabs/tasks_tab.dart';

class TasksScreen extends StatelessWidget {
  final String eventId;
  const TasksScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Planner Diary'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: TasksTab(eventId: eventId), // Reuses the tab logic
    );
  }
}