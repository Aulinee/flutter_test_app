import 'package:flutter/material.dart';

class AppStyles {
  // Padding styles
  static const EdgeInsets standardPadding = EdgeInsets.all(8.0);
  static const EdgeInsets textPadding = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets buttonPadding = EdgeInsets.all(16.0);

  // Text Styles
  static const TextStyle barcodeTextStyle = TextStyle(
    fontSize: 16,
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.red,
  );

  static const TextStyle cardNameTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static TextStyle cardSubtitleTextStyle = TextStyle(
      fontSize: 14,
      color: Colors.grey[600]
  );

  // ElevatedButton Style
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );

  // Input Field Decoration
  static const InputDecoration nameInputDecoration = InputDecoration(
    labelText: 'Item Name',
  );

  static const InputDecoration quantityInputDecoration = InputDecoration(
    labelText: 'Quantity',
  );

  static const listTileContentPadding = EdgeInsets.all(16.0);
  static const cardMargin = EdgeInsets.symmetric(vertical: 6.0);
  static const cardElevation = 4.0;
  static const cardBorderRadius = 12.0;

  //Icon Style
  static const Icon editIcon =  Icon(Icons.edit, color: Colors.green);
  static const Icon deleteIcon =  Icon(Icons.delete, color: Colors.red);

  //Box Style
  static const SizedBox boxH4 = SizedBox (height: 4);
  static const SizedBox boxH8 = SizedBox (height: 8);
  static const SizedBox boxH12 = SizedBox (height: 12);
  static const SizedBox boxH16 = SizedBox (height: 16);
}