import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class StatsGridModern extends ConsumerWidget {
  const StatsGridModern({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider);

    return tasksAsync.when(
      data: (tasks) {
        final total = tasks.length;
        final completed = tasks.where((t) => t.status == TaskStatus.done).length;
        final pending = total - completed;

        return Row(
          children: [
            Expanded(child: _StatItem(label: "Total", value: total.toString(), color: Colors.blue)),
            const SizedBox(width: 12),
            Expanded(child: _StatItem(label: "Completed", value: completed.toString(), color: Colors.green)),
            const SizedBox(width: 12),
            Expanded(child: _StatItem(label: "Pending", value: pending.toString(), color: Colors.orange)),
          ],
        );
      },
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class StatsRowLegacy extends ConsumerWidget {
  const StatsRowLegacy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider);

    return tasksAsync.when(
      data: (tasks) {
        final total = tasks.length;
        final completed = tasks.where((t) => t.status == TaskStatus.done).length;
        final pending = total - completed;

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "TOTAL: $total | COMPLETED: $completed | PENDING: $pending",
            style: const TextStyle(fontSize: 10, color: Color(0xFF00FF88)),
          ),
        );
      },
      loading: () => const Text("LOADING STATS...", style: TextStyle(fontSize: 10)),
      error: (_, __) => const Text("ERROR LOADING STATS", style: TextStyle(fontSize: 10)),
    );
  }
}
