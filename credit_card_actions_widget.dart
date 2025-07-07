import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreditCardActionsWidget extends StatelessWidget {
  final Map<String, dynamic> card;
  final VoidCallback onAddPayment;
  final VoidCallback onViewStatements;
  final VoidCallback onSetAlerts;
  final VoidCallback onEditCard;
  final VoidCallback onDeleteCard;

  const CreditCardActionsWidget({
    super.key,
    required this.card,
    required this.onAddPayment,
    required this.onViewStatements,
    required this.onSetAlerts,
    required this.onEditCard,
    required this.onDeleteCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Card info header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: card['cardColor'] as Color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'credit_card',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card['bankName'] as String,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        card['cardNumber'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),

          // Action buttons
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                _buildActionTile(
                  context,
                  icon: 'payment',
                  title: 'Ödeme Ekle',
                  subtitle: 'Kart borcunu öde',
                  onTap: onAddPayment,
                  color: AppTheme.successLight,
                ),
                _buildActionTile(
                  context,
                  icon: 'receipt_long',
                  title: 'Ekstre Görüntüle',
                  subtitle: 'Geçmiş hareketleri incele',
                  onTap: onViewStatements,
                  color: Theme.of(context).colorScheme.primary,
                ),
                _buildActionTile(
                  context,
                  icon: 'notifications',
                  title: 'Uyarı Ayarla',
                  subtitle: 'Ödeme hatırlatıcısı kur',
                  onTap: onSetAlerts,
                  color: AppTheme.warningLight,
                ),
                _buildActionTile(
                  context,
                  icon: 'edit',
                  title: 'Kartı Düzenle',
                  subtitle: 'Kart bilgilerini güncelle',
                  onTap: onEditCard,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                _buildActionTile(
                  context,
                  icon: 'delete',
                  title: 'Kartı Sil',
                  subtitle: 'Kartı listeden kaldır',
                  onTap: onDeleteCard,
                  color: AppTheme.errorLight,
                  isDestructive: true,
                ),
              ],
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDestructive
                    ? AppTheme.errorLight.withValues(alpha: 0.2)
                    : Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: icon,
                    color: color,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: isDestructive
                                  ? AppTheme.errorLight
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
