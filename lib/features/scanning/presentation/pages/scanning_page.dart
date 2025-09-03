import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/scanning/presentation/bloc/scanning_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanningPage extends StatelessWidget {
  const ScanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ScanningBloc>(),
      child: const _ScanningView(),
    );
  }
}

class _ScanningView extends StatefulWidget {
  const _ScanningView();

  @override
  State<_ScanningView> createState() => _ScanningViewState();
}

class _ScanningViewState extends State<_ScanningView> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.S.scanBarcodePageTitle),
      ),
      body: BlocListener<ScanningBloc, ScanningState>(
        listener: (context, state) {
          // Allow new scans once processing is finished
          if (state is! ScanningLoading) {
            setState(() {
              _isProcessing = false;
            });
          }

          if (state is ScanningProductFound) {
            _showProductFoundDialog(context, state.product);
          } else if (state is ScanningProductNotFound) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(context.S.productNotFound),
                  backgroundColor: Colors.red,
                ),
              );
          } else if (state is ScanningFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(context.S.serverError),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                if (_isProcessing) return;

                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? sku = barcodes.first.rawValue;
                  if (sku != null) {
                    setState(() {
                      _isProcessing = true;
                    });
                    context.read<ScanningBloc>().add(BarcodeDetected(sku));
                  }
                }
              },
            ),
            BlocBuilder<ScanningBloc, ScanningState>(
              builder: (context, state) {
                if (state is ScanningLoading) {
                  return Container(
                    color: Colors.black.withAlpha((255 * 0.5).round()),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }

  void _showProductFoundDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must acknowledge the dialog
      builder: (ctx) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.S.productSkuLabelWithColon(context.S.productSkuLabel, product.sku)),
            const SizedBox(height: 8),
            Text(context.S.quantityLabelWithColon(context.S.quantityLabel, product.quantity)),
          ],
        ),
        actions: [
          TextButton(
            child: Text(context.S.okButtonText),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}