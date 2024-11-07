import 'package:flutter/material.dart';
import '../styles/style.dart';
import '../helper/db_helper.dart';

class EditItemDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onUpdate;

  const EditItemDialog({
    super.key,
    required this.item,
    required this.onUpdate,
  });

  @override
  EditItemDialogState createState() => EditItemDialogState();
}

class EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  String newName = '';
  int newQuantity = 0;

  @override
  void initState() {
    super.initState();
    newName = widget.item['name'];
    newQuantity = widget.item['quantity'];
    nameController = TextEditingController(text: newName);
    quantityController = TextEditingController(text: newQuantity.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: AppStyles.nameInputDecoration,
            onChanged: (value) {
              newName = value;
            },
          ),
          AppStyles.boxH8,
          TextField(
            controller: quantityController,
            decoration: AppStyles.quantityInputDecoration,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newQuantity = int.tryParse(value) ?? newQuantity;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () async {
            if (newName.isNotEmpty && newQuantity >= 0) {
              await DatabaseHelper().updateItem(
                widget.item['id'],
                {'name': newName, 'quantity': newQuantity},
              );
              widget.onUpdate();
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter valid data.')),
              );
            }
          },
        ),
      ],
    );
  }
}