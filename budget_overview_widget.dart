import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BudgetOverviewWidget extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final double budgetProgress;

  const BudgetOverviewWidget({
    Key? key,
    required this.totalBudget,
    required this.totalSpent,
    required this.budgetProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final remaining = totalBudget - totalSpent;
    final progressPercentage = (budgetProgress * 100).clamp(0.0, 100.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: 4.h),
          _buildProgressCircle(context, progressPercentage),
          SizedBox(height: 4.h),
          _buildBudgetSummary(context, remaining),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Aylık Bütçe Özeti',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Aralık 2024',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCircle(BuildContext context, double progressPercentage) {
    Color progressColor = _getProgressColor(progressPercentage);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 40.w,
          height: 40.w,
          child: CircularProgressIndicator(
            value: budgetProgress.clamp(0.0, 1.0),
            strokeWidth: 8,
            backgroundColor:
                Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${progressPercentage.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              'Kullanıldı',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetSummary(BuildContext context, double remaining) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryItem(
            context,
            'Toplam Bütçe',
            '₺${totalBudget.toStringAsFixed(0)}',
            AppTheme.primaryLight,
          ),
        ),
        Container(
          width: 1,
          height: 6.h,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
        Expanded(
          child: _buildSummaryItem(
            context,
            'Harcanan',
            '₺${totalSpent.toStringAsFixed(0)}',
            _getProgressColor((budgetProgress * 100).clamp(0.0, 100.0)),
          ),
        ),
        Container(
          width: 1,
          height: 6.h,
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
        Expanded(
          child: _buildSummaryItem(
            context,
            'Kalan',
            '₺${remaining.toStringAsFixed(0)}',
            remaining >= 0 ? AppTheme.successLight : AppTheme.errorLight,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(
      BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
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
