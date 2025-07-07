import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;

  const QuickActionsWidget({
    super.key,
    required this.onAddIncome,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          onPressed: onAddExpense,
          backgroundColor: AppTheme.errorLight,
          foregroundColor: Colors.white,
          icon: CustomIconWidget(
            iconName: 'remove',
            color: Colors.white,
            size: 20,
          ),
          label: Text(
            'Gider Ekle',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          heroTag: "expense",
        ),
        SizedBox(height: 2.h),
        FloatingActionButton.extended(
          onPressed: onAddIncome,
          backgroundColor: AppTheme.successLight,
          foregroundColor: Colors.white,
          icon: CustomIconWidget(
            iconName: 'add',
            color: Colors.white,
            size: 20,
          ),
          label: Text(
            'Gelir Ekle',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          heroTag: "income",
        ),
      ],
    );
  }
}
