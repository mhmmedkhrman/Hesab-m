import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/amount_input_widget.dart';
import './widgets/category_selection_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/receipt_capture_widget.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({Key? key}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _merchantController = TextEditingController();

  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  String _selectedPaymentMethod = '';
  List<String> _selectedTags = [];
  bool _isRecurring = false;
  String _recurringFrequency = 'Aylık';
  bool _isLoading = false;
  String? _capturedReceiptPath;

  // Mock data for categories
  final List<Map<String, dynamic>> _expenseCategories = [
    {"id": "food", "name": "Yemek", "icon": "restaurant", "color": 0xFFFF6B6B},
    {
      "id": "transport",
      "name": "Ulaşım",
      "icon": "directions_car",
      "color": 0xFF4ECDC4
    },
    {
      "id": "shopping",
      "name": "Alışveriş",
      "icon": "shopping_bag",
      "color": 0xFF45B7D1
    },
    {
      "id": "bills",
      "name": "Faturalar",
      "icon": "receipt_long",
      "color": 0xFFF7DC6F
    },
    {
      "id": "entertainment",
      "name": "Eğlence",
      "icon": "movie",
      "color": 0xFFBB6BD9
    },
    {
      "id": "health",
      "name": "Sağlık",
      "icon": "local_hospital",
      "color": 0xFF26DE81
    },
    {"id": "other", "name": "Diğer", "icon": "category", "color": 0xFF95A5A6},
  ];

  // Mock data for payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {"id": "cash", "name": "Nakit", "icon": "payments", "balance": "∞"},
    {
      "id": "card1",
      "name": "Ziraat Bankası",
      "icon": "credit_card",
      "balance": "₺15,250.00"
    },
    {
      "id": "card2",
      "name": "İş Bankası",
      "icon": "credit_card",
      "balance": "₺8,750.50"
    },
    {
      "id": "card3",
      "name": "Garanti BBVA",
      "icon": "credit_card",
      "balance": "₺22,100.25"
    },
  ];

  // Mock data for tags
  final List<String> _availableTags = [
    "İş",
    "Kişisel",
    "Acil",
    "Planlı",
    "Hediye",
    "Seyahat",
    "Ev",
    "Araba"
  ];

  // Mock data for recurring frequencies
  final List<String> _recurringFrequencies = [
    "Günlük",
    "Haftalık",
    "Aylık",
    "3 Aylık",
    "6 Aylık",
    "Yıllık"
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      _selectedTags.contains(tag)
          ? _selectedTags.remove(tag)
          : _selectedTags.add(tag);
    });
  }

  void _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir kategori seçin')),
      );
      return;
    }

    if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen ödeme yöntemi seçin')),
      );
      return;
    }

    // Check for future date confirmation
    if (_selectedDate.isAfter(DateTime.now())) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gelecek Tarih'),
          content: const Text(
              'Gelecek bir tarih seçtiniz. Devam etmek istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Devam Et'),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gider başarıyla kaydedildi'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Gider Ekle',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveExpense,
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  )
                : Text(
                    'Kaydet',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input
              AmountInputWidget(
                controller: _amountController,
                onChanged: (value) => setState(() {}),
              ),

              SizedBox(height: 3.h),

              // Category Selection
              Text(
                'Kategori',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              CategorySelectionWidget(
                categories: _expenseCategories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (categoryId) {
                  setState(() {
                    _selectedCategory = categoryId;
                  });
                },
              ),

              SizedBox(height: 3.h),

              // Date Selection
              Text(
                'Tarih',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Merchant/Description
              Text(
                'Açıklama',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Gider açıklaması...',
                ),
                maxLines: 2,
              ),

              SizedBox(height: 2.h),

              TextFormField(
                controller: _merchantController,
                decoration: const InputDecoration(
                  hintText: 'Mağaza/Firma adı...',
                ),
              ),

              SizedBox(height: 3.h),

              // Receipt Capture
              ReceiptCaptureWidget(
                onReceiptCaptured: (imagePath) {
                  setState(() {
                    _capturedReceiptPath = imagePath;
                  });
                },
                capturedReceiptPath: _capturedReceiptPath,
              ),

              SizedBox(height: 3.h),

              // Payment Method
              Text(
                'Ödeme Yöntemi',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              PaymentMethodWidget(
                paymentMethods: _paymentMethods,
                selectedPaymentMethod: _selectedPaymentMethod,
                onPaymentMethodSelected: (methodId) {
                  setState(() {
                    _selectedPaymentMethod = methodId;
                  });
                },
              ),

              SizedBox(height: 3.h),

              // Tags
              Text(
                'Etiketler',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) => _toggleTag(tag),
                    selectedColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                  );
                }).toList(),
              ),

              SizedBox(height: 3.h),

              // Recurring Expense
              Row(
                children: [
                  Switch(
                    value: _isRecurring,
                    onChanged: (value) {
                      setState(() {
                        _isRecurring = value;
                      });
                    },
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Tekrarlayan Gider',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                ],
              ),

              _isRecurring
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Text(
                          'Tekrar Sıklığı',
                          style: AppTheme.lightTheme.textTheme.bodyLarge,
                        ),
                        SizedBox(height: 1.h),
                        DropdownButtonFormField<String>(
                          value: _recurringFrequency,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          items: _recurringFrequencies.map((frequency) {
                            return DropdownMenuItem(
                              value: frequency,
                              child: Text(frequency),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _recurringFrequency = value;
                              });
                            }
                          },
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),

              SizedBox(height: 5.h),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveExpense,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Gideri Kaydet',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
