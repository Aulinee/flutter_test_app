// checking_item_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_test_app/styles/style.dart';

class CheckItemWidget extends StatelessWidget {
  final String? scannedBarcode;
  final List<Map<String, dynamic>> items;
  final VoidCallback onScanBarcode;

  const CheckItemWidget({
    super.key,
    required this.scannedBarcode,
    required this.items,
    required this.onScanBarcode,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? matchingItem = items.firstWhere(
          (item) => item['barcode'] == scannedBarcode,
      orElse: () => {},
    );

    // Set `matchingItem` to null if the empty map was returned
    if (matchingItem.isEmpty) {
      matchingItem = null;
    }

    return Padding(
      padding: AppStyles.standardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (scannedBarcode != null) ...[
            Text(
              'Scanned Barcode: $scannedBarcode',
              style: AppStyles.cardNameTextStyle,
            ),
            AppStyles.boxH12,
            if (matchingItem != null) ...[
              // Display item details if found
              Text(
                'Item Name: ${matchingItem['name']}',
                style: AppStyles.barcodeTextStyle,
              ),
              AppStyles.boxH8,
              Text(
                'Quantity: ${matchingItem['quantity']}',
                style: AppStyles.barcodeTextStyle,
              ),
            ] else ...[
              // Display "not found" message if no match
              const Text(
                'Item not found in inventory.',
                style: AppStyles.errorTextStyle,
              ),
            ],
            AppStyles.boxH16,
          ],
          Center(
            child: ElevatedButton(
              onPressed: onScanBarcode,
              style: AppStyles.elevatedButtonStyle,
              child: const Text('Check Barcode'),
            ),
          ),
        ],
      ),
    );
  }
}
