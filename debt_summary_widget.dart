import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DebtSummaryWidget extends StatelessWidget {
  final double totalDebt;
  final double totalLimit;
  final double totalMinimumPayment;
  final double utilizationRate;

  const DebtSummaryWidget({
    super.key,
    required this.totalDebt,
    required this.totalLimit,
    required this.totalMinimumPayment,
    required this.utilizationRate,
  });

  Color get _utilizationColor {
    if (utilizationRate <= 0.3) return AppTheme.successLight;
    if (utilizationRate <= 0.7) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  String get _utilizationStatus {
    if (utilizationRate <= 0.3) return 'İyi';
    if (utilizationRate <= 0.7) return 'Orta';
    return 'Yüksek';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Borç Özeti',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: 'Toplam Borç',
                  value: '₺${totalDebt.toStringAsFixed(2)}',
                  icon: 'trending_up',
                  color: AppTheme.errorLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: 'Toplam Limit',
                  value: '₺${totalLimit.toStringAsFixed(2)}',
                  icon: 'credit_card',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: 'Min. Ödeme',
                  value: '₺${totalMinimumPayment.toStringAsFixed(2)}',
                  icon: 'payment',
                  color: AppTheme.warningLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: 'Kullanım Oranı',
                  value: '${(utilizationRate * 100).toStringAsFixed(1)}%',
                  icon: 'pie_chart',
                  color: _utilizationColor,
                  subtitle: _utilizationStatus,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Utilization progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Genel Kullanım Durumu',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _utilizationColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _utilizationStatus,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _utilizationColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                width: double.infinity,
                height: 1.h,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: utilizationRate.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _utilizationColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₺0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  Text(
                    '₺${totalLimit.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required String icon,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
