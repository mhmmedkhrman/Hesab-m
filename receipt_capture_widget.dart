import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReceiptCaptureWidget extends StatelessWidget {
  final ValueChanged<String>? onReceiptCaptured;
  final String? capturedReceiptPath;

  const ReceiptCaptureWidget({
    Key? key,
    this.onReceiptCaptured,
    this.capturedReceiptPath,
  }) : super(key: key);

  void _captureReceipt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Fiş Ekle',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Simulate camera capture
                      onReceiptCaptured?.call(
                          'camera_receipt_${DateTime.now().millisecondsSinceEpoch}.jpg');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'camera_alt',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Kamera',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Simulate gallery selection
                      onReceiptCaptured?.call(
                          'gallery_receipt_${DateTime.now().millisecondsSinceEpoch}.jpg');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'photo_library',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Galeri',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Fiş/Fatura',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _captureReceipt(context),
              icon: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              label: Text(
                'Fiş Ekle',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        if (capturedReceiptPath != null) ...[
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            height: 20.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'receipt',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 48,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Fiş Eklendi',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'OCR ile tutar çıkarılıyor...',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 1.h,
                  right: 2.w,
                  child: IconButton(
                    onPressed: () => onReceiptCaptured?.call(''),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
