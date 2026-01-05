import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../design_system/styles.dart';
import '../../models/task.dart';
import 'status_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                StatusBadge(status: task.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(task.course, style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Deadline: ${dateFormat.format(task.deadline)}",
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
