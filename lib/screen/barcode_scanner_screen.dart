import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final Function(String) onBarcodeScanned;

  const BarcodeScannerScreen({super.key, required this.onBarcodeScanned});

  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}

class BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late MobileScannerController cameraController;
  bool _isScanning = true; // To track scanning state

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture barcodeCapture) {
          if (_isScanning) {
            final List<Barcode> barcodes = barcodeCapture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                _isScanning = false; // Prevent further scans until this is handled
                widget.onBarcodeScanned(barcode.rawValue!);
                Navigator.pop(context); // Close after scanning
                break;
              }
            }
          }
        },
      ),
    );
  }
}
