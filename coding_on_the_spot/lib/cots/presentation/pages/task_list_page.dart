import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../design_system/styles.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import 'detail_task_page.dart';
import 'add_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String selectedFilter = 'Semua';
  String searchQuery = '';
  final List<String> filters = ['Semua', 'Berjalan', 'Selesai', 'Terlambat'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Task> _getFilteredTasks(TaskController controller) {
    List<Task> tasks = controller.filterTasks(selectedFilter);
    if (searchQuery.isNotEmpty) {
      tasks = tasks.where((t) =>
          t.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.course.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, controller, child) {
        final tasks = _getFilteredTasks(controller);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.text),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text("Daftar Tugas", style: AppTextStyles.title),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(Icons.add, color: AppColors.primary, size: 20),
                ),
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
                  if (context.mounted) controller.fetchTasks();
                },
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.fetchTasks(),
            color: AppColors.primary,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: "Cari tugas atau mata kuliah...",
                      hintStyle: AppTextStyles.caption,
                      prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: filters.map((filter) {
                      bool isSelected = selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (val) => setState(() => selectedFilter = filter),
                          backgroundColor: AppColors.surface,
                          selectedColor: AppColors.primary,
                          labelStyle: AppTextStyles.caption.copyWith(
                            color: isSelected ? Colors.white : AppColors.text,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            side: BorderSide(color: isSelected ? Colors.transparent : AppColors.border),
                          ),
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : tasks.isEmpty
                          ? Center(child: Text("Tidak ada tugas", style: AppTextStyles.caption))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                              itemCount: tasks.length,
                              itemBuilder: (context, index) => _buildTaskItem(context, tasks[index], controller),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task, TaskController controller) {
    final dateFormat = DateFormat('dd MMM');
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailTaskPage(task: task)));
        if (context.mounted) controller.fetchTasks();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: _getStatusColor(task.status), shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(task.course, style: AppTextStyles.caption),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(dateFormat.format(task.deadline), style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SELESAI': return AppColors.success;
      case 'TERLAMBAT': return AppColors.danger;
      default: return AppColors.primary;
    }
  }
}
