import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IncomeSourceDropdownWidget extends StatefulWidget {
  final String selectedSource;
  final List<String> sources;
  final Function(String) onChanged;

  const IncomeSourceDropdownWidget({
    super.key,
    required this.selectedSource,
    required this.sources,
    required this.onChanged,
  });

  @override
  State<IncomeSourceDropdownWidget> createState() =>
      _IncomeSourceDropdownWidgetState();
}

class _IncomeSourceDropdownWidgetState
    extends State<IncomeSourceDropdownWidget> {
  final TextEditingController _customSourceController = TextEditingController();
  bool _showCustomInput = false;

  @override
  void dispose() {
    _customSourceController.dispose();
    super.dispose();
  }

  void _showCustomSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Özel Gelir Kaynağı',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: _customSourceController,
            decoration: InputDecoration(
              hintText: 'Gelir kaynağı adını giriniz',
              hintStyle: AppTheme.lightTheme.inputDecorationTheme.hintStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2.0,
                ),
              ),
            ),
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _customSourceController.clear();
              },
              child: Text(
                'İptal',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_customSourceController.text.trim().isNotEmpty) {
                  widget.onChanged(_customSourceController.text.trim());
                  Navigator.of(context).pop();
                  _customSourceController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gelir Kaynağı',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
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
              value: widget.sources.contains(widget.selectedSource)
                  ? widget.selectedSource
                  : null,
              hint: Text(
                widget.sources.contains(widget.selectedSource)
                    ? widget.selectedSource
                    : widget.selectedSource,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              isExpanded: true,
              items: [
                ...widget.sources.map((String source) {
                  return DropdownMenuItem<String>(
                    value: source,
                    child: Text(
                      source,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }),
                DropdownMenuItem<String>(
                  value: 'custom',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Özel Kaynak Ekle',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue == 'custom') {
                  _showCustomSourceDialog();
                } else if (newValue != null) {
                  widget.onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
