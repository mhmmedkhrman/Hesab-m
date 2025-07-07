import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetCategoryItemWidget extends StatelessWidget {
  final Map<String, dynamic> budget;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BudgetCategoryItemWidget({
    Key? key,
    required this.budget,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allocated = budget["allocated"] as double;
    final spent = budget["spent"] as double;
    final remaining = allocated - spent;
    final progress = allocated > 0 ? (spent / allocated).clamp(0.0, 1.0) : 0.0;
    final progressPercentage = (progress * 100).clamp(0.0, 100.0);

    return Dismissible(
      key: Key(budget["id"].toString()),
      background: _buildSwipeBackground(context, isLeft: false),
      secondaryBackground: _buildSwipeBackground(context, isLeft: true),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else {
          onEdit();
        }
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              _buildCategoryHeader(context),
              SizedBox(height: 2.h),
              _buildProgressBar(context, progress, progressPercentage),
              SizedBox(height: 1.5.h),
              _buildAmountDetails(context, allocated, spent, remaining),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: isLeft ? AppTheme.errorLight : AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isLeft ? 'delete' : 'edit',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isLeft ? 'Sil' : 'Düzenle',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: Color(budget["color"] as int).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: budget["icon"] as String,
              color: Color(budget["color"] as int),
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                budget["category"] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                'Aylık bütçe',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        _buildStatusIndicator(context),
      ],
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    final allocated = budget["allocated"] as double;
    final spent = budget["spent"] as double;
    final progress = allocated > 0 ? (spent / allocated) : 0.0;

    Color statusColor;
    String statusText;

    if (progress <= 0.7) {
      statusColor = AppTheme.successLight;
      statusText = 'İyi';
    } else if (progress <= 0.9) {
      statusColor = AppTheme.warningLight;
      statusText = 'Dikkat';
    } else {
      statusColor = AppTheme.errorLight;
      statusText = 'Aşıldı';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget _buildProgressBar(
      BuildContext context, double progress, double progressPercentage) {
    Color progressColor = _getProgressColor(progressPercentage);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'İlerleme',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            Text(
              '${progressPercentage.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildAmountDetails(
      BuildContext context, double allocated, double spent, double remaining) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAmountItem(
          context,
          'Bütçe',
          '₺${allocated.toStringAsFixed(0)}',
          Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        _buildAmountItem(
          context,
          'Harcanan',
          '₺${spent.toStringAsFixed(0)}',
          _getProgressColor((spent / allocated * 100).clamp(0.0, 100.0)),
        ),
        _buildAmountItem(
          context,
          'Kalan',
          '₺${remaining.toStringAsFixed(0)}',
          remaining >= 0 ? AppTheme.successLight : AppTheme.errorLight,
        ),
      ],
    );
  }

  Widget _buildAmountItem(
      BuildContext context, String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          amount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage <= 70) {
      return AppTheme.successLight;
    } else if (percentage <= 90) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.errorLight;
    }
  }
}
