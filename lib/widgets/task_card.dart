import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../screens/task_form_screen.dart';
import 'package:intl/intl.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
  final bool isPixelMode;

  const TaskCard({super.key, required this.task, required this.isPixelMode});

  @override
  Widget build(BuildContext context) {
    final bool isBlocked = task.blockedBy != null; 
    // In a real app, we'd check if the blocking task is actually Done.
    // For this simple UI component, we'll assume it's visually blocked if it has a blockedBy.

    if (isPixelMode) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: isBlocked ? Colors.grey : const Color(0xFF00FF88), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${isBlocked ? "[BLOCKED] " : ""}${task.title}",
              style: TextStyle(
                color: isBlocked ? Colors.grey : const Color(0xFF00FF88),
                fontSize: 14,
                decoration: task.status == TaskStatus.done ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "STATUS: ${_getStatusSymbol(task.status)} ${task.status.name.toUpperCase()}",
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      "DUE: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                  onPressed: () => ref.read(taskListProvider.notifier).deleteTask(task.id),
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.edit, size: 16, color: Color(0xFF00FF88)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Opacity(
        opacity: isBlocked ? 0.5 : 1.0,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 4,
            decoration: BoxDecoration(
              color: _getStatusColor(task.status),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: task.status == TaskStatus.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(DateFormat('MMM dd, yyyy').format(task.dueDate), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                onPressed: () => ref.read(taskListProvider.notifier).deleteTask(task.id),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
                ),
              ),
              if (isBlocked) const Icon(Icons.lock, color: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo: return Colors.grey;
      case TaskStatus.inProgress: return Colors.orange;
      case TaskStatus.done: return Colors.green;
    }
  }

  String _getStatusSymbol(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo: return "[ ]";
      case TaskStatus.inProgress: return "[~]";
      case TaskStatus.done: return "[✓]";
    }
  }
}
