import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/task_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_event_provider.dart';
import '../../../models/task_model.dart';
import '../../../services/notification_service.dart';
import '../../../config/app_colors.dart';

class TasksTab extends StatefulWidget {
  final String eventId;
  const TasksTab({super.key, required this.eventId});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTasks();
    });
  }

  Future<void> _initializeTasks() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.listenToTasks(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildProgressCard(provider.progress)),
              if (provider.tasks.isEmpty)
                const SliverFillRemaining(child: Center(child: Text("No tasks found. Add a task to get started!")))
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildTaskTile(provider.tasks[index], provider),
                      childCount: provider.tasks.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddTaskSheet(context),
      ),
    );
  }

  Widget _buildTaskTile(EventTask task, TaskProvider provider) {
    final bool isCompleted = task.isCompleted;
    final bool isOverdue = !isCompleted && task.deadline.isBefore(DateTime.now());

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isCompleted ? 0.4 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isOverdue ? Colors.red.withOpacity(0.2) : Colors.grey.shade100),
        ),
        child: ListTile(
          onTap: () => provider.toggleTask(widget.eventId, task),
          leading: Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: isCompleted ? Colors.green : (isOverdue ? Colors.red : Colors.grey),
          ),
          title: Text(
            task.taskName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            "${isOverdue ? 'Overdue: ' : 'Due: '}${DateFormat('dd MMM, hh:mm a').format(task.deadline)}",
            style: TextStyle(fontSize: 12, color: isOverdue ? Colors.red : Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
            onPressed: () => provider.deleteTask(widget.eventId, task.id),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(double progress) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Planning Progress", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            color: Colors.greenAccent,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 8),
          Text("${(progress * 100).toInt()}% Tasks Completed", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Add New Task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  hintText: "What needs to be done?",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(DateFormat('dd MMM').format(selectedDate)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) setModalState(() => selectedDate = picked);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time, size: 18),
                      label: Text(selectedTime.format(context)),
                      onPressed: () async {
                        final picked = await showTimePicker(context: context, initialTime: selectedTime);
                        if (picked != null) setModalState(() => selectedTime = picked);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () async {
                    if (titleCtrl.text.isEmpty) return;

                    final auth = Provider.of<AuthProvider>(context, listen: false);

                    final finalDeadline = DateTime(
                      selectedDate.year, selectedDate.month, selectedDate.day,
                      selectedTime.hour, selectedTime.minute,
                    );

                    final task = await Provider.of<TaskProvider>(context, listen: false).addTask(
                      eventId: widget.eventId,
                      eventName: "Event Task",
                      userName: auth.user!.name,
                      taskName: titleCtrl.text,
                      deadline: finalDeadline,
                    );

                    if (task != null) {
                      await NotificationService().scheduleTaskReminders(
                        userId: auth.user!.id,
                        taskId: task.id,
                        taskName: task.taskName,
                        deadline: task.deadline,
                      );
                    }

                    Navigator.pop(context);
                  },
                  child: const Text("Create Task & Set Reminders", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}