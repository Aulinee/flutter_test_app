import 'package:flutter/material.dart';
import 'package:flutter_test_app/helper/db_helper.dart';
import 'package:flutter_test_app/screen/barcode_scanner_screen.dart';
import 'package:flutter_test_app/widget/check_item_widget.dart';
import 'package:flutter_test_app/widget/display_item_widget.dart';
import 'package:flutter_test_app/widget/register_item_widget.dart';
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
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  String? scannedBarcode;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    //_fetchItems();
  }

  void _fetchItems() async {
    final data = await dbHelper.getItems();
    setState(() {
      _items = data;
    });
  }

  void _addItem() async {
    if (scannedBarcode != null &&
        _nameController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      await dbHelper.insertItem({
        'barcode': scannedBarcode,
        'name': _nameController.text,
        'quantity': int.parse(_quantityController.text),
      });
      _nameController.clear();
      _quantityController.clear();
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

  //Helper Function
  bool _isInputValid() {
    final name = _nameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim());

    // Example validation: check if name is not empty and quantity is a positive number
    return name.isNotEmpty && quantity != null && quantity > 0;
  }

  Future<void> _scanBarcode() async {
    if (await Permission.camera.request().isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BarcodeScannerScreen(
            onBarcodeScanned: (barcode) {
              // Check if the widget is still mounted before calling setState
              if (mounted) {
                setState(() {
                  scannedBarcode = barcode;
                });
              }
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
    return RegisterItemWidget(
      scannedBarcode: scannedBarcode,
      nameController: _nameController,
      quantityController: _quantityController,
      onScan: _scanBarcode,
      onAdd: _addItem,
      isInputValid: _isInputValid,
    );
  }

  Widget _buildCheckingItem() {
    return CheckItemWidget(
      scannedBarcode: scannedBarcode,
      items: _items,
      onScanBarcode: _scanBarcode,
    );
  }

  Widget _buildDisplayItems() {
    return DisplayItemsWidget(
      items: _items,
      onUpdateItems: _fetchItems,
      onDelete: _deleteItem,
    );
  }
}