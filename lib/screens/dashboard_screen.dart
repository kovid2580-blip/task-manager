import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/theme_toggle.dart';
import 'task_form_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPixelMode = ref.watch(isPixelModeProvider);
    final tasksAsync = ref.watch(taskListProvider);
    final filteredTasks = ref.watch(filteredTasksProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, ref, isPixelMode),
          _buildSearchAndFilter(context, ref, isPixelMode),
          _buildTaskList(context, tasksAsync, filteredTasks, isPixelMode),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TaskFormScreen()),
        ),
        backgroundColor: isPixelMode ? Colors.black : Colors.orange,
        shape: isPixelMode 
          ? const RoundedRectangleBorder(side: BorderSide(color: Color(0xFF00FF88), width: 2)) 
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Icon(Icons.add, color: isPixelMode ? const Color(0xFF00FF88) : Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isPixelMode) {
    if (isPixelMode) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SYSTEM ONLINE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("TASK MANAGER v1.0", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  ThemeToggle(
                    isPixelMode: isPixelMode,
                    onToggle: () => ref.read(isPixelModeProvider.notifier).state = !isPixelMode,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const StatsRowLegacy(),
            ],
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Stack(
        children: [
          // 1. Base dark container
          Container(
            height: 240,
            color: const Color(0xFF121212),
          ),
          // 2. Linear gradient layer with Shadow/Depth
          Container(
            height: 240,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFA726),
                  Color(0xFFFF6F00),
                  Color(0xFF121212),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.4, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6F00).withValues(alpha: 0.25),
                  blurRadius: 50,
                  spreadRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          // 3. Radial glow overlay
          Container(
            height: 240,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color(0x33FFA726), // soft transparent glow
                  Colors.transparent,
                ],
                radius: 0.8,
                center: Alignment.topLeft,
              ),
            ),
          ),
          // Content Layer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome back,", style: TextStyle(fontSize: 16, color: Colors.white70)),
                        Text("Kovid!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    ThemeToggle(
                      isPixelMode: isPixelMode,
                      onToggle: () => ref.read(isPixelModeProvider.notifier).state = !isPixelMode,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const StatsGridModern(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, WidgetRef ref, bool isPixelMode) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomSearchBar(isPixelMode: isPixelMode),
            const SizedBox(height: 10),
            const StatusFilterRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, AsyncValue tasksAsync, List filteredTasks, bool isPixelMode) {
    return tasksAsync.when(
      data: (_) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => TaskCard(task: filteredTasks[index], isPixelMode: isPixelMode),
            childCount: filteredTasks.length,
          ),
        ),
      ),
      loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
      error: (e, _) => SliverFillRemaining(child: Center(child: Text("Error: $e"))),
    );
  }
}
