import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class LocalDbService {
  static const String _tasksBoxName = 'tasks_box';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskStatusAdapter());
    await Hive.openBox<Task>(_tasksBoxName);
  }

  Box<Task> get _tasksBox => Hive.box<Task>(_tasksBoxName);

  List<Task> getAllTasks() {
    return _tasksBox.values.toList();
  }

  Future<void> saveTask(Task task) async {
    await _tasksBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _tasksBox.delete(id);
  }

  Future<void> clearAll() async {
    await _tasksBox.clear();
  }
}
