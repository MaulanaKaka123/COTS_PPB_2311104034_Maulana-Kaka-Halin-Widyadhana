import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/styles.dart';
import '../../controllers/task_controller.dart';
import '../widgets/task_card.dart';
import 'task_list_page.dart';
import 'add_task_page.dart';
import 'detail_task_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : RefreshIndicator(
                    onRefresh: () => controller.fetchTasks(),
                    color: AppColors.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tugas Besar", style: AppTextStyles.title),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskListPage()));
                                },
                                child: Text("Daftar Tugas", style: AppTextStyles.link),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Summary Cards
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildSummaryItem("Total Tugas", controller.totalTasks.toString()),
                                ),
                                Container(width: 1, height: 50, color: AppColors.border),
                                Expanded(
                                  child: _buildSummaryItem("Selesai", controller.completedTasks.toString()),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Section Header
                          Text("Tugas Terdekat", style: AppTextStyles.section),
                          const SizedBox(height: AppSpacing.md),

                          // Error message
                          if (controller.error != null)
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              margin: const EdgeInsets.only(bottom: AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Text(controller.error!, style: AppTextStyles.caption.copyWith(color: AppColors.danger)),
                            ),

                          // Recent Tasks List
                          Expanded(
                            child: controller.recentTasks.isEmpty
                                ? Center(child: Text("Belum ada tugas", style: AppTextStyles.caption))
                                : ListView.builder(
                                    itemCount: controller.recentTasks.length,
                                    itemBuilder: (context, index) {
                                      final task = controller.recentTasks[index];
                                      return TaskCard(
                                        task: task,
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => DetailTaskPage(task: task)),
                                          );
                                          if (context.mounted) controller.fetchTasks();
                                        },
                                      );
                                    },
                                  ),
                          ),

                          // Bottom Button
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
                                if (context.mounted) controller.fetchTasks();
                              },
                              child: Text("Tambah Tugas", style: AppTextStyles.button),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, String count) {
    return Column(
      children: [
        Text(count, style: AppTextStyles.title.copyWith(fontSize: 32, color: AppColors.text)),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
