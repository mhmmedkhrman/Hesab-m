import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class EmptyLoansWidget extends StatelessWidget {
  const EmptyLoansWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'account_balance',
                  color: Theme.of(context).colorScheme.primary,
                  size: 48,
                ),
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Kredinizi Takip Etmeye Başlayın',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12),

            Text(
              'Henüz hiç kredi eklenmemiş. Kredilerinizi ekleyerek ödeme takibinizi başlatabilirsiniz.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 32),

            // Loan type education cards
            Column(
              children: [
                _buildLoanTypeCard(
                  context,
                  'Konut Kredisi',
                  'Ev alımı için kullanılan uzun vadeli krediler',
                  'home',
                  AppTheme.successLight,
                ),
                SizedBox(height: 12),
                _buildLoanTypeCard(
                  context,
                  'Taşıt Kredisi',
                  'Araç alımı için kullanılan orta vadeli krediler',
                  'directions_car',
                  Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 12),
                _buildLoanTypeCard(
                  context,
                  'İhtiyaç Kredisi',
                  'Kişisel ihtiyaçlar için kullanılan kısa vadeli krediler',
                  'account_balance_wallet',
                  AppTheme.warningLight,
                ),
                SizedBox(height: 12),
                _buildLoanTypeCard(
                  context,
                  'Eğitim Kredisi',
                  'Eğitim masrafları için kullanılan özel krediler',
                  'school',
                  Color(0xFF8B5CF6),
                ),
              ],
            ),

            SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () {
                // Navigate to add loan screen
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: Text('İlk Kredinizi Ekleyin'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanTypeCard(
    BuildContext context,
    String title,
    String description,
    String iconName,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
