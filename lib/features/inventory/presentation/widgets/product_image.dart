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
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(Icons.image, size: width, color: Colors.grey);
    }

    // Check if the imageUrl is a local file path or a full URL
    if (imageUrl!.startsWith('/')) {
      // This handles local file paths for images that have just been picked
      // and not yet uploaded.
      return Image.file(
        File(imageUrl!),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.broken_image, size: width, color: Colors.grey, key: const ValueKey('broken_local_image_icon')),
      );
    }

    // At this point, the imageUrl should be a full URL from the backend (Cloudinary).
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
      errorWidget: (context, url, error) =>
          Tooltip(message: error.toString(), child: Icon(Icons.broken_image, size: width, color: Colors.grey, key: const ValueKey('broken_network_image_icon'))),
    );
  }
}
