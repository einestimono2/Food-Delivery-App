import 'dart:convert';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id;
  final String? restaurant;
  final String category;
  final String name;
  final String description;
  final String image;
  final double price;
  final bool isFeatured;

  const Product({
    this.id,
    this.restaurant,
    this.isFeatured = false,
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
  });

  @override
  List<Object?> get props => [
        id,
        restaurant,
        name,
        category,
        description,
        price,
        image,
        isFeatured,
      ];

  Product copyWith({
    String? id,
    String? restaurant,
    String? category,
    String? name,
    String? description,
    String? image,
    double? price,
    bool? isFeatured,
  }) {
    return Product(
      id: id ?? this.id,
      restaurant: restaurant ?? this.restaurant,
      category: category ?? this.category,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurant': restaurant,
      'category': category,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'isFeatured': isFeatured,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'],
      restaurant: map['restaurant'],
      category: map['category'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image']['url'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
