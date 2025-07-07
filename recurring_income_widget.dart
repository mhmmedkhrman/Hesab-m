import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecurringIncomeWidget extends StatelessWidget {
  final bool isRecurring;
  final String frequency;
  final DateTime? endDate;
  final List<String> frequencies;
  final Function(bool) onRecurringChanged;
  final Function(String) onFrequencyChanged;
  final Function(DateTime?) onEndDateChanged;

  const RecurringIncomeWidget({
    super.key,
    required this.isRecurring,
    required this.frequency,
    required this.endDate,
    required this.frequencies,
    required this.onRecurringChanged,
    required this.onFrequencyChanged,
    required this.onEndDateChanged,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      locale: const Locale('tr', 'TR'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
              headerForegroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.onPrimary;
                }
                return AppTheme.lightTheme.colorScheme.onSurface;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.lightTheme.colorScheme.primary;
                }
                return Colors.transparent;
              }),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              dayShape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onEndDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recurring Toggle
        Row(
          children: [
            Expanded(
              child: Text(
                'Tekrarlayan Gelir',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Switch(
              value: isRecurring,
              onChanged: onRecurringChanged,
              activeColor: AppTheme.lightTheme.colorScheme.primary,
              activeTrackColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.3),
              inactiveThumbColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              inactiveTrackColor: AppTheme
                  .lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
            ),
          ],
        ),

        if (isRecurring) ...[
          SizedBox(height: 2.h),

          // Frequency Selection
          Text(
            'Tekrar Sıklığı',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1.0,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: frequency,
                icon: CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                isExpanded: true,
                items: frequencies.map((String freq) {
                  return DropdownMenuItem<String>(
                    value: freq,
                    child: Text(
                      freq,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onFrequencyChanged(newValue);
                  }
                },
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // End Date Selection
          Text(
            'Bitiş Tarihi (İsteğe Bağlı)',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),

          InkWell(
            onTap: () => _selectEndDate(context),
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'event',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      endDate != null
                          ? _formatDate(endDate!)
                          : 'Bitiş tarihi seçiniz',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: endDate != null
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (endDate != null)
                    InkWell(
                      onTap: () => onEndDateChanged(null),
                      child: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    )
                  else
                    CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 0.5.h),
          Text(
            'Tekrarlayan gelirin ne zaman sona ereceğini belirleyebilirsiniz',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
