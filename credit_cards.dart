import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/credit_card_actions_widget.dart';
import './widgets/credit_card_widget.dart';
import './widgets/debt_summary_widget.dart';

class CreditCards extends StatefulWidget {
  const CreditCards({super.key});

  @override
  State<CreditCards> createState() => _CreditCardsState();
}

class _CreditCardsState extends State<CreditCards>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  bool _isRefreshing = false;
  int? _selectedCardIndex;
  String? _swipeDirection;

  // Mock credit card data
  final List<Map<String, dynamic>> _creditCards = [
    {
      "id": 1,
      "bankName": "Garanti BBVA",
      "cardNumber": "**** **** **** 1234",
      "currentBalance": 3250.75,
      "creditLimit": 15000.0,
      "availableLimit": 11749.25,
      "utilizationRate": 0.217,
      "dueDate": "2024-02-15",
      "minimumPayment": 325.08,
      "cardColor": Color(0xFF00A651),
      "cardType": "Visa",
      "nickname": "Ana Kart",
      "lastTransactionDate": "2024-01-28",
      "isActive": true,
      "daysToDue": 18,
    },
    {
      "id": 2,
      "bankName": "İş Bankası",
      "cardNumber": "**** **** **** 5678",
      "currentBalance": 8750.50,
      "creditLimit": 12000.0,
      "availableLimit": 3249.50,
      "utilizationRate": 0.729,
      "dueDate": "2024-02-20",
      "minimumPayment": 875.05,
      "cardColor": Color(0xFF1B365D),
      "cardType": "Mastercard",
      "nickname": "İş Kartı",
      "lastTransactionDate": "2024-01-29",
      "isActive": true,
      "daysToDue": 23,
    },
    {
      "id": 3,
      "bankName": "Yapı Kredi",
      "cardNumber": "**** **** **** 9012",
      "currentBalance": 1850.25,
      "creditLimit": 8000.0,
      "availableLimit": 6149.75,
      "utilizationRate": 0.231,
      "dueDate": "2024-02-10",
      "minimumPayment": 185.03,
      "cardColor": Color(0xFF00B4D8),
      "cardType": "Visa",
      "nickname": "Alışveriş Kartı",
      "lastTransactionDate": "2024-01-27",
      "isActive": true,
      "daysToDue": 13,
    },
    {
      "id": 4,
      "bankName": "Akbank",
      "cardNumber": "**** **** **** 3456",
      "currentBalance": 12500.0,
      "creditLimit": 20000.0,
      "availableLimit": 7500.0,
      "utilizationRate": 0.625,
      "dueDate": "2024-02-25",
      "minimumPayment": 1250.0,
      "cardColor": Color(0xFFE31E24),
      "cardType": "Mastercard",
      "nickname": "Premium Kart",
      "lastTransactionDate": "2024-01-30",
      "isActive": true,
      "daysToDue": 28,
    },
  ];

  List<Map<String, dynamic>> get _filteredCards {
    if (_searchQuery.isEmpty) return _creditCards;
    return _creditCards.where((card) {
      final bankName = (card['bankName'] as String).toLowerCase();
      final nickname = (card['nickname'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return bankName.contains(query) || nickname.contains(query);
    }).toList();
  }

  double get _totalDebt {
    return _creditCards.fold(
        0.0, (sum, card) => sum + (card['currentBalance'] as double));
  }

  double get _totalLimit {
    return _creditCards.fold(
        0.0, (sum, card) => sum + (card['creditLimit'] as double));
  }

  double get _totalMinimumPayment {
    return _creditCards.fold(
        0.0, (sum, card) => sum + (card['minimumPayment'] as double));
  }

  Color _getUtilizationColor(double rate) {
    if (rate <= 0.3) return AppTheme.successLight;
    if (rate <= 0.7) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  Future<void> _refreshCards() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onCardTap(int index) {
    final card = _filteredCards[index];
    Navigator.pushNamed(
      context,
      '/credit-card-details',
      arguments: card,
    );
  }

  void _onCardLongPress(int index) {
    setState(() {
      _selectedCardIndex = index;
    });

    _showCardContextMenu(index);
  }

  void _showCardContextMenu(int index) {
    final card = _filteredCards[index];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CreditCardActionsWidget(
        card: card,
        onAddPayment: () => _handleAddPayment(card),
        onViewStatements: () => _handleViewStatements(card),
        onSetAlerts: () => _handleSetAlerts(card),
        onEditCard: () => _handleEditCard(card),
        onDeleteCard: () => _handleDeleteCard(card),
      ),
    );
  }

  void _handleAddPayment(Map<String, dynamic> card) {
    Navigator.pop(context);
    // Navigate to add payment screen
    Navigator.pushNamed(context, '/add-payment', arguments: card);
  }

  void _handleViewStatements(Map<String, dynamic> card) {
    Navigator.pop(context);
    // Navigate to statements screen
    Navigator.pushNamed(context, '/card-statements', arguments: card);
  }

  void _handleSetAlerts(Map<String, dynamic> card) {
    Navigator.pop(context);
    // Navigate to alerts screen
    Navigator.pushNamed(context, '/card-alerts', arguments: card);
  }

  void _handleEditCard(Map<String, dynamic> card) {
    Navigator.pop(context);
    // Navigate to edit card screen
    Navigator.pushNamed(context, '/edit-card', arguments: card);
  }

  void _handleDeleteCard(Map<String, dynamic> card) {
    Navigator.pop(context);
    _showDeleteConfirmation(card);
  }

  void _showDeleteConfirmation(Map<String, dynamic> card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Kartı Sil',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          '${card['bankName']} ${card['cardNumber']} kartını silmek istediğinizden emin misiniz?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCard(card);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _deleteCard(Map<String, dynamic> card) {
    setState(() {
      _creditCards.removeWhere((c) => c['id'] == card['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${card['bankName']} kartı silindi'),
        action: SnackBarAction(
          label: 'Geri Al',
          onPressed: () {
            setState(() {
              _creditCards.add(card);
            });
          },
        ),
      ),
    );
  }

  void _addNewCard() {
    Navigator.pushNamed(context, '/add-credit-card');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Kredi Kartları',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to card settings
              Navigator.pushNamed(context, '/card-settings');
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: Theme.of(context).appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: _creditCards.isEmpty ? _buildEmptyState() : _buildCardsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCard,
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: CustomIconWidget(
          iconName: 'add',
          color: Theme.of(context).floatingActionButtonTheme.foregroundColor!,
          size: 24,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'credit_card',
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'Henüz Kredi Kartınız Yok',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'İlk kredi kartınızı ekleyerek harcamalarınızı takip etmeye başlayın',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: _addNewCard,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Theme.of(context)
                    .elevatedButtonTheme
                    .style
                    ?.foregroundColor
                    ?.resolve({}),
                size: 20,
              ),
              label: const Text('İlk Kredi Kartınızı Ekleyin'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsList() {
    return Column(
      children: [
        // Debt Summary
        DebtSummaryWidget(
          totalDebt: _totalDebt,
          totalLimit: _totalLimit,
          totalMinimumPayment: _totalMinimumPayment,
          utilizationRate: _totalDebt / _totalLimit,
        ),

        // Search Bar
        _buildSearchBar(),

        // Cards List
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshCards,
            color: Theme.of(context).colorScheme.primary,
            child: _filteredCards.isEmpty
                ? _buildNoResultsState()
                : _buildCardsListView(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Banka adı veya kart adı ile ara...',
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'Arama Sonucu Bulunamadı',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Farklı anahtar kelimeler deneyebilirsiniz',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsListView() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      itemCount: _filteredCards.length,
      itemBuilder: (context, index) {
        final card = _filteredCards[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: CreditCardWidget(
            card: card,
            onTap: () => _onCardTap(index),
            onLongPress: () => _onCardLongPress(index),
            utilizationColor:
                _getUtilizationColor(card['utilizationRate'] as double),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 3, // Credit cards tab
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
            // Current screen
            break;
          case 4:
            Navigator.pushNamed(context, '/loans');
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
            color:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'home',
            color:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Ana Sayfa',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'add_circle_outline',
            color:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'add_circle',
            color:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Gelir Ekle',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'remove_circle_outline',
            color:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'remove_circle',
            color:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Gider Ekle',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'credit_card',
            color:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Kredi Kartları',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'account_balance',
            color:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'account_balance',
            color:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Krediler',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'pie_chart',
            color:
                Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'pie_chart',
            color:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
            size: 24,
          ),
          label: 'Bütçe',
        ),
      ],
    );
  }
}
