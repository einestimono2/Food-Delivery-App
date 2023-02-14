import 'dart:convert';

import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? id;
  final String name;
  final String description;
  final String? image;

  const Category({
    this.id,
    required this.name,
    required this.description,
    this.image,
  });

  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [id, name, description, image];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      if (image != null) 'image': image,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['_id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image']['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
}
