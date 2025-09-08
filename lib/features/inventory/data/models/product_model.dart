import 'package:easy_box/features/inventory/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.sku,
    required super.quantity,
    super.location,
    super.imageUrl,
    super.thumbnailUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    const String baseUrl = 'http://38.244.208.106:8000';

    String? getAbsoluteUrl(String? relativeUrl) {
      if (relativeUrl == null || relativeUrl.isEmpty) return null;
      if (Uri.tryParse(relativeUrl)?.isAbsolute ?? false) return relativeUrl;
      return baseUrl + relativeUrl;
    }

    return ProductModel(
      id: json['id'].toString(),
      name: json['name'],
      sku: json['sku'],
      quantity: json['quantity'],
      location: json['location'],
      imageUrl: getAbsoluteUrl(json['image_url']),
      thumbnailUrl: getAbsoluteUrl(json['thumbnail_url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'quantity': quantity,
      'location': location,
      'image_url': imageUrl,
      'thumbnail_url': thumbnailUrl,
    };
  }
}
