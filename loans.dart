import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/empty_loans_widget.dart';
import './widgets/loan_card_widget.dart';
import './widgets/loan_stats_widget.dart';

class Loans extends StatefulWidget {
  const Loans({super.key});

  @override
  State<Loans> createState() => _LoansState();
}

class _LoansState extends State<Loans> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'balance'; // balance, dueDate, progress
  bool _isRefreshing = false;

  // Mock loan data
  final List<Map<String, dynamic>> _loanData = [
    {
      "id": 1,
      "type": "Konut",
      "lender": "Ziraat Bankası",
      "remainingBalance": 450000.0,
      "monthlyPayment": 3250.0,
      "totalAmount": 500000.0,
      "nextPaymentDate": DateTime.now().add(Duration(days: 15)),
      "isOverdue": false,
      "icon": "home",
      "color": 0xFF10B981,
      "interestRate": 1.89,
      "remainingMonths": 180,
    },
    {
      "id": 2,
      "type": "Taşıt",
      "lender": "Garanti BBVA",
      "remainingBalance": 125000.0,
      "monthlyPayment": 2850.0,
      "totalAmount": 200000.0,
      "nextPaymentDate": DateTime.now().add(Duration(days: 8)),
      "isOverdue": false,
      "icon": "directions_car",
      "color": 0xFF3B82F6,
      "interestRate": 2.15,
      "remainingMonths": 48,
    },
    {
      "id": 3,
      "type": "İhtiyaç",
      "lender": "İş Bankası",
      "remainingBalance": 35000.0,
      "monthlyPayment": 1450.0,
      "totalAmount": 50000.0,
      "nextPaymentDate": DateTime.now().subtract(Duration(days: 2)),
      "isOverdue": true,
      "icon": "account_balance_wallet",
      "color": 0xFFF59E0B,
      "interestRate": 2.95,
      "remainingMonths": 24,
    },
    {
      "id": 4,
      "type": "Eğitim",
      "lender": "Akbank",
      "remainingBalance": 18500.0,
      "monthlyPayment": 850.0,
      "totalAmount": 25000.0,
      "nextPaymentDate": DateTime.now().add(Duration(days: 22)),
      "isOverdue": false,
      "icon": "school",
      "color": 0xFF8B5CF6,
      "interestRate": 1.75,
      "remainingMonths": 24,
    },
  ];

  List<Map<String, dynamic>> get _filteredLoans {
    List<Map<String, dynamic>> filtered = _loanData.where((loan) {
      final loanType = (loan['type'] as String).toLowerCase();
      final lenderName = (loan['lender'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();

      return loanType.contains(query) || lenderName.contains(query);
    }).toList();

    // Sort loans
    switch (_sortBy) {
      case 'balance':
        filtered.sort((a, b) => (b['remainingBalance'] as double)
            .compareTo(a['remainingBalance'] as double));
        break;
      case 'dueDate':
        filtered.sort((a, b) => (a['nextPaymentDate'] as DateTime)
            .compareTo(b['nextPaymentDate'] as DateTime));
        break;
      case 'progress':
        filtered.sort((a, b) {
          double progressA = 1.0 -
              ((a['remainingBalance'] as double) /
                  (a['totalAmount'] as double));
          double progressB = 1.0 -
              ((b['remainingBalance'] as double) /
                  (b['totalAmount'] as double));
          return progressB.compareTo(progressA);
        });
        break;
    }

    return filtered;
  }

  double get _totalMonthlyPayment {
    return _loanData.fold(
        0.0, (sum, loan) => sum + (loan['monthlyPayment'] as double));
  }

  double get _totalRemainingBalance {
    return _loanData.fold(
        0.0, (sum, loan) => sum + (loan['remainingBalance'] as double));
  }

  Future<void> _refreshLoans() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sıralama Seçenekleri',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            _buildSortOption('balance', 'Bakiye Tutarı', 'account_balance'),
            _buildSortOption('dueDate', 'Ödeme Tarihi', 'schedule'),
            _buildSortOption('progress', 'Ödeme İlerlemesi', 'trending_up'),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String value, String title, String icon) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: _sortBy == value
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _sortBy == value
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: _sortBy == value ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: _sortBy == value
          ? CustomIconWidget(
              iconName: 'check',
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            )
          : null,
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Krediler'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showSortOptions,
            icon: CustomIconWidget(
              iconName: 'sort',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to add loan screen
            },
            icon: CustomIconWidget(
              iconName: 'add',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: _loanData.isEmpty
          ? EmptyLoansWidget()
          : RefreshIndicator(
              onRefresh: _refreshLoans,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                children: [
                  // Search bar
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Kredi ara...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12),
                          child: CustomIconWidget(
                            iconName: 'search',
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                icon: CustomIconWidget(
                                  iconName: 'clear',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 20,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),

                  // Loan statistics
                  LoanStatsWidget(
                    totalMonthlyPayment: _totalMonthlyPayment,
                    totalRemainingBalance: _totalRemainingBalance,
                    loanCount: _loanData.length,
                  ),

                  // Loan list
                  Expanded(
                    child: _filteredLoans.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'search_off',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  size: 48,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Arama kriterinize uygun kredi bulunamadı',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredLoans.length,
                            itemBuilder: (context, index) {
                              final loan = _filteredLoans[index];
                              return LoanCardWidget(
                                loan: loan,
                                onTap: () {
                                  // Navigate to loan details
                                },
                                onPaymentSwipe: () {
                                  // Handle payment entry
                                  _showPaymentDialog(loan);
                                },
                                onDetailsSwipe: () {
                                  // Handle loan details
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4, // Loans tab index
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard-home');
              break;
            case 1:
              Navigator.pushNamed(context, '/add-income');
              break;
            case 2:
              Navigator.pushNamed(context, '/add-expense');
              break;
            case 3:
              Navigator.pushNamed(context, '/credit-cards');
              break;
            case 4:
              // Current screen
              break;
            case 5:
              Navigator.pushNamed(context, '/budget-management');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'home',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'home',
                color: Theme.of(context).colorScheme.primary,
                size: 24),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'add_circle_outline',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'add_circle',
                color: Theme.of(context).colorScheme.primary,
                size: 24),
            label: 'Gelir',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'remove_circle_outline',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'remove_circle',
                color: Theme.of(context).colorScheme.primary,
                size: 24),
            label: 'Gider',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'credit_card',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'credit_card',
                color: Theme.of(context).colorScheme.primary,
                size: 24),
            label: 'Kartlar',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'account_balance',
                color: Theme.of(context).colorScheme.primary,
                size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'account_balance',
                color: Theme.of(context).colorScheme.primary,
                size: 24),
            label: 'Krediler',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
                iconName: 'pie_chart_outline',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24),
            activeIcon: CustomIconWidget(
                iconName: 'pie_chart',
                color: Theme.of(context).colorScheme.primary,
                size: 24),
            label: 'Bütçe',
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(Map<String, dynamic> loan) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ödeme Yap'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${loan['type']} - ${loan['lender']}'),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Ödeme Tutarı (₺)',
                hintText: '${loan['monthlyPayment']}',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle payment
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ödeme kaydedildi'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: Text('Ödeme Yap'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
