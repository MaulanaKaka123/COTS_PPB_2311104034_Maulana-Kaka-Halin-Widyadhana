import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../design_system/styles.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_checkbox.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _selectedDate;
  bool _isDone = false;
  bool _isSaving = false;
  
  String? _titleError;
  String? _courseError;
  String? _dateError;

  final List<String> _courses = [
    'Pemrograman Lanjut',
    'Rekayasa Perangkat Lunak',
    'Metodologi Penelitian',
    'Supply Chain',
    'UI Engineering',
    'KKN Tematik',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    bool isValid = true;
    setState(() {
      _titleError = null;
      _courseError = null;
      _dateError = null;

      if (_titleController.text.trim().isEmpty) {
        _titleError = 'Judul tugas wajib diisi';
        isValid = false;
      }
      if (_courseController.text.trim().isEmpty) {
        _courseError = 'Mata kuliah wajib dipilih';
        isValid = false;
      }
      if (_selectedDate == null) {
        _dateError = 'Deadline wajib dipilih';
        isValid = false;
      }
    });
    return isValid;
  }

  void _showCoursePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih Mata Kuliah", style: AppTextStyles.section),
            const SizedBox(height: AppSpacing.lg),
            ..._courses.map((course) => ListTile(
              title: Text(course, style: AppTextStyles.body),
              onTap: () {
                setState(() {
                  _courseController.text = course;
                  _courseError = null;
                });
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateError = null;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_validateForm()) return;

    setState(() => _isSaving = true);

    final controller = context.read<TaskController>();
    final newTask = Task(
      title: _titleController.text.trim(),
      course: _courseController.text.trim(),
      deadline: _selectedDate!,
      status: _isDone ? 'SELESAI' : 'BERJALAN',
      note: _noteController.text.trim(),
      isDone: _isDone,
    );

    final success = await controller.addTask(newTask);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah tugas'),
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
        title: Text("Tambah Tugas", style: AppTextStyles.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            CustomInput(
              label: "Judul Tugas",
              hint: "Masukkan judul tugas",
              controller: _titleController,
              errorText: _titleError,
            ),
            const SizedBox(height: AppSpacing.lg),

            CustomInput(
              label: "Mata Kuliah",
              hint: "Pilih mata kuliah",
              controller: _courseController,
              readOnly: true,
              onTap: _showCoursePicker,
              errorText: _courseError,
              suffixIcon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.lg),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Deadline", style: AppTextStyles.section.copyWith(fontSize: 14)),
                const SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: _dateError != null ? AppColors.danger : AppColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate != null ? dateFormat.format(_selectedDate!) : "Pilih tanggal",
                          style: _selectedDate != null
                              ? AppTextStyles.body
                              : AppTextStyles.caption.copyWith(fontSize: 14),
                        ),
                        const Icon(Icons.calendar_today, size: 18, color: AppColors.muted),
                      ],
                    ),
                  ),
                ),
                if (_dateError != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(_dateError!, style: AppTextStyles.caption.copyWith(color: AppColors.danger)),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            CustomCheckbox(
              value: _isDone,
              label: "Tugas sudah selesai",
              onChanged: (val) => setState(() => _isDone = val ?? false),
            ),
            const SizedBox(height: AppSpacing.lg),

            CustomInput(
              label: "Catatan",
              hint: "Catatan tambahan (opsional)",
              controller: _noteController,
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.xxl),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: Text("Batal", style: AppTextStyles.button.copyWith(color: AppColors.text)),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text("Simpan", style: AppTextStyles.button),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
