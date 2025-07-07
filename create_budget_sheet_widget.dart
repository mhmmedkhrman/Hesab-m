import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreateBudgetSheetWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onBudgetCreated;
  final Map<String, dynamic>? existingBudget;

  const CreateBudgetSheetWidget({
    Key? key,
    required this.onBudgetCreated,
    this.existingBudget,
  }) : super(key: key);

  @override
  State<CreateBudgetSheetWidget> createState() =>
      _CreateBudgetSheetWidgetState();
}

class _CreateBudgetSheetWidgetState extends State<CreateBudgetSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String? _selectedCategory;
  String? _selectedIcon;
  int? _selectedColor;
  bool _enableAlerts = true;

  final List<Map<String, dynamic>> _categories = [
    {"name": "Market & Gıda", "icon": "shopping_cart", "color": 0xFF10B981},
    {"name": "Ulaşım", "icon": "directions_car", "color": 0xFF3B82F6},
    {"name": "Eğlence", "icon": "movie", "color": 0xFFF59E0B},
    {"name": "Sağlık", "icon": "local_hospital", "color": 0xFFEF4444},
    {"name": "Kıyafet", "icon": "checkroom", "color": 0xFF8B5CF6},
    {"name": "Faturalar", "icon": "receipt_long", "color": 0xFF06B6D4},
    {"name": "Eğitim", "icon": "school", "color": 0xFF14B8A6},
    {"name": "Teknoloji", "icon": "devices", "color": 0xFF6366F1},
    {"name": "Spor", "icon": "fitness_center", "color": 0xFFEC4899},
    {"name": "Diğer", "icon": "category", "color": 0xFF64748B},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingBudget != null) {
      _selectedCategory = widget.existingBudget!["category"] as String?;
      _selectedIcon = widget.existingBudget!["icon"] as String?;
      _selectedColor = widget.existingBudget!["color"] as int?;
      _amountController.text =
          (widget.existingBudget!["allocated"] as double).toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          Text(
            widget.existingBudget != null ? 'Bütçe Düzenle' : 'Yeni Bütçe',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          TextButton(
            onPressed: _saveBudget,
            child: Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Kategori Seçin'),
            SizedBox(height: 2.h),
            _buildCategoryGrid(context),
            SizedBox(height: 4.h),
            _buildSectionTitle(context, 'Bütçe Miktarı'),
            SizedBox(height: 2.h),
            _buildAmountInput(context),
            SizedBox(height: 4.h),
            _buildAlertSettings(context),
            SizedBox(height: 6.h),
            _buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final isSelected = _selectedCategory == category["name"];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category["name"] as String;
              _selectedIcon = category["icon"] as String;
              _selectedColor = category["color"] as int;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(category["color"] as int).withValues(alpha: 0.1)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Color(category["color"] as int)
                    : Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: category["icon"] as String,
                  color: Color(category["color"] as int),
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    category["name"] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? Color(category["color"] as int)
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmountInput(BuildContext context) {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      decoration: InputDecoration(
        labelText: 'Bütçe Miktarı',
        hintText: '0',
        prefixText: '₺ ',
        suffixText: 'TL',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bütçe miktarı gerekli';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'Geçerli bir miktar girin';
        }
        return null;
      },
    );
  }

  Widget _buildAlertSettings(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Uyarı Ayarları',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 2.h),
          SwitchListTile(
            title: Text(
              'Bütçe Aşım Uyarıları',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              'Bütçenizin %80\'ine ulaştığınızda bildirim alın',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            value: _enableAlerts,
            onChanged: (value) {
              setState(() {
                _enableAlerts = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveBudget,
        child:
            Text(widget.existingBudget != null ? 'Güncelle' : 'Bütçe Oluştur'),
      ),
    );
  }

  void _saveBudget() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lütfen bir kategori seçin'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
        return;
      }

      final budgetData = {
        "category": _selectedCategory!,
        "allocated": double.parse(_amountController.text),
        "icon": _selectedIcon!,
        "color": _selectedColor!,
        "enableAlerts": _enableAlerts,
      };

      widget.onBudgetCreated(budgetData);
    }
  }
}
