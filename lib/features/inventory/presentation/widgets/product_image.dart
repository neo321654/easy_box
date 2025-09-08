import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
    // ignore: avoid_print
    print('[DEBUG] ProductImage received URL: $imageUrl');

    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(Icons.image, size: width, color: Colors.grey);
    }

    final uri = Uri.tryParse(imageUrl!);

    // A network URL will be an absolute URI with an http/https scheme.
    // A local file path will not.
    if (uri != null && uri.isAbsolute) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Tooltip(
          message: error.toString(),
          child: Icon(
            Icons.broken_image,
            size: width,
            color: Colors.grey,
            key: const ValueKey('broken_network_image_icon'),
          ),
        ),
      );
    } else {
      // It's a local file path
      return Image.file(
        File(imageUrl!),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Tooltip(
          message: error.toString(),
          child: Icon(
            Icons.broken_image,
            size: width,
            color: Colors.grey,
            key: const ValueKey('broken_local_image_icon'),
          ),
        ),
      );
    }
  }
}
