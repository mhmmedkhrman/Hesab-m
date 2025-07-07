import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LoanCardWidget extends StatelessWidget {
  final Map<String, dynamic> loan;
  final VoidCallback onTap;
  final VoidCallback onPaymentSwipe;
  final VoidCallback onDetailsSwipe;

  const LoanCardWidget({
    super.key,
    required this.loan,
    required this.onTap,
    required this.onPaymentSwipe,
    required this.onDetailsSwipe,
  });

  @override
  Widget build(BuildContext context) {
    final double remainingBalance = loan['remainingBalance'] as double;
    final double totalAmount = loan['totalAmount'] as double;
    final double monthlyPayment = loan['monthlyPayment'] as double;
    final DateTime nextPaymentDate = loan['nextPaymentDate'] as DateTime;
    final bool isOverdue = loan['isOverdue'] as bool;
    final String type = loan['type'] as String;
    final String lender = loan['lender'] as String;
    final String iconName = loan['icon'] as String;
    final int colorValue = loan['color'] as int;
    final double interestRate = loan['interestRate'] as double;
    final int remainingMonths = loan['remainingMonths'] as int;

    final double progress = 1.0 - (remainingBalance / totalAmount);
    final int daysUntilPayment =
        nextPaymentDate.difference(DateTime.now()).inDays;

    return Dismissible(
      key: Key(loan['id'].toString()),
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.successLight,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'payment',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              'Ödeme',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'info',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              'Detaylar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onPaymentSwipe();
        } else {
          onDetailsSwipe();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isOverdue
                ? BorderSide(
                    color: AppTheme.errorLight,
                    width: 1,
                  )
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(colorValue).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: iconName,
                            color: Color(colorValue),
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  type,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                if (isOverdue) ...[
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.errorLight,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'VADESİ GEÇTİ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              lender,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₺${remainingBalance.toStringAsFixed(0)}',
                            style: AppTheme.financialDataStyle(
                              isLight: Theme.of(context).brightness ==
                                  Brightness.light,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Kalan Borç',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ödeme İlerlemesi',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(1)}%',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress > 0.8
                              ? AppTheme.successLight
                              : progress > 0.5
                                  ? Color(colorValue)
                                  : AppTheme.warningLight,
                        ),
                        minHeight: 6,
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Payment info row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₺${monthlyPayment.toStringAsFixed(0)}',
                              style: AppTheme.financialDataStyle(
                                isLight: Theme.of(context).brightness ==
                                    Brightness.light,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Aylık Ödeme',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '%${interestRate.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Faiz Oranı',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              isOverdue
                                  ? '${daysUntilPayment.abs()} gün geçti'
                                  : daysUntilPayment == 0
                                      ? 'Bugün'
                                      : '${daysUntilPayment} gün kaldı',
                              style: TextStyle(
                                color: isOverdue
                                    ? AppTheme.errorLight
                                    : daysUntilPayment <= 3
                                        ? AppTheme.warningLight
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Sonraki Ödeme',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Bottom info
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${remainingMonths} ay kaldı',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'swipe',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Kaydır',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
