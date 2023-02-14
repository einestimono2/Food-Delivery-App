import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'models.dart';

class Restaurant extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final List<String> images;
  final List<String> tags;
  final List<Category>? categories;
  final List<Product>? products;
  final List<OpeningHours>? openingHours;
  final Place address;
  final bool isPopular;

  const Restaurant({
    this.id,
    required this.name,
    this.description,
    required this.images,
    required this.tags,
    this.categories,
    this.products,
    this.openingHours,
    required this.address,
    required this.isPopular,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      images,
      tags,
      categories,
      products,
      openingHours,
      address,
      isPopular,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (description != null) 'description': description,
      'images': images,
      'tags': tags,
      if (categories != null && categories!.isNotEmpty)
        'categories': categories!.map((x) => x.id).toList(),
      'address': address.toMap(),
      'isPopular': isPopular,
      if (openingHours != null)
        'openingHours': openingHours!.map((e) => e.toMap()).toList(),
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['_id'],
      name: map['name'] ?? '',
      description: map['description'],
      images: List<String>.from(map['images'].map((e) => e['url'].toString())),
      tags: List<String>.from(map['tags']),
      categories: map['categories'] != null
          ? List<Category>.from(
              map['categories'].map((x) => Category.fromMap(x)),
            )
          : null,
      products: map['products'] != null
          ? List<Product>.from(map['products'].map((x) {
              return Product.fromMap(x);
            }))
          : null,
      openingHours: map['openingHours'] != null
          ? List<OpeningHours>.from(
              map['openingHours']?.map((x) => OpeningHours.fromMap(x)))
          : null,
      address: Place.fromMap(map['address']),
      isPopular: map['isPopular'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Restaurant.fromJson(String source) =>
      Restaurant.fromMap(json.decode(source));
}
