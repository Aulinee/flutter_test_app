import 'package:flutter/material.dart';
import '../styles/style.dart';
import 'edit_item_dialog.dart';

class DisplayItemsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final VoidCallback onUpdateItems; // Callback to refresh the items list
  final void Function(int id) onDelete; // Callback to delete an item

  const DisplayItemsWidget({
    super.key,
    required this.items,
    required this.onUpdateItems,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyles.standardPadding,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppStyles.cardBorderRadius),
            ),
            elevation: AppStyles.cardElevation,
            margin: AppStyles.cardMargin,
            child: ListTile(
              contentPadding: AppStyles.listTileContentPadding,
              leading: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.inventory, color: Colors.white),
              ),
              title: Text(
                item['name'],
                style: AppStyles.cardNameTextStyle,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppStyles.boxH4,
                  Text(
                    'Barcode: ${item['barcode']}',
                    style: AppStyles.cardSubtitleTextStyle,
                  ),
                  AppStyles.boxH4,
                  Text(
                    'Quantity: ${item['quantity']}',
                    style: AppStyles.cardSubtitleTextStyle,
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: AppStyles.editIcon,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => EditItemDialog(
                        item: item,
                        onUpdate: onUpdateItems, // Trigger update after editing
                      ),
                    ),
                  ),
                  IconButton(
                    icon: AppStyles.deleteIcon,
                    onPressed: () => onDelete(item['id']),
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