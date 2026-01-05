import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../design_system/styles.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../widgets/status_badge.dart';
import '../widgets/custom_checkbox.dart';

class DetailTaskPage extends StatefulWidget {
  final Task task;
  const DetailTaskPage({super.key, required this.task});

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  late bool isDone;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    isDone = widget.task.isDone;
  }

  Future<void> _saveChanges() async {
    if (isDone == widget.task.isDone) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isSaving = true);

    final controller = context.read<TaskController>();
    final success = await controller.toggleTaskStatus(widget.task.id!);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan perubahan'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Detail Tugas", style: AppTextStyles.title),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Edit", style: AppTextStyles.link),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Judul Tugas", style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.xs),
                  Text(widget.task.title, style: AppTextStyles.section),
                  const SizedBox(height: AppSpacing.lg),
                  
                  Text("Mata Kuliah", style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.xs),
                  Text(widget.task.course, style: AppTextStyles.body),
                  const SizedBox(height: AppSpacing.lg),
                  
                  Text("Deadline", style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.xs),
                  Text(dateFormat.format(widget.task.deadline), style: AppTextStyles.body),
                  const SizedBox(height: AppSpacing.lg),
                  
                  Text("Status", style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.xs),
                  StatusBadge(status: isDone ? 'Selesai' : widget.task.status),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Penyelesaian Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Penyelesaian", style: AppTextStyles.section),
                  const SizedBox(height: AppSpacing.md),
                  CustomCheckbox(
                    value: isDone,
                    label: "Tugas sudah selesai",
                    onChanged: (val) => setState(() => isDone = val ?? false),
                  ),
                  Text("Centang jika tugas sudah final.", style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Catatan Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Catatan", style: AppTextStyles.section),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.task.note.isNotEmpty ? widget.task.note : "Tidak ada catatan.",
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Save Button
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
                onPressed: _isSaving ? null : _saveChanges,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text("Simpan Perubahan", style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
