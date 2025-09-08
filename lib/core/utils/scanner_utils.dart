import 'package:easy_box/features/scanning/presentation/pages/barcode_scanner_page.dart';
import 'package:flutter/material.dart';

/// Navigates to the barcode scanner page and returns the scanned barcode.
Future<String?> scanBarcode(BuildContext context) {
  return Navigator.of(
    context,
  ).push<String>(MaterialPageRoute(builder: (_) => const BarcodeScannerPage()));
}
