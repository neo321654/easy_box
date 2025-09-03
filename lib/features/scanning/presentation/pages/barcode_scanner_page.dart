import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.S.scanBarcodePageTitle)),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isProcessing) return;

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              setState(() {
                _isProcessing = true;
              });
              Navigator.of(context).pop(code);
            }
          }
        },
      ),
    );
  }
}
