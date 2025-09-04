import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(Icons.image, size: width, color: Colors.grey);
    }

    return imageUrl!.startsWith('http')
        ? Image.network(
            imageUrl!,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.broken_image, size: width, color: Colors.grey),
          )
        : Image.file(
            File(imageUrl!),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.broken_image, size: width, color: Colors.grey),
          );
  }
}
