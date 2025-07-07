import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/budget_category_item_widget.dart';
import './widgets/budget_overview_widget.dart';
import './widgets/create_budget_sheet_widget.dart';

class BudgetManagement extends StatefulWidget {
  const BudgetManagement({Key? key}) : super(key: key);

  @override
  State<BudgetManagement> createState() => _BudgetManagementState();
}

class _BudgetManagementState extends State<BudgetManagement> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock budget data
  final List<Map<String, dynamic>> budgetCategories = [
    {
      "id": 1,
      "category": "Market & Gıda",
      "allocated": 2500.0,
      "spent": 1850.0,
      "icon": "shopping_cart",
      "color": 0xFF10B981,
    },
    {
      "id": 2,
      "category": "Ulaşım",
      "allocated": 800.0,
      "spent": 650.0,
      "icon": "directions_car",
      "color": 0xFF3B82F6,
    },
    {
      "id": 3,
      "category": "Eğlence",
      "allocated": 1200.0,
      "spent": 1150.0,
      "icon": "movie",
      "color": 0xFFF59E0B,
    },
    {
      "id": 4,
      "category": "Sağlık",
      "allocated": 600.0,
      "spent": 720.0,
      "icon": "local_hospital",
      "color": 0xFFEF4444,
    },
    {
      "id": 5,
      "category": "Kıyafet",
      "allocated": 1000.0,
      "spent": 450.0,
      "icon": "checkroom",
      "color": 0xFF8B5CF6,
    },
    {
      "id": 6,
      "category": "Faturalar",
      "allocated": 1500.0,
      "spent": 1480.0,
      "icon": "receipt_long",
      "color": 0xFF06B6D4,
    },
  ];

  double get totalBudget => (budgetCategories as List)
      .fold(0.0, (sum, item) => sum + (item["allocated"] as double));
  double get totalSpent => (budgetCategories as List)
      .fold(0.0, (sum, item) => sum + (item["spent"] as double));
  double get budgetProgress =>
      totalBudget > 0 ? (totalSpent / totalBudget) : 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: Theme.of(context).appBarTheme.foregroundColor ?? Colors.black,
          size: 24,
        ),
      ),
      title: Text(
        'Bütçe Yönetimi',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    return budgetCategories.isEmpty
        ? _buildEmptyState(context)
        : _buildBudgetContent(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'account_balance_wallet',
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'İlk Bütçenizi Oluşturun',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Harcamalarınızı kontrol altında tutmak için kategorilere göre bütçe belirleyin.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () => _showCreateBudgetSheet(context),
              child: Text('Bütçe Oluştur'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetContent(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshBudgetData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BudgetOverviewWidget(
              totalBudget: totalBudget,
              totalSpent: totalSpent,
              budgetProgress: budgetProgress,
            ),
            SizedBox(height: 3.h),
            _buildCategoriesHeader(context),
            SizedBox(height: 2.h),
            _buildBudgetCategoriesList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Kategori Bütçeleri',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
        ),
        TextButton(
          onPressed: () => _showCreateBudgetSheet(context),
          child: Text('Yeni Ekle'),
        ),
      ],
    );
  }

  Widget _buildBudgetCategoriesList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: budgetCategories.length,
      separatorBuilder: (context, index) => SizedBox(height: 1.h),
      itemBuilder: (context, index) {
        final budget = budgetCategories[index];
        return BudgetCategoryItemWidget(
          budget: budget,
          onTap: () => _navigateToBudgetDetails(context, budget),
          onEdit: () => _editBudget(context, budget),
          onDelete: () => _deleteBudget(context, budget),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateBudgetSheet(context),
      backgroundColor:
          Theme.of(context).floatingActionButtonTheme.backgroundColor,
      child: CustomIconWidget(
        iconName: 'add',
        color: Theme.of(context).floatingActionButtonTheme.foregroundColor ??
            Colors.white,
        size: 24,
      ),
    );
  }

  void _showCreateBudgetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateBudgetSheetWidget(
        onBudgetCreated: (Map<String, dynamic> newBudget) {
          setState(() {
            budgetCategories.add({
              "id": budgetCategories.length + 1,
              ...newBudget,
              "spent": 0.0,
            });
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bütçe başarıyla oluşturuldu'),
              backgroundColor: AppTheme.successLight,
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshBudgetData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Simulate data refresh
    });
  }

  void _navigateToBudgetDetails(
      BuildContext context, Map<String, dynamic> budget) {
    // Navigate to budget details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${budget["category"]} detayları açılıyor...'),
      ),
    );
  }

  void _editBudget(BuildContext context, Map<String, dynamic> budget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateBudgetSheetWidget(
        existingBudget: budget,
        onBudgetCreated: (Map<String, dynamic> updatedBudget) {
          setState(() {
            final index = budgetCategories.indexWhere(
                (item) => (item)["id"] == budget["id"]);
            if (index != -1) {
              budgetCategories[index] = {
                ...budget,
                ...updatedBudget,
              };
            }
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bütçe güncellendi'),
              backgroundColor: AppTheme.successLight,
            ),
          );
        },
      ),
    );
  }

  void _deleteBudget(BuildContext context, Map<String, dynamic> budget) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bütçeyi Sil'),
        content: Text(
            '${budget["category"]} bütçesini silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                budgetCategories.removeWhere((item) =>
                    (item)["id"] == budget["id"]);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Bütçe silindi'),
                  backgroundColor: AppTheme.errorLight,
                ),
              );
            },
            child: Text('Sil'),
          ),
        ],
      ),
    );
  }
}
