import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class CustomSearchBar extends ConsumerWidget {
  final bool isPixelMode;
  const CustomSearchBar({super.key, required this.isPixelMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
      decoration: InputDecoration(
        hintText: isPixelMode ? "> Search Tasks..." : "Search tasks by title",
        prefixIcon: Icon(Icons.search, color: isPixelMode ? const Color(0xFF00FF88) : Colors.grey),
        filled: true,
        fillColor: isPixelMode ? Colors.black : const Color(0xFF1E1E1E),
        border: isPixelMode 
            ? const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF88), width: 2))
            : OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}

class StatusFilterRow extends ConsumerWidget {
  const StatusFilterRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(statusFilterProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FilterChip(label: "All", isSelected: selectedStatus == null, onSelected: () => ref.read(statusFilterProvider.notifier).state = null),
        _FilterChip(label: "Todo", isSelected: selectedStatus == TaskStatus.todo, onSelected: () => ref.read(statusFilterProvider.notifier).state = TaskStatus.todo),
        _FilterChip(label: "Active", isSelected: selectedStatus == TaskStatus.inProgress, onSelected: () => ref.read(statusFilterProvider.notifier).state = TaskStatus.inProgress),
        _FilterChip(label: "Done", isSelected: selectedStatus == TaskStatus.done, onSelected: () => ref.read(statusFilterProvider.notifier).state = TaskStatus.done),
      ],
    );
  }
}

class _FilterChip extends ConsumerWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({required this.label, required this.isSelected, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPixelMode = ref.watch(isPixelModeProvider);

    return InkWell(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? (isPixelMode ? const Color(0xFF00FF88) : Colors.orange) : Colors.transparent,
          border: isPixelMode ? Border.all(color: const Color(0xFF00FF88)) : null,
          borderRadius: isPixelMode ? null : BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : (isPixelMode ? const Color(0xFF00FF88) : Colors.grey),
            fontSize: isPixelMode ? 10 : 12,
          ),
        ),
      ),
    );
  }
}
