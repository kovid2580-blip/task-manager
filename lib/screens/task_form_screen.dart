import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> with WidgetsBindingObserver {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    if (widget.task != null) {
      _titleController = TextEditingController(text: widget.task!.title);
      _descController = TextEditingController(text: widget.task!.description);
      // Initialize draft with existing task data
      Future.microtask(() {
        ref.read(draftProvider.notifier).state = DraftState(
          title: widget.task!.title,
          description: widget.task!.description,
          dueDate: widget.task!.dueDate,
          status: widget.task!.status,
          blockedBy: widget.task!.blockedBy,
        );
      });
    } else {
      final draft = ref.read(draftProvider);
      _titleController = TextEditingController(text: draft.title);
      _descController = TextEditingController(text: draft.description);
    }
  }

  @override
  void dispose() {
    _saveDraft();
    WidgetsBinding.instance.removeObserver(this);
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveDraft();
    }
  }

  void _saveDraft() {
    ref.read(draftProvider.notifier).update((state) => state.copyWith(
      title: _titleController.text,
      description: _descController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isPixelMode = ref.watch(isPixelModeProvider);
    final draft = ref.watch(draftProvider);
    final tasks = ref.watch(taskListProvider).value ?? [];
    final isLoading = ref.watch(taskListProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPixelMode 
          ? (widget.task == null ? "CMD: ADD_TASK" : "CMD: EDIT_TASK") 
          : (widget.task == null ? "Add Task" : "Edit Task")),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isPixelMode ? const Color(0xFF00FF88) : Colors.white),
          onPressed: () {
            _saveDraft();
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading 
        ? _buildLoadingOverlay(isPixelMode)
        : Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                _buildFieldLabel("TITLE", isPixelMode),
                _buildTextField(_titleController, isPixelMode),
                const SizedBox(height: 20),
                _buildFieldLabel("DESCRIPTION", isPixelMode),
                _buildTextField(_descController, isPixelMode, maxLines: 3),
                const SizedBox(height: 20),
                _buildFieldLabel("DUE DATE", isPixelMode),
                _buildDatePicker(context, draft, isPixelMode),
                const SizedBox(height: 20),
                _buildFieldLabel("STATUS", isPixelMode),
                _buildStatusDropdown(draft, isPixelMode),
                const SizedBox(height: 20),
                _buildFieldLabel("BLOCKED BY", isPixelMode),
                _buildBlockedByDropdown(draft, tasks, isPixelMode),
                const SizedBox(height: 40),
                _buildSaveButton(isLoading, isPixelMode),
              ],
            ),
          ),
    );
  }

  Widget _buildFieldLabel(String text, bool isPixelMode) {
    return Text(
      isPixelMode ? "> $text" : text,
      style: TextStyle(
        fontSize: isPixelMode ? 10 : 14,
        fontWeight: isPixelMode ? FontWeight.bold : FontWeight.normal,
        color: isPixelMode ? const Color(0xFF00FF88) : Colors.grey,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool isPixelMode, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: isPixelMode ? const Color(0xFFFFCC00) : Colors.white),
      decoration: InputDecoration(
        border: isPixelMode ? const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF88))) : const UnderlineInputBorder(),
        hintText: isPixelMode ? "ENTER DATA..." : "Enter details",
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, DraftState draft, bool isPixelMode) {
    final dateStr = draft.dueDate == null ? "SELECT DATE" : DateFormat('yyyy-MM-dd').format(draft.dueDate!);
    return OutlinedButton(
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: draft.dueDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          ref.read(draftProvider.notifier).update((s) => s.copyWith(dueDate: date));
        }
      },
      style: OutlinedButton.styleFrom(
        shape: isPixelMode ? const RoundedRectangleBorder() : null,
        side: BorderSide(color: isPixelMode ? const Color(0xFF00FF88) : Colors.grey),
      ),
      child: Text(dateStr, style: TextStyle(color: isPixelMode ? const Color(0xFF00FF88) : Colors.white)),
    );
  }

  Widget _buildStatusDropdown(DraftState draft, bool isPixelMode) {
    return DropdownButton<TaskStatus>(
      value: draft.status,
      dropdownColor: Colors.black,
      isExpanded: true,
      items: TaskStatus.values.map((s) => DropdownMenuItem(
        value: s,
        child: Text(s.name.toUpperCase(), style: TextStyle(color: isPixelMode ? const Color(0xFF00FF88) : Colors.white)),
      )).toList(),
      onChanged: (val) {
        if (val != null) ref.read(draftProvider.notifier).update((s) => s.copyWith(status: val));
      },
    );
  }

  Widget _buildBlockedByDropdown(DraftState draft, List<Task> tasks, bool isPixelMode) {
    return DropdownButton<String?>(
      value: draft.blockedBy,
      dropdownColor: Colors.black,
      isExpanded: true,
      hint: const Text("NONE"),
      items: [
        const DropdownMenuItem(value: null, child: Text("NONE")),
        ...tasks.map((t) => DropdownMenuItem(value: t.id, child: Text(t.title))),
      ],
      onChanged: (val) {
        ref.read(draftProvider.notifier).update((s) => s.copyWith(blockedBy: val));
      },
    );
  }

  Widget _buildSaveButton(bool isLoading, bool isPixelMode) {
    return ElevatedButton(
      onPressed: isLoading ? null : () async {
        final draft = ref.read(draftProvider);
        if (_titleController.text.isEmpty || draft.dueDate == null) return;
        
        if (widget.task == null) {
          await ref.read(taskListProvider.notifier).addTask(
            title: _titleController.text,
            description: _descController.text,
            dueDate: draft.dueDate!,
            status: draft.status,
            blockedBy: draft.blockedBy,
          );
        } else {
          await ref.read(taskListProvider.notifier).updateTask(
            widget.task!.copyWith(
              title: _titleController.text,
              description: _descController.text,
              dueDate: draft.dueDate!,
              status: draft.status,
              blockedBy: draft.blockedBy,
            ),
          );
        }
        
        ref.read(draftProvider.notifier).state = DraftState(); // Clear draft
        if (mounted) Navigator.pop(context);
      },
      child: Text(isPixelMode ? "[ SAVE_TO_DISC ]" : "Save Task"),
    );
  }

  Widget _buildLoadingOverlay(bool isPixelMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isPixelMode) ...[
            const Text("SYSTEM UPDATING...", style: TextStyle(color: Color(0xFF00FF88))),
            const SizedBox(height: 20),
            const LinearProgressIndicator(color: Color(0xFF00FF88), backgroundColor: Colors.black),
            const SizedBox(height: 20),
            const Text("INITIALIZING...", style: TextStyle(fontSize: 8, color: Color(0xFF00FF88))),
            const Text("APPLYING CHANGES...", style: TextStyle(fontSize: 8, color: Color(0xFF00FF88))),
          ] else ...[
            const CircularProgressIndicator(color: Colors.orange),
            const SizedBox(height: 20),
            const Text("Saving Task...", style: TextStyle(color: Colors.grey)),
          ],
        ],
      ),
    );
  }
}
