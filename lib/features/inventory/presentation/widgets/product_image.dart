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

    // Check if the imageUrl is a local file path
    if (imageUrl!.startsWith('/')) {
      return Image.file(
        File(imageUrl!),
        width: width,
        height: height,
        fit: fit,
      );
    }

    // The image URL from the backend will be a relative path, e.g., /images/some_image.jpg
    // We need to prepend the base URL of the backend to make it a full URL.
    final fullImageUrl = imageUrl!.startsWith('http')
        ? imageUrl
        : 'http://38.244.208.106:8000$imageUrl';

    return CachedNetworkImage(
      imageUrl: fullImageUrl!,
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
          Icon(Icons.broken_image, size: width, color: Colors.grey),
    );
  }
}