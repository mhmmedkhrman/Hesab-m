import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DescriptionInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const DescriptionInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<DescriptionInputWidget> createState() => _DescriptionInputWidgetState();
}

class _DescriptionInputWidgetState extends State<DescriptionInputWidget> {
  static const int maxLength = 200;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Açıklama (İsteğe Bağlı)',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1.0,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            maxLines: 3,
            maxLength: maxLength,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Gelir hakkında ek bilgi ekleyebilirsiniz...',
              hintStyle: AppTheme.lightTheme.inputDecorationTheme.hintStyle,
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              counterStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            onChanged: widget.onChanged,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Gelir kaynağı hakkında detay bilgi ekleyebilirsiniz',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
