import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_box/core/extensions/context_extension.dart';

class QuantityInputDialog extends StatefulWidget {
  final int initialQuantity;
  final int maxQuantity;

  const QuantityInputDialog({
    super.key,
    required this.initialQuantity,
    required this.maxQuantity,
  });

  @override
  State<QuantityInputDialog> createState() => _QuantityInputDialogState();
}

class _QuantityInputDialogState extends State<QuantityInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialQuantity.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.S.quantityLabel),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.S.cancelButtonText),
        ),
        TextButton(
          onPressed: () {
            final quantity = int.tryParse(_controller.text) ?? 0;
            if (quantity >= 0 && quantity <= widget.maxQuantity) {
              Navigator.of(context).pop(quantity);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.S.quantityMustBePositiveError),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Text(context.S.okButtonText),
        ),
      ],
    );
  }
}
