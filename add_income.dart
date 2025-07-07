import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/amount_input_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/description_input_widget.dart';
import './widgets/income_source_dropdown_widget.dart';
import './widgets/recurring_income_widget.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedIncomeSource = 'Maaş';
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  String _recurringFrequency = 'Aylık';
  DateTime? _recurringEndDate;
  bool _isLoading = false;
  bool _isDraftSaved = false;

  final List<String> _incomeSources = ['Maaş', 'Freelance', 'Yatırım', 'Diğer'];

  final List<String> _recurringFrequencies = ['Haftalık', 'Aylık', 'Yıllık'];

  @override
  void initState() {
    super.initState();
    _loadDraftData();
    _amountController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadDraftData() {
    // Simulate loading draft data
    setState(() {
      _isDraftSaved = false;
    });
  }

  void _onFormChanged() {
    if (!_isDraftSaved) {
      _saveDraft();
    }
  }

  void _saveDraft() {
    // Auto-save draft to prevent data loss
    setState(() {
      _isDraftSaved = true;
    });
  }

  bool _isFormValid() {
    return _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text.replaceAll(',', '.')) != null &&
        double.parse(_amountController.text.replaceAll(',', '.')) > 0;
  }

  Future<void> _saveIncome() async {
    if (!_formKey.currentState!.validate() || !_isFormValid()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Haptic feedback for success
      HapticFeedback.lightImpact();

      // Show success toast
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gelir başarıyla kaydedildi!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          ),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );

      // Navigate back to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard-home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gelir kaydedilirken bir hata oluştu!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onError,
            ),
          ),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Gelir Ekle',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: _isFormValid() && !_isLoading ? _saveIncome : null,
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
                      color: _isFormValid()
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount Input
                AmountInputWidget(
                  controller: _amountController,
                  onChanged: (value) {
                    setState(() {});
                    _onFormChanged();
                  },
                ),

                SizedBox(height: 3.h),

                // Income Source Dropdown
                IncomeSourceDropdownWidget(
                  selectedSource: _selectedIncomeSource,
                  sources: _incomeSources,
                  onChanged: (value) {
                    setState(() {
                      _selectedIncomeSource = value;
                    });
                    _onFormChanged();
                  },
                ),

                SizedBox(height: 3.h),

                // Date Picker
                DatePickerWidget(
                  selectedDate: _selectedDate,
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                    _onFormChanged();
                  },
                ),

                SizedBox(height: 3.h),

                // Description Input
                DescriptionInputWidget(
                  controller: _descriptionController,
                  onChanged: (value) {
                    _onFormChanged();
                  },
                ),

                SizedBox(height: 3.h),

                // Recurring Income Toggle
                RecurringIncomeWidget(
                  isRecurring: _isRecurring,
                  frequency: _recurringFrequency,
                  endDate: _recurringEndDate,
                  frequencies: _recurringFrequencies,
                  onRecurringChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                      if (!value) {
                        _recurringEndDate = null;
                      }
                    });
                    _onFormChanged();
                  },
                  onFrequencyChanged: (value) {
                    setState(() {
                      _recurringFrequency = value;
                    });
                    _onFormChanged();
                  },
                  onEndDateChanged: (date) {
                    setState(() {
                      _recurringEndDate = date;
                    });
                    _onFormChanged();
                  },
                ),

                SizedBox(height: 6.h),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 7.h,
                  child: ElevatedButton(
                    onPressed:
                        _isFormValid() && !_isLoading ? _saveIncome : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid()
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.3),
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      elevation: _isFormValid() ? 2.0 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Kaydediliyor...',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Geliri Kaydet',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
