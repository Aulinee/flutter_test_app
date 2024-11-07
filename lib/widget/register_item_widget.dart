import 'package:flutter/material.dart';
import '../styles/style.dart';

class RegisterItemWidget extends StatelessWidget {
  final String? scannedBarcode;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final VoidCallback onScan;
  final VoidCallback onAdd;
  final bool Function() isInputValid;

  const RegisterItemWidget({
    super.key,
    required this.scannedBarcode,
    required this.nameController,
    required this.quantityController,
    required this.onScan,
    required this.onAdd,
    required this.isInputValid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyles.standardPadding,
      child: Column(
        children: [
          if (scannedBarcode != null) ...[
            Text(
              'Scanned Barcode: $scannedBarcode',
              style: AppStyles.barcodeTextStyle,
            ),
            const SizedBox(height: 10),
          ],
          ElevatedButton(
            onPressed: onScan,
            style: AppStyles.elevatedButtonStyle,
            child: const Text('Scan Barcode'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            decoration: AppStyles.nameInputDecoration,
            enabled: scannedBarcode != null,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: quantityController,
            decoration: AppStyles.quantityInputDecoration,
            keyboardType: TextInputType.number,
            enabled: scannedBarcode != null,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: scannedBarcode != null
                ? () {
              if (isInputValid()) {
                onAdd();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid data.')),
                );
              }
            }
                : null,
            style: AppStyles.elevatedButtonStyle,
            child: const Text("Add Item"),
          ),
        ],
      ),
    );
  }
}