import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/balance_card_widget.dart';
import './widgets/financial_metrics_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/spending_breakdown_widget.dart';
import './widgets/upcoming_payments_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isBalanceVisible = true;
  bool _isRefreshing = false;

  // Mock financial data
  final Map<String, dynamic> _financialData = {
    "totalBalance": 15750.50,
    "monthlyIncome": 8500.00,
    "monthlyExpenses": 6200.00,
    "availableFunds": 2300.00,
    "upcomingPayments": [
      {
        "title": "Kredi Kartı Ödemesi",
        "amount": 1250.00,
        "dueDate": "2024-01-15",
        "daysLeft": 3,
        "type": "credit"
      },
      {
        "title": "Konut Kredisi",
        "amount": 2800.00,
        "dueDate": "2024-01-20",
        "daysLeft": 8,
        "type": "loan"
      }
    ],
    "spendingCategories": [
      {
        "name": "Yiyecek",
        "amount": 1800.00,
        "percentage": 29.0,
        "color": 0xFF3B82F6
      },
      {
        "name": "Ulaşım",
        "amount": 950.00,
        "percentage": 15.3,
        "color": 0xFF10B981
      },
      {
        "name": "Faturalar",
        "amount": 1200.00,
        "percentage": 19.4,
        "color": 0xFFF59E0B
      },
      {
        "name": "Eğlence",
        "amount": 750.00,
        "percentage": 12.1,
        "color": 0xFFEF4444
      },
      {
        "name": "Diğer",
        "amount": 1500.00,
        "percentage": 24.2,
        "color": 0xFF8B5CF6
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            slivers: [
              _buildStickyHeader(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    BalanceCardWidget(
                      totalBalance: _financialData["totalBalance"] as double,
                      isVisible: _isBalanceVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                    ),
                    SizedBox(height: 3.h),
                    FinancialMetricsWidget(
                      monthlyIncome: _financialData["monthlyIncome"] as double,
                      monthlyExpenses:
                          _financialData["monthlyExpenses"] as double,
                      availableFunds:
                          _financialData["availableFunds"] as double,
                    ),
                    SizedBox(height: 2.h),
                    UpcomingPaymentsWidget(
                      payments: (_financialData["upcomingPayments"] as List)
                          .map((payment) => payment as Map<String, dynamic>)
                          .toList(),
                    ),
                    SizedBox(height: 2.h),
                    SpendingBreakdownWidget(
                      categories: (_financialData["spendingCategories"] as List)
                          .map((category) => category as Map<String, dynamic>)
                          .toList(),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: QuickActionsWidget(
        onAddIncome: () => Navigator.pushNamed(context, '/add-income'),
        onAddExpense: () => Navigator.pushNamed(context, '/add-expense'),
      ),
    );
  }

  Widget _buildStickyHeader() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Merhaba!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                Text(
                  _getCurrentDate(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.successLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'security',
                        color: AppTheme.successLight,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Güvenli',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.successLight,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () {
                    // Handle notification tap
                  },
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'notifications',
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        _handleBottomNavigation(index);
      },
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _selectedIndex == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Ana Sayfa',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: _selectedIndex == 1
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Gelir/Gider',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'credit_card',
            color: _selectedIndex == 2
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Borçlar',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'analytics',
            color: _selectedIndex == 3
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Analiz',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _selectedIndex == 4
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profil',
        ),
      ],
    );
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        // Already on dashboard home
        break;
      case 1:
        Navigator.pushNamed(context, '/add-income');
        break;
      case 2:
        Navigator.pushNamed(context, '/credit-cards');
        break;
      case 3:
        Navigator.pushNamed(context, '/budget-management');
        break;
      case 4:
        // Navigate to profile
        break;
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
