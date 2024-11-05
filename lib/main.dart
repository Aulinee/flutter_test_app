import 'package:flutter/material.dart';
import 'package:flutter_test_app/helper/db_helper.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Inventory Management App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  List<Map<String, dynamic>> items = [];
  String? scannedBarcode;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() async {
    final data = await dbHelper.getItems();
    setState(() {
      items = data;
    });
  }

  void _addItem() async {
    if (scannedBarcode != null &&
        nameController.text.isNotEmpty &&
        quantityController.text.isNotEmpty) {
      await dbHelper.insertItem({
        'barcode': scannedBarcode,
        'name': nameController.text,
        'quantity': int.parse(quantityController.text),
      });
      nameController.clear();
      quantityController.clear();
      setState(() {
        scannedBarcode = null;
      });
      _fetchItems();
    }
  }

  void _deleteItem(int id) async {
    await dbHelper.deleteItem(id);
    _fetchItems();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      scannedBarcode = null; //To reset previous barcode
    });
  }

  void _showEditDialog(BuildContext context, int index) {
    final item = items[index];
    String newName = item['name'];
    int newQuantity = item['quantity'];

    // Controllers should be created here, outside the dialog
    TextEditingController nameController = TextEditingController(text: newName);
    TextEditingController quantityController = TextEditingController(text: newQuantity.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
                onChanged: (value) {
                  newName = value;  // Update newName directly
                },
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newQuantity = int.tryParse(value) ?? newQuantity;  // Safely update newQuantity
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Validate input
                if (newName.isNotEmpty && newQuantity >= 0) {
                  // Update database
                  dbHelper.updateItem(item['id'], {'name': newName, 'quantity': newQuantity});
                  _fetchItems();
                  Navigator.of(context).pop();
                } else {
                  // Optional: Show an error if validation fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid data.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _scanBarcode() async {
    if (await Permission.camera.request().isGranted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BarcodeScannerScreen(
            onBarcodeScanned: (barcode) {
              setState(() {
                scannedBarcode = barcode;
              });
            },
          ),
        ),
      );
      // To perform additional actions if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = _buildRegisterItem();
        break;
      case 1:
        body = _buildCheckingItem();
        break;
      case 2:
      default:
        body = _buildDisplayItems();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Register',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Items',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildRegisterItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (scannedBarcode != null) ...[
            Text('Scanned Barcode: $scannedBarcode', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10)
          ],
          ElevatedButton(
            onPressed: _scanBarcode,
            child: const Text('Scan Barcode'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Item Name'),
            enabled: scannedBarcode != null,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
            enabled: scannedBarcode != null,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: scannedBarcode != null ? _addItem : null,
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckingItem() {
    Map<String, dynamic>? matchingItem = items.firstWhere(
          (item) => item['barcode'] == scannedBarcode,
      orElse: () => {},
    );

    // Set `matchingItem` to null if the empty map was returned
    if (matchingItem.isEmpty) {
      matchingItem = null;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (scannedBarcode != null) ...[
            Text(
              'Scanned Barcode: $scannedBarcode',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (matchingItem != null) ...[
              // Display item details if found
              Text(
                'Item Name: ${matchingItem['name']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Quantity: ${matchingItem['quantity']}',
                style: const TextStyle(fontSize: 16),
              ),
            ] else ...[
              // Display "not found" message if no match
              const Text(
                'Item not found in inventory.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
            const SizedBox(height: 16),
          ],
          Center(
            child: ElevatedButton(
              onPressed: _scanBarcode,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Check Barcode'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayItems() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.inventory, color: Colors.white),
              ),
              title: Text(
                item['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Barcode: ${item['barcode']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantity: ${item['quantity']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () => _showEditDialog(context, index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(item['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}

class BarcodeScannerScreen extends StatefulWidget {
  final Function(String) onBarcodeScanned;
  const BarcodeScannerScreen({super.key, required this.onBarcodeScanned});

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late MobileScannerController cameraController;
  bool isScanning = true; // To track scanning state

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
      appBar: AppBar(title: const Text('Register Barcode')),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture barcodeCapture) {
          if (isScanning) {
            final List<Barcode> barcodes = barcodeCapture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                isScanning = false; // Prevent further scans until this is handled
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