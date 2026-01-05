import 'package:flutter/material.dart';
import '../../design_system/styles.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get _backgroundColor {
    switch (status.toUpperCase()) {
      case 'SELESAI':
        return AppColors.success.withValues(alpha: 0.1);
      case 'TERLAMBAT':
        return AppColors.danger.withValues(alpha: 0.1);
      default:
        return AppColors.primary.withValues(alpha: 0.1);
    }
  }

  Color get _textColor {
    switch (status.toUpperCase()) {
      case 'SELESAI':
        return AppColors.success;
      case 'TERLAMBAT':
        return AppColors.danger;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }
}
