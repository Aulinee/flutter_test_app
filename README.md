# Simple Inventory Management App

A simple inventory management application built with Flutter. This app allows users to scan barcodes, manage inventory items, and update item details such as name and quantity.

## Features

- Barcode scanning using the `mobile_scanner` package.
- Add, edit, and delete inventory items.
- Persistent storage using SQLite for offline access.

## Getting Started

To run this project, you'll need to have Flutter installed on your machine. Follow the steps below to get started.

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK (version 3.0 or higher)
- Android Studio or any other preferred IDE

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Aulinee/flutter_test_app.git
   cd flutter_test_app
   
2. Install the required dependencies:
   ```bash
   flutter pub get
   
3. Run the app:
   ```bash
   flutter run

## Usage

- Launch the app on your device or emulator.
- Scan barcodes to add new items to your inventory.
- Browse through the list of items, including their names, barcodes, and quantities.
- Click the edit icon to modify item details, and update the fields in the popup dialog.
- Remove items from your inventory by using the delete icon.

## Built With

- [Flutter](https://flutter.dev/) - The framework used for building the application.
- [Sqflite](https://pub.dev/packages/sqflite) - SQLite plugin for Flutter for local database management.
- [Mobile Scanner](https://pub.dev/packages/mobile_scanner) - A package for barcode scanning functionality.
