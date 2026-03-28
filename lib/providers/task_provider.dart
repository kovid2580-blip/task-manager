import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../services/local_db_service.dart';

final dbServiceProvider = Provider((ref) => LocalDbService());

final taskListProvider = AsyncNotifierProvider<TaskListNotifier, List<Task>>(TaskListNotifier.new);

class TaskListNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    final db = ref.read(dbServiceProvider);
    await db.init();
    return db.getAllTasks();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskStatus status,
    String? blockedBy,
  }) async {
    state = const AsyncLoading();
    
    // Simulated network delay
    await Future.delayed(const Duration(seconds: 2));
    
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      status: status,
      blockedBy: blockedBy,
    );

    final db = ref.read(dbServiceProvider);
    await db.saveTask(newTask);
    
    state = AsyncData([...state.value ?? [], newTask]);
  }

  Future<void> updateTask(Task updatedTask) async {
    state = const AsyncLoading();
    
    // Simulated network delay
    await Future.delayed(const Duration(seconds: 2));

    final db = ref.read(dbServiceProvider);
    await db.saveTask(updatedTask);
    
    final tasks = state.value ?? [];
    state = AsyncData([
      for (final task in tasks)
        if (task.id == updatedTask.id) updatedTask else task
    ]);
  }

  Future<void> deleteTask(String id) async {
    final db = ref.read(dbServiceProvider);
    await db.deleteTask(id);
    
    final tasks = state.value ?? [];
    state = AsyncData(tasks.where((t) => t.id != id).toList());
  }
}

// Search and Filter Providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final statusFilterProvider = StateProvider<TaskStatus?>((ref) => null);

final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final filter = ref.watch(statusFilterProvider);

  return tasksAsync.when(
    data: (tasks) {
      return tasks.where((task) {
        final matchesQuery = task.title.toLowerCase().contains(query);
        final matchesFilter = filter == null || task.status == filter;
        return matchesQuery && matchesFilter;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Draft Logic
class DraftState {
  final String title;
  final String description;
  final DateTime? dueDate;
  final TaskStatus status;
  final String? blockedBy;

  DraftState({
    this.title = '',
    this.description = '',
    this.dueDate,
    this.status = TaskStatus.todo,
    this.blockedBy,
  });

  DraftState copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    String? blockedBy,
  }) {
    return DraftState(
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      blockedBy: blockedBy ?? this.blockedBy,
    );
  }
}

final draftProvider = StateProvider<DraftState>((ref) => DraftState());

// Theme Provider
final isPixelModeProvider = StateProvider<bool>((ref) => false);
