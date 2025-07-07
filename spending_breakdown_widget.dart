import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SpendingBreakdownWidget extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const SpendingBreakdownWidget({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Harcama Dağılımı',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/budget-management');
                },
                child: Text(
                  'Detaylar',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSpendingChart(context),
                SizedBox(height: 3.h),
                ...categories
                    .map((category) => _buildCategoryItem(context, category)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingChart(BuildContext context) {
    return Container(
      height: 25.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CustomPaint(
              painter: _DonutChartPainter(categories),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Toplam',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              Text(
                '₺${_formatCurrency(_getTotalAmount())}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, Map<String, dynamic> category) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: Color(category["color"] as int),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category["name"] as String,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  '₺${_formatCurrency(category["amount"] as double)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: Color(category["color"] as int).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '%${(category["percentage"] as double).toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Color(category["color"] as int),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  double _getTotalAmount() {
    return categories.fold(
        0.0, (sum, category) => sum + (category["amount"] as double));
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> categories;

  _DonutChartPainter(this.categories);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.15;

    double startAngle = -90 * (3.14159 / 180); // Start from top
    final total = categories.fold(
        0.0, (sum, category) => sum + (category["percentage"] as double));

    for (final category in categories) {
      final percentage = category["percentage"] as double;
      final sweepAngle = (percentage / total) * 2 * 3.14159;

      final paint = Paint()
        ..color = Color(category["color"] as int)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
